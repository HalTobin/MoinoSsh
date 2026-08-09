import 'package:domain/model/image_file.dart';
import 'package:domain/model/sftp/remote_file_item.dart';
import 'package:domain/model/text_file.dart';

import '../model/sftp/download_item.dart';

abstract interface class SftpService {

    Stream<List<DownloadItem>> get downloadTasksStream;
    List<DownloadItem> get currentDownloadTasks;

    Future<ListFileResult> listDirectory(String path);

    Future<void> closeSession();

    Future<bool> exists(String path);

    Future<bool> delete(String path);

    Future<bool> createDirectory(String path);

    Future<bool> createFile(String path);

    Future<bool> rename(String sourcePath, String destPath);

    Future<bool> uploadFile(String localPath, String remoteTargetPath);

    Future<bool> downloadFile(String remotePath, String localTargetPath);

    Future<void> cancelDownload(int downloadSessionId);

    Future<TextFile?> readFileAsString(String filePath);

    Future<ImageFile?> readFileAsBytes(String filePath);

    Future<bool> writeStringFile(String filePath, String content);

}