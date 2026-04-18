import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:collection/collection.dart';

enum FileType {
    text(
        identifier: "text",
        name: "Text",
        extensions: ["txt"],
        icon: LucideIcons.fileText,
        openable: true
    ),
    document(
        identifier: "document",
        name: "Document",
        extensions: ["pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "odt", "ods", "odp", "rtf", "pages", "numbers", "key"],
        icon: LucideIcons.fileText
    ),
    database(
        identifier: "database",
        name: "Database",
        extensions: ["db", "sql", "sqlite", "sqlite3", "sqlite"],
        icon: LucideIcons.database
    ),
    code(
        identifier: "code",
        name: "Code",
        extensions: [
            "kt", "java", "js", "ts", "dart",
            "html", "htm", "css", "scss", "sass", "less", "php", "svelte",
            "py", "rb", "go", "rs", "c", "cpp", "h", "hpp", "cs", "swift", "sh",
            "json", "yaml", "yml", "xml", "toml", "sql",
            "jsx", "tsx", "vue", "gradle", "bat"
        ],
        icon: LucideIcons.fileCode,
        openable: true
    ),
    archive(
        identifier: "archive",
        name: "Archive",
        extensions: ["zip", "rar", "jar", "tar", "tgz", "gz", "7z", "bz2", "xz", "iso", "zipx"],
        icon: LucideIcons.fileArchive
    ),
    executable(
        identifier: "executable",
        name: "Executable",
        extensions: ["exe", "msi", "app", "dmg", "apk", "aab", "ipa", "bat", "cmd", "sh", "run", "bin", "com", "gadget"],
        icon: LucideIcons.fileCog
    ),
    audio(
        identifier: "audio",
        name: "Audio",
        extensions: ["mp3", "wav", "ogg", "m4a", "flac"],
        icon: LucideIcons.fileMusic,
    ),
    image(
        identifier: "image",
        name: "Image",
        extensions: ["jpg", "jpeg", "png", "gif", "bmp"],
        icon: LucideIcons.fileImage
    ),
    video(
        identifier: "video",
        name: "Video",
        extensions: ["mp4", "avi", "mkv", "mov"],
        icon: LucideIcons.fileVideoCamera
    );

    const FileType({
        required this.identifier,
        required this.name,
        required this.extensions,
        required this.icon,
        this.openable = false
    });

    final String identifier;
    final String name;
    final List<String> extensions;
    final IconData? icon;
    final bool openable;

    static FileType? fromIdentifier(String fileTypeIdentifier) {
        return FileType.values.firstWhereOrNull(
                (element) => element.identifier == fileTypeIdentifier
        );
    }

    static FileType? fromExtension(String extension) {
        return FileType.values.firstWhereOrNull(
            (element) => element.extensions.contains(extension)
       );
    }

    static FileType? fromPath(String path) {
        final extension = path.split(".").last;
        return FileType.fromExtension(extension);
    }

}