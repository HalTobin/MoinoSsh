import 'package:domain/model/image_file.dart';
import 'package:domain/model/response_result.dart';
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

    /// Creates [path]. [mode] are POSIX permission bits; when omitted the remote
    /// applies its own default, which may be more permissive than intended.
    Future<bool> createDirectory(String path, {int? mode});

    Future<bool> createFile(String path);

    Future<bool> rename(String sourcePath, String destPath);

    Future<bool> uploadFile(String localPath, String remoteTargetPath);

    Future<bool> downloadFile(String remotePath, String localTargetPath);

    Future<void> cancelDownload(int downloadSessionId);

    Future<TextFile?> readFileAsString(String filePath);

    /// Reads [filePath] as text, telling apart "the file is not there" from
    /// "the file could not be read".
    ///
    /// [ResponseSucceed] with a null payload means the remote confirmed the file
    /// does not exist. Any other problem (no session, denied, unreadable bytes)
    /// is a [ResponseFailed] so callers never mistake a failure for empty content.
    Future<ResponseResult<TextFile?>> readTextFileIfExists(String filePath);

    Future<ImageFile?> readFileAsBytes(String filePath);

    Future<bool> writeStringFile(String filePath, String content);

    /// Replaces [filePath] with [content] without ever exposing a partially
    /// written file: the content is staged next to the target, verified, then
    /// swapped in. The previous file is kept until the swap succeeds.
    Future<ResponseResult<bool>> writeStringFileAtomically(
        String filePath,
        String content,
    );

}