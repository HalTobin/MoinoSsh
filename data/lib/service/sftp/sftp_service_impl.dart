import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:data/service/ssh_client_service_impl.dart';
import 'package:domain/model/image_file.dart';
import 'package:domain/model/response_result.dart';
import 'package:domain/model/sftp/download_item.dart';
import 'package:domain/model/sftp/remote_file_item.dart';
import 'package:domain/model/text_file.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class SftpServiceImpl implements SftpService {
    late final SshClientServiceImpl _sshClientService;

    static SftpServiceImpl? _instance;

    SftpServiceImpl._internal(this._sshClientService);

    factory SftpServiceImpl(SshClientServiceImpl service) {
        _instance ??= SftpServiceImpl._internal(service);
        return _instance!;
    }

    SftpClient? _sftpClient;
    SSHClient? _sftpClientOwner;
    Future<SftpClient?>? _pendingSftpClient;

    Future<SftpClient?> getSftpClient() async {
        final sshClient = _sshClientService.getClient();
        if (sshClient == null || sshClient.isClosed) {
            if (kDebugMode) print("[$tag] Cannot get SFTP client: SSHClient is unavailable");
            _discardCachedClient();
            return null;
        }

        // A cached SFTP session belongs to the SSH connection that opened it.
        // Reusing it after a reconnect yields a dead session whose failures look
        // like missing files to callers.
        if (_sftpClient != null && identical(_sftpClientOwner, sshClient)) {
            return _sftpClient;
        }
        _discardCachedClient();

        return _pendingSftpClient ??= _openSftpClient(sshClient);
    }

    Future<SftpClient?> _openSftpClient(SSHClient sshClient) async {
        try {
            final client = await sshClient.sftp();
            _sftpClient = client;
            _sftpClientOwner = sshClient;
            return client;
        } catch (e) {
            if (kDebugMode) print("[$tag] Could not open SFTP session: $e");
            return null;
        } finally {
            _pendingSftpClient = null;
        }
    }

    void _discardCachedClient() {
        _sftpClient = null;
        _sftpClientOwner = null;
    }

    final Map<int, StreamSubscription<dynamic>> _activeSubscriptions = {};
    final Map<int, _TransferProgressSample> _progressSamples = {};
    final _tasksController = StreamController<List<DownloadItem>>.broadcast();
    final List<DownloadItem> _tasks = [];
    int _nextSessionId = 0;

    @override
    Stream<List<DownloadItem>> get downloadTasksStream => _tasksController.stream;

    @override
    List<DownloadItem> get currentDownloadTasks => List.unmodifiable(_tasks);

    void _updateTaskState(int id, DownloadState newState) {
        final index = _tasks.indexWhere((t) => t.downloadSessionId == id);
        if (index != -1) {
            _tasks[index] = _tasks[index].copyWith(state: newState);
            _tasksController.add(List.from(_tasks));
        }
    }

    int _currentTransferredBytes(int sessionId) {
        final index = _tasks.indexWhere((t) => t.downloadSessionId == sessionId);
        if (index == -1) {
            return 0;
        }
        return _tasks[index].state.transferredBytes;
    }

    void _updateTransferProgress({
        required int sessionId,
        required int transferredBytes,
        required int totalSize,
    }) {
        final now = DateTime.now();
        final sample = _progressSamples[sessionId];
        double bytesPerSecond = 0;

        if (sample != null) {
            final elapsedSeconds =
                now.difference(sample.timestamp).inMicroseconds / 1e6;
            if (elapsedSeconds > 0.05) {
                final instant =
                    (transferredBytes - sample.transferredBytes) / elapsedSeconds;
                bytesPerSecond = sample.bytesPerSecond <= 0
                    ? instant
                    : (sample.bytesPerSecond * 0.7) + (instant * 0.3);
            } else {
                bytesPerSecond = sample.bytesPerSecond;
            }
        }

        _progressSamples[sessionId] = _TransferProgressSample(
            timestamp: now,
            transferredBytes: transferredBytes,
            bytesPerSecond: bytesPerSecond < 0 ? 0 : bytesPerSecond,
        );

        final progress = totalSize > 0 ? transferredBytes / totalSize : 0.0;
        _updateTaskState(
            sessionId,
            Downloading(
                progress: progress,
                downloadedBytes: transferredBytes,
                bytesPerSecond: bytesPerSecond < 0 ? 0 : bytesPerSecond,
            ),
        );
    }

    void _clearProgressSample(int sessionId) {
        _progressSamples.remove(sessionId);
    }

    @override
    Future<ListFileResult> listDirectory(String path) async {
        final sftp = await getSftpClient();
        if (kDebugMode) {
            print("Listing: $path");
        }
        if (sftp == null) {
            if (kDebugMode) print("Cannot list directory: SFTP client is null");
            return ListFileFail(errorMessage: "SFTP client is null");
        }

        try {
            final entries = await sftp.listdir(path);
            final items = <RemoteFileItem>[];

            for (final entry in entries) {
                if (entry.filename == '.' || entry.filename == '..') continue;

                final attrs = entry.attr;

                items.add(
                    RemoteFileItem(
                        name: entry.filename,
                        isDirectory: attrs.isDirectory,
                        size: attrs.size ?? 0,
                        lastModified: attrs.modifyTime != null
                            ? DateTime.fromMillisecondsSinceEpoch(attrs.modifyTime! * 1000)
                            : null,
                        permissions: attrs.mode?.toString(),
                    )
                );
            }

            return ListFileSuccess(files: items);
        } catch (e) {
            if (kDebugMode) print("Error listing directory $path: $e");
            return ListFileFail(errorMessage: "ERROR: $e");
        }
    }

    @override
    Future<void> closeSession() async {
        _sftpClient?.close();
        _discardCachedClient();
    }

    @override
    Future<bool> exists(String path) async {
        final sftp = await getSftpClient();
        if (sftp == null) {
            if (kDebugMode) print("Cannot check existence: SFTP client is null");
            return false;
        }

        try {
            await sftp.stat(path);
            return true;
        } catch (e) {
            return false;
        }
    }

    @override
    Future<bool> delete(String path) async {
        final sftp = await getSftpClient();
        if (sftp == null) {
            if (kDebugMode) print("Cannot delete: SFTP client is null");
            throw StateError("SFTP client is not initialized.");
        }

        try {
            final stat = await sftp.stat(path);
            if (stat.isDirectory) {
                await sftp.rmdir(path);
            } else {
                await sftp.remove(path);
            }
            return true;
        } catch (e) {
            if (kDebugMode) print("Error deleting item at path $path: $e");
            return false;
        }
    }

    @override
    Future<bool> createDirectory(String path, {int? mode}) async {
        try {
            final sftp = await getSftpClient();
            if (sftp == null) {
                if (kDebugMode) print("Cannot create directory: SFTP client is null");
                return false;
            }
            await sftp.mkdir(
                path,
                mode == null
                    ? null
                    : SftpFileAttrs(mode: SftpFileMode.value(mode & _permissionMask)),
            );
            return true;
        } catch (e) {
            if (kDebugMode) print("Couldn't create directory: $path: $e");
            return false;
        }
    }

    @override
    Future<bool> createFile(String path) async {
        try {
            final sftp = await getSftpClient();
            if (sftp == null) {
                if (kDebugMode) print("Cannot create file: SFTP client is null");
                return false;
            }
            final file = await sftp.open(
                path,
                mode: SftpFileOpenMode.create | SftpFileOpenMode.write,
            );
            await file.close();
            return true;
        } catch (e) {
            if (kDebugMode) print("Couldn't create file: $path: $e");
            return false;
        }
    }

    @override
    Future<bool> rename(String sourcePath, String destPath) async {
        try {
            final sftp = await getSftpClient();
            await sftp?.rename(sourcePath, destPath);
            return true;
        } catch (e) {
            if (kDebugMode) print("Couldn't rename file: $sourcePath: $e");
            return false;
        }
    }

    @override
    Future<bool> uploadFile(String localPath, String remoteTargetPath) async {
        final sftp = await getSftpClient();
        if (sftp == null) return false;

        final localFile = File(localPath);
        if (!await localFile.exists()) return false;

        final int totalSize = await localFile.length();
        final int sessionId = _nextSessionId++;

        final task = DownloadItem(
            downloadSessionId: sessionId,
            filePath: localPath,
            fileName: p.basename(localPath),
            targetPath: remoteTargetPath,
            size: totalSize,
            origin: DownloadOrigin.local,
            state: const Downloading(progress: 0.0, downloadedBytes: 0),
        );
        _tasks.add(task);
        _tasksController.add(List.from(_tasks));

        unawaited(() async {
            SftpFile? remoteFile;
            StreamSubscription<List<int>>? subscription;
            try {
                remoteFile = await sftp.open(
                    remoteTargetPath,
                    mode: SftpFileOpenMode.create | SftpFileOpenMode.write | SftpFileOpenMode.truncate,
                );

                int uploadedBytes = 0;

                subscription = localFile.openRead().listen(
                        (chunk) async {
                        if (!_activeSubscriptions.containsKey(sessionId)) return;

                        subscription?.pause();
                        await remoteFile?.writeBytes(Uint8List.fromList(chunk));

                        uploadedBytes += chunk.length;
                        _updateTransferProgress(
                            sessionId: sessionId,
                            transferredBytes: uploadedBytes,
                            totalSize: totalSize,
                        );

                        subscription?.resume();
                    },
                    onDone: () async {
                        await remoteFile?.close();
                        _activeSubscriptions.remove(sessionId);
                        _clearProgressSample(sessionId);
                        _updateTaskState(
                            sessionId,
                            DownloadCompleted(
                                transferredBytes: totalSize > 0 ? totalSize : uploadedBytes,
                            ),
                        );
                    },
                    onError: (e) {
                        throw e;
                    },
                    cancelOnError: true,
                );

                _activeSubscriptions[sessionId] = subscription;
            } catch (e) {
                await remoteFile?.close();
                _activeSubscriptions.remove(sessionId);
                _clearProgressSample(sessionId);
                _updateTaskState(
                    sessionId,
                    DownloadFailed(transferredBytes: _currentTransferredBytes(sessionId)),
                );
            }
        }());

        return true;
    }

    @override
    Future<bool> downloadFile(String remotePath, String localTargetPath) async {
        final sftp = await getSftpClient();
        if (sftp == null) return false;

        try {
            final stat = await sftp.stat(remotePath);
            final int totalSize = stat.size ?? 0;
            final int sessionId = _nextSessionId++;

            final task = DownloadItem(
                downloadSessionId: sessionId,
                filePath: remotePath,
                fileName: p.basename(remotePath),
                targetPath: localTargetPath,
                size: totalSize,
                origin: DownloadOrigin.remote,
                state: const Downloading(progress: 0.0, downloadedBytes: 0),
            );
            _tasks.add(task);
            _tasksController.add(List.from(_tasks));

            unawaited(() async {
                SftpFile? remoteFile;
                StreamSubscription<Uint8List>? subscription;
                IOSink? localSink;
                var transferredBytes = 0;
                try {
                    remoteFile = await sftp.open(remotePath);
                    final localFile = File(localTargetPath);
                    localSink = localFile.openWrite();

                    subscription = remoteFile.read(
                        onProgress: (int bytesDownloaded) {
                            transferredBytes = bytesDownloaded;
                            _updateTransferProgress(
                                sessionId: sessionId,
                                transferredBytes: bytesDownloaded,
                                totalSize: totalSize,
                            );
                        },
                    ).listen(
                            (chunk) {
                            localSink?.add(chunk);
                        },
                        onDone: () async {
                            await localSink?.close();
                            await remoteFile?.close();
                            _activeSubscriptions.remove(sessionId);
                            _clearProgressSample(sessionId);
                            _updateTaskState(
                                sessionId,
                                DownloadCompleted(
                                    transferredBytes:
                                        totalSize > 0 ? totalSize : transferredBytes,
                                ),
                            );
                        },
                        onError: (e) {
                            throw e;
                        },
                        cancelOnError: true,
                    );

                    _activeSubscriptions[sessionId] = subscription;
                } catch (e) {
                    await localSink?.close();
                    await remoteFile?.close();
                    _activeSubscriptions.remove(sessionId);
                    _clearProgressSample(sessionId);
                    _updateTaskState(
                        sessionId,
                        DownloadFailed(transferredBytes: transferredBytes),
                    );
                }
            }());

            return true;
        } catch (e) {
            if (kDebugMode) print("Failed to initialize download: $e");
            return false;
        }
    }

    @override
    Future<void> cancelDownload(int downloadSessionId) async {
        final subscription = _activeSubscriptions[downloadSessionId];
        if (subscription != null) {
            final transferredBytes = _currentTransferredBytes(downloadSessionId);
            await subscription.cancel();
            _activeSubscriptions.remove(downloadSessionId);
            _clearProgressSample(downloadSessionId);
            _updateTaskState(
                downloadSessionId,
                DownloadCanceled(transferredBytes: transferredBytes),
            );
        }
    }

    @override
    Future<TextFile?> readFileAsString(String filePath) async {
        final result = await readTextFileIfExists(filePath);
        return switch (result) {
            ResponseSucceed(data: final file) => file,
            ResponseFailed(error: final error) => () {
                if (kDebugMode) {
                    print("[$tag] $error");
                }
                return null;
            }(),
        };
    }

    @override
    Future<ResponseResult<TextFile?>> readTextFileIfExists(String filePath) async {
        final sftp = await getSftpClient();
        if (sftp == null) {
            return ResponseFailed(error: 'Not connected to the remote server');
        }

        SftpFile? file;
        try {
            final attrs = await sftp.stat(filePath);
            file = await sftp.open(filePath);

            final List<int> bytes = [];
            await for (final chunk in file.read()) {
                bytes.addAll(chunk);
            }

            return ResponseSucceed(
                TextFile(
                    name: p.posix.basename(filePath),
                    isEditable: attrs.mode?.userWrite ?? false,
                    content: utf8.decode(bytes),
                ),
            );
        } on SftpStatusError catch (e) {
            if (e.code == SftpStatusCode.noSuchFile) {
                return ResponseSucceed(null);
            }
            if (kDebugMode) print("[$tag] Could not read $filePath: $e");
            return ResponseFailed(error: 'Could not read $filePath: ${e.message}');
        } catch (e) {
            if (kDebugMode) print("[$tag] Could not read $filePath: $e");
            return ResponseFailed(error: 'Could not read $filePath: $e');
        } finally {
            await file?.close();
        }
    }

    @override
    Future<ImageFile?> readFileAsBytes(String filePath) async {
        final sftp = await getSftpClient();

        if (sftp == null) {
            if (kDebugMode) {
                print("[$tag] SFTP client is null");
            }
            return null;
        }

        final file = await sftp.open(filePath);

        try {
            final List<int> bytes = [];
            await for (final chunk in file.read()) {
                bytes.addAll(chunk);
            }

            final attrs = await sftp.stat(filePath);
            final name = p.basename(filePath);
            final lastModified = attrs.modifyTime != null
                ? DateTime.fromMillisecondsSinceEpoch(attrs.modifyTime! * 1000)
                : null;

            return ImageFile(
                name: name,
                path: filePath,
                bytes: Uint8List.fromList(bytes),
                lastModified: lastModified,
                size: attrs.size ?? bytes.length,
            );
        } catch (e) {
            if (kDebugMode) {
                print("[$tag] Error reading file bytes at $filePath: $e");
            }
            rethrow;
        } finally {
            await file.close();
        }
    }

    @override
    Future<bool> writeStringFile(String filePath, String content) async {
        try {
            final sftp = await getSftpClient();
            if (sftp == null) {
                if (kDebugMode) print("Cannot write file: SFTP client is null");
                return false;
            }

            final file = await sftp.open(
                filePath,
                mode: SftpFileOpenMode.create | SftpFileOpenMode.write | SftpFileOpenMode.truncate,
            );

            final List<int> bytes = utf8.encode(content);
            final Uint8List uint8Bytes = Uint8List.fromList(bytes);
            await file.writeBytes(uint8Bytes);
            await file.close();

            return true;
        } catch (e) {
            if (kDebugMode) print("Couldn't write content for file $filePath: $e");
            return false;
        }
    }

    @override
    Future<ResponseResult<bool>> writeStringFileAtomically(
        String filePath,
        String content,
    ) async {
        final sftp = await getSftpClient();
        if (sftp == null) {
            return ResponseFailed(error: 'Not connected to the remote server');
        }

        final bytes = Uint8List.fromList(utf8.encode(content));
        final directory = p.posix.dirname(filePath);
        final fileName = p.posix.basename(filePath);
        final marker = DateTime.now().microsecondsSinceEpoch;
        final stagingPath = p.posix.join(directory, '.$fileName.moino-$marker.new');
        final backupPath = p.posix.join(directory, '.$fileName.moino-$marker.old');

        try {
            final currentAttrs = await _statOrNull(sftp, filePath);
            final mode = currentAttrs?.mode;

            await _stageContent(
                sftp,
                stagingPath: stagingPath,
                bytes: bytes,
                mode: mode != null ? _permissionsOf(mode) : _ownerOnlyFileMode,
            );

            final stagedSize = (await sftp.stat(stagingPath)).size;
            if (stagedSize != null && stagedSize != bytes.length) {
                await _removeOrIgnore(sftp, stagingPath);
                return ResponseFailed(
                    error: 'Upload was incomplete: $stagedSize of ${bytes.length} bytes written',
                );
            }

            return await _swapIntoPlace(
                sftp,
                stagingPath: stagingPath,
                filePath: filePath,
                backupPath: backupPath,
                replacesExistingFile: currentAttrs != null,
            );
        } catch (e) {
            if (kDebugMode) print("[$tag] Atomic write of $filePath failed: $e");
            await _removeOrIgnore(sftp, stagingPath);
            return ResponseFailed(error: 'Could not write $filePath: $e');
        }
    }

    Future<void> _stageContent(
        SftpClient sftp, {
        required String stagingPath,
        required Uint8List bytes,
        required SftpFileMode mode,
    }) async {
        final staged = await sftp.open(
            stagingPath,
            mode: SftpFileOpenMode.create |
                SftpFileOpenMode.exclusive |
                SftpFileOpenMode.write,
        );
        try {
            await staged.writeBytes(bytes);
        } finally {
            await staged.close();
        }
        // The staged file replaces the target by name, so it has to carry the
        // target's permissions instead of whatever the remote umask produced.
        await sftp.setStat(stagingPath, SftpFileAttrs(mode: mode));
    }

    Future<ResponseResult<bool>> _swapIntoPlace(
        SftpClient sftp, {
        required String stagingPath,
        required String filePath,
        required String backupPath,
        required bool replacesExistingFile,
    }) async {
        var hasBackup = false;
        if (replacesExistingFile) {
            await sftp.rename(filePath, backupPath);
            hasBackup = true;
        }

        try {
            await sftp.rename(stagingPath, filePath);
        } catch (e) {
            if (hasBackup) {
                await _renameOrIgnore(sftp, backupPath, filePath);
            }
            await _removeOrIgnore(sftp, stagingPath);
            if (kDebugMode) print("[$tag] Could not move $stagingPath to $filePath: $e");
            return ResponseFailed(error: 'Could not replace $filePath: $e');
        }

        if (hasBackup) {
            await _removeOrIgnore(sftp, backupPath);
        }
        return ResponseSucceed(true);
    }

    Future<SftpFileAttrs?> _statOrNull(SftpClient sftp, String path) async {
        try {
            return await sftp.stat(path);
        } on SftpStatusError catch (e) {
            if (e.code == SftpStatusCode.noSuchFile) {
                return null;
            }
            rethrow;
        }
    }

    Future<void> _removeOrIgnore(SftpClient sftp, String path) async {
        try {
            await sftp.remove(path);
        } catch (e) {
            if (kDebugMode) print("[$tag] Could not remove $path: $e");
        }
    }

    Future<void> _renameOrIgnore(
        SftpClient sftp,
        String sourcePath,
        String destPath,
    ) async {
        try {
            await sftp.rename(sourcePath, destPath);
        } catch (e) {
            if (kDebugMode) print("[$tag] Could not restore $destPath from $sourcePath: $e");
        }
    }

    static SftpFileMode _permissionsOf(SftpFileMode mode) {
        return SftpFileMode.value(mode.value & _permissionMask);
    }

    static const int _permissionMask = 0xFFF;

    static final SftpFileMode _ownerOnlyFileMode = SftpFileMode(
        userRead: true,
        userWrite: true,
        userExecute: false,
        groupRead: false,
        groupWrite: false,
        groupExecute: false,
        otherRead: false,
        otherWrite: false,
        otherExecute: false,
    );

    static const String tag = "SftpServiceImpl";

}

class _TransferProgressSample {
    final DateTime timestamp;
    final int transferredBytes;
    final double bytesPerSecond;

    const _TransferProgressSample({
        required this.timestamp,
        required this.transferredBytes,
        required this.bytesPerSecond,
    });
}