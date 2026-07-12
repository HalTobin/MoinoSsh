import 'package:domain/model/file_item.dart';

abstract interface class FileRepository {

    Future<String> getInternalDirectory();

    Future<String> getInternalDirectoryPathForFolder(String folder);

    Future<List<FileItem>> listInternalFolderContent(String folder);

    Future<List<FileItem>> listFolderContent(String path);

    Future<FileItem?> copyFile(String from, String destination);

    Future<FileItem?> copyFileInternal(String from, String internalFolder);

    Future<FileItem?> rename(String from, String newName);

    Future<void> deleteFile(String path);

}