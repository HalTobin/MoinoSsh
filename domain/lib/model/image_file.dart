import 'dart:typed_data';

class ImageFile {
    final String name;
    final String path;
    final Uint8List bytes;
    final DateTime? lastModified;
    final int size;

    const ImageFile({
        required this.name,
        required this.path,
        required this.bytes,
        required this.lastModified,
        required this.size,
    });
}
