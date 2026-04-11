import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

@internal
extension Utf8OutputExtension on Stream<List<int>> {
    /// Collects the stream of bytes and decodes it as a UTF-8 string.
    Future<String> decodeUtf8() async {
        final outputBytes = await fold<BytesBuilder>(
            BytesBuilder(),
              (builder, data) => builder..add(data),
        );
        return utf8.decode(outputBytes.takeBytes());
    }
}