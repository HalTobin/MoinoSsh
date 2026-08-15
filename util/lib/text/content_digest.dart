import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/digests/sha256.dart';

/// SHA-256 of text content, used to notice that a remote file changed between
/// reading it and writing it back.
class ContentDigest {
    const ContentDigest._();

    static String of(String content) {
        final digest = SHA256Digest().process(
            Uint8List.fromList(utf8.encode(content)),
        );
        return digest
            .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
            .join();
    }
}
