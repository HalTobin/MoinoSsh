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
    Future<List<RemoteFileItem>> listDirectory(String path) {
        // TODO: implement listDirectory
        throw UnimplementedError();
    }

    @override
    Future<void> closeSession() async {
        _sftpClient?.close();
        _sftpClient = null;
    }

    @override
    Future<bool> exists(String path) {
        // TODO: implement exists
       throw UnimplementedError();
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