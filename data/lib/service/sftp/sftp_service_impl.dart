import 'package:dartssh2/dartssh2.dart';
import 'package:data/service/ssh/ssh_service_impl.dart';
import 'package:domain/model/sftp/remote_file_item.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:domain/service/ssh_service.dart';

class SftpServiceImpl extends SftpService {
    SshServiceImpl _sshService;

    SftpServiceImpl(this._sshService);

    SftpClient? _sftpClient;

    Future<SftpClient?> getSftpClient() async {
        if (_sftpClient != null) {
            return _sftpClient;
        }
        if (_sshService.getCurrentProfile() == null) {
            if (kDebugMode) print("Cannot get SFTP client: SSHClient is null");
            return null;
        }
        return await _client!.sftp();
    }

    @override
    Future<List<RemoteFileItem>> listDirectory(String path) {
        // TODO: implement listDirectory
        throw UnimplementedError();
    }

    @override
    Future<void> closeSession() {
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