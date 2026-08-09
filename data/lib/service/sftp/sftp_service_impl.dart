import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:data/service/ssh_client_service_impl.dart';
import 'package:domain/model/image_file.dart';
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

    Future<SftpClient?> getSftpClient() async {
        if (_sftpClient != null) {
            return _sftpClient;
        }
        final sshClient = _sshClientService.getClient();
        if (sshClient != null) {
            _sftpClient = await sshClient.sftp();
            return _sftpClient;
        }
        else {
            if (kDebugMode) print("[$tag] Cannot get SFTP client: SSHClient is null");
            return null;
        }
    }

    final Map<int, StreamSubscription<dynamic>> _activeSubscriptions = {};
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
        _sftpClient = null;
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
    Future<bool> createDirectory(String path) async {
        try {
            final sftp = await getSftpClient();
            if (sftp == null) {
                if (kDebugMode) print("Cannot create directory: SFTP client is null");
                return false;
            }
            await sftp.mkdir(path);
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
            state: Downloading(progress: 0.0, downloadedBytes: 0),
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
                        double progress = totalSize > 0 ? uploadedBytes / totalSize : 0.0;
                        _updateTaskState(sessionId, Downloading(progress: progress, downloadedBytes: uploadedBytes));

                        subscription?.resume();
                    },
                    onDone: () async {
                        await remoteFile?.close();
                        _activeSubscriptions.remove(sessionId);
                        _updateTaskState(sessionId, DownloadCompleted());
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
                _updateTaskState(sessionId, DownloadFailed());
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
                state: Downloading(progress: 0.0, downloadedBytes: 0),
            );
            _tasks.add(task);
            _tasksController.add(List.from(_tasks));

            unawaited(() async {
                SftpFile? remoteFile;
                StreamSubscription<Uint8List>? subscription;
                IOSink? localSink;
                try {
                    remoteFile = await sftp.open(remotePath);
                    final localFile = File(localTargetPath);
                    localSink = localFile.openWrite();

                    subscription = remoteFile.read(
                        onProgress: (int bytesDownloaded) {
                            double progress = totalSize > 0 ? bytesDownloaded / totalSize : 0.0;
                            _updateTaskState(sessionId, Downloading(progress: progress, downloadedBytes: bytesDownloaded));
                        },
                    ).listen(
                            (chunk) {
                            localSink?.add(chunk);
                        },
                        onDone: () async {
                            await localSink?.close();
                            await remoteFile?.close();
                            _activeSubscriptions.remove(sessionId);
                            _updateTaskState(sessionId, DownloadCompleted());
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
                    _updateTaskState(sessionId, DownloadFailed());
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
            await subscription.cancel();
            _activeSubscriptions.remove(downloadSessionId);
            _updateTaskState(downloadSessionId, DownloadCanceled());
        }
    }

    @override
    Future<TextFile?> readFileAsString(String filePath) async {
        final sftp = await getSftpClient();

        if (sftp == null) {
            if (kDebugMode) {
                print("[$tag] SFTP client is null");
            }
        }

        final file = await sftp?.open(filePath);

        if (file == null) {
            if (kDebugMode) {
                print("[$tag] File at $filePath is null");
            }
            return null;
        }

        try {
            final List<int> bytes = [];
            await for (final chunk in file.read()) {
                bytes.addAll(chunk);
            }
            final name = filePath.split("/").last;
            final content = utf8.decode(bytes);

            final sftpFile = await sftp?.stat(filePath);
            final isEditable = sftpFile?.mode?.userWrite ?? false;

            return TextFile(name: name, isEditable: isEditable, content: content);
        } catch (e) {
            if (kDebugMode) {
                print("[$tag] Error reading file at $filePath: $e");
            }
            rethrow;
        } finally {
            await file.close();
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

    static const String tag = "SftpServiceImpl";

}