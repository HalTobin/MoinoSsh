import 'package:domain/model/sftp/remote_file_item.dart';

abstract interface class SftpService {

    Future<ListFileResult> listDirectory(String path);

    Future<void> closeSession();

    Future<bool> exists(String path);

    Future<void> delete(String path);

    Future<void> createDirectory(String path);

    Future<void> rename(String sourcePath, String destPath);

    Future<bool> uploadFile(String localPath, String remoteTargetPath);

    Future<String?> readFileAsString(String filePath);

}