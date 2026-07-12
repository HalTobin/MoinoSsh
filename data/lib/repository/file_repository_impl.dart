import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:domain/model/file_item.dart';
import 'package:domain/repository/file_repository.dart';

class FileRepositoryImpl implements FileRepository {

    @override
    Future<String> getInternalDirectory() async {
        final directory = await getApplicationDocumentsDirectory();
        return directory.path;
    }

    @override
    Future<String> getInternalDirectoryPathForFolder(String folder) async {
        final directory = await getInternalDirectory();
        return p.join(directory, folder);
    }

    @override
    Future<FileItem?> copyFile(String from, String destination) async {
        final sourceFile = File(from);
        if (!await sourceFile.exists()) return null;

        // If destination is a directory, append the source filename
        String finalPath = destination;
        if (await Directory(destination).exists()) {
            finalPath = p.join(destination, p.basename(from));
        }

        final newFile = await sourceFile.copy(finalPath);
        return _toFileItem(newFile);
    }

    @override
    Future<FileItem?> copyFileInternal(String from, String internalFolder) async {
        final targetDirPath = await getInternalDirectoryPathForFolder(internalFolder);

        // Ensure the internal subfolder exists
        await Directory(targetDirPath).create(recursive: true);

        final destination = p.join(targetDirPath, p.basename(from));
        return copyFile(from, destination);
    }

    @override
    Future<void> deleteFile(String path) async {
        final file = File(path);
        if (await file.exists()) {
            await file.delete(recursive: true); // Use recursive for directories
        }
    }

    @override
    Future<List<FileItem>> listInternalFolderContent(String folder) async {
        final targetDirPath = await getInternalDirectoryPathForFolder(folder);
        return listFolderContent(targetDirPath);
    }

    @override
    Future<List<FileItem>> listFolderContent(String path) async {
        // Default to current directory if no path is provided
        final targetPath = path;
        final directory = Directory(targetPath);

        if (!await directory.exists()) return [];

        final List<FileItem> items = [];
        await for (final entity in directory.list()) {
            // In this implementation, we convert both files and directories to FileItems
            items.add(_toFileItem(entity));
        }
        return items;
    }

    @override
    Future<FileItem?> rename(String from, String newName) async {
        final entity = File(from);
        if (!await entity.exists()) return null;

        final parentPath = p.dirname(from);
        final newPath = p.join(parentPath, newName);

        final renamedEntity = await entity.rename(newPath);
        return _toFileItem(renamedEntity);
    }

    /// Helper to convert a FileSystemEntity into your FileItem model
    FileItem _toFileItem(FileSystemEntity entity) {
        final path = entity.path;
        return FileItem(
            name: p.basenameWithoutExtension(path),
            fullName: p.basename(path),
            extension: entity is File ? p.extension(path) : '',
            path: path,
            isDirectory: entity is Directory
        );
    }

}