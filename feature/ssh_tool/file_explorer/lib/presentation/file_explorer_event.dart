import 'package:domain/model/preferences/file_view_mode.dart';

sealed class FileExplorerEvent {}

class OpenFolder extends FileExplorerEvent {
    final String folderPath;

    OpenFolder({required this.folderPath});
}

class SelectFile extends FileExplorerEvent {
    final String filePath;

    SelectFile({required this.filePath});
}

class NavigateRootEvent extends FileExplorerEvent {}

class NavigateUpEvent extends FileExplorerEvent {}

class ToggleHiddenEvent extends FileExplorerEvent {}

class SelectViewMode extends FileExplorerEvent {
    final FileViewMode viewMode;

    SelectViewMode({required this.viewMode});
}

class PinUnpinEvent extends FileExplorerEvent {
    final String? path;

    PinUnpinEvent({this.path});
}

class RenamePinnedFolder extends FileExplorerEvent {
    final String path;
    final String newAlias;

    RenamePinnedFolder({
        required this.path,
        required this.newAlias
    });
}

class EditPinnedFolderIcon extends FileExplorerEvent {
    final String path;
    final int? newIcon;

    EditPinnedFolderIcon({
        required this.path,
        required this.newIcon
    });
}

class DeleteFile extends FileExplorerEvent {
    final String filePath;

    DeleteFile({required this.filePath});
}

class RenameFile extends FileExplorerEvent {
    final String filePath;
    final String newName;

    RenameFile({
        required this.filePath,
        required this.newName
    });
}

class CreateFolder extends FileExplorerEvent {
    final String folderName;

    CreateFolder({required this.folderName});
}

class CreateFile extends FileExplorerEvent {
    final String fileName;

    CreateFile({required this.fileName});
}

class RefreshContent extends FileExplorerEvent {}

class DownloadFile extends FileExplorerEvent {
    final String remoteFilePath;
    final String localeTargetPath;

    DownloadFile({
        required this.remoteFilePath,
        required this.localeTargetPath
    });
}

class UploadFile extends FileExplorerEvent {
    final List<String> localeFilePaths;
    final String remoteTargetPath;

    UploadFile({
        required String localeFilePath,
        required this.remoteTargetPath,
    }) : localeFilePaths = [localeFilePath];

    UploadFile.multiple({
        required this.localeFilePaths,
        required this.remoteTargetPath,
    });
}