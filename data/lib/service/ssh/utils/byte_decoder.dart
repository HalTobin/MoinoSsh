import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

@internal
extension Utf8OutputExtension on Stream<List<int>> {
    /// Collects the stream of bytes and decodes it as a UTF-8 string.
    ///
    /// Set [allowMalformed] for command output, which can carry bytes that are
    /// not valid UTF-8 and should not fail the whole command.
    Future<String> decodeUtf8({bool allowMalformed = false}) async {
        final outputBytes = await fold<BytesBuilder>(
            BytesBuilder(),
              (builder, data) => builder..add(data),
        );
        return utf8.decode(
            outputBytes.takeBytes(),
            allowMalformed: allowMalformed,
        );
    }
}