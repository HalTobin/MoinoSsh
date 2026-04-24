import 'package:dartssh2/dartssh2.dart';
import 'package:data/service/ssh_client_service_impl.dart';
import 'package:domain/model/sftp/remote_file_item.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:flutter/foundation.dart';

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
            if (kDebugMode) print("Cannot get SFTP client: SSHClient is null");
            return null;
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
                // It's usually best to filter out current and parent directory pointers
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
    Future<void> delete(String path) {
        // TODO: implement delete
        throw UnimplementedError();
    }

    @override
    Future<void> createDirectory(String path) {
        // TODO: implement createDirectory
        throw UnimplementedError();
    }

    @override
    Future<void> rename(String sourcePath, String destPath) {
        // TODO: implement rename
        throw UnimplementedError();
    }

    @override
    Future<bool> uploadFile(String localPath, String remoteTargetPath) {
        // TODO: implement uploadFile
        throw UnimplementedError();
    }

}