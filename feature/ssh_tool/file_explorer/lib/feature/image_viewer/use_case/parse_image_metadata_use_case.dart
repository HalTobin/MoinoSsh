import 'dart:ui' as ui;

import 'package:exif/exif.dart';
import 'package:feature_file_explorer/feature/image_viewer/model/image_metadata.dart';
import 'package:flutter/foundation.dart';

class ParseImageMetadataUseCase {
    const ParseImageMetadataUseCase();

    Future<ImageMetadata> execute(Uint8List bytes) async {
        int? width;
        int? height;
        DateTime? captureTime;
        String? location;
        String? colorSpace;

        try {
            final tags = await readExifFromBytes(bytes);

            width = _readIntTag(tags, 'EXIF ExifImageWidth')
                ?? _readIntTag(tags, 'Image ImageWidth');
            height = _readIntTag(tags, 'EXIF ExifImageLength')
                ?? _readIntTag(tags, 'Image ImageLength');

            captureTime = _readDateTime(tags, 'EXIF DateTimeOriginal')
                ?? _readDateTime(tags, 'EXIF DateTimeDigitized')
                ?? _readDateTime(tags, 'Image DateTime');

            location = _readGpsLocation(tags);
            colorSpace = _readColorSpace(tags);
        } catch (e) {
            if (kDebugMode) {
                print("[$_tag] Failed to parse EXIF: $e");
            }
        }

        if (width == null || height == null) {
            final decodedSize = await _decodeImageSize(bytes);
            width ??= decodedSize?.width;
            height ??= decodedSize?.height;
        }

        return ImageMetadata(
            width: width,
            height: height,
            captureTime: captureTime,
            location: location,
            colorSpace: colorSpace,
        );
    }

    Future<({int width, int height})?> _decodeImageSize(Uint8List bytes) async {
        try {
            final codec = await ui.instantiateImageCodec(bytes);
            final frame = await codec.getNextFrame();
            final image = frame.image;
            final size = (width: image.width, height: image.height);
            image.dispose();
            return size;
        } catch (e) {
            if (kDebugMode) {
                print("[$_tag] Failed to decode image size: $e");
            }
            return null;
        }
    }

    int? _readIntTag(Map<String, IfdTag> tags, String key) {
        final value = tags[key]?.printable;
        if (value == null) return null;
        return int.tryParse(value);
    }

    DateTime? _readDateTime(Map<String, IfdTag> tags, String key) {
        final value = tags[key]?.printable;
        if (value == null || value.isEmpty) return null;

        // EXIF format: "yyyy:MM:dd HH:mm:ss"
        final normalized = value.replaceFirstMapped(
            RegExp(r'^(\d{4}):(\d{2}):(\d{2})'),
            (match) => '${match[1]}-${match[2]}-${match[3]}',
        );
        return DateTime.tryParse(normalized);
    }

    String? _readColorSpace(Map<String, IfdTag> tags) {
        final printable = tags['EXIF ColorSpace']?.printable;
        if (printable == null || printable.isEmpty) return null;

        final code = int.tryParse(printable);
        if (code == null) return printable;

        return switch (code) {
            1 => 'sRGB',
            2 => 'Adobe RGB',
            65535 => 'Uncalibrated',
            _ => printable,
        };
    }

    String? _readGpsLocation(Map<String, IfdTag> tags) {
        final lat = _gpsCoordinate(
            tags['GPS GPSLatitude'],
            tags['GPS GPSLatitudeRef']?.printable,
        );
        final lon = _gpsCoordinate(
            tags['GPS GPSLongitude'],
            tags['GPS GPSLongitudeRef']?.printable,
        );

        if (lat == null || lon == null) return null;

        final latRef = (tags['GPS GPSLatitudeRef']?.printable ?? 'N').toUpperCase();
        final lonRef = (tags['GPS GPSLongitudeRef']?.printable ?? 'E').toUpperCase();
        return '${lat.abs().toStringAsFixed(5)}° $latRef, ${lon.abs().toStringAsFixed(5)}° $lonRef';
    }

    double? _gpsCoordinate(IfdTag? tag, String? ref) {
        if (tag == null) return null;

        final values = tag.values;
        if (values is! IfdRatios || values.ratios.length < 3) {
            final printable = tag.printable;
            final parts = printable.split(',').map((part) => part.trim()).toList();
            if (parts.length < 3) return null;

            final degrees = _parseRatio(parts[0]);
            final minutes = _parseRatio(parts[1]);
            final seconds = _parseRatio(parts[2]);
            if (degrees == null || minutes == null || seconds == null) return null;

            var decimal = degrees + (minutes / 60) + (seconds / 3600);
            if (ref == 'S' || ref == 'W') decimal = -decimal;
            return decimal;
        }

        final ratios = values.ratios;
        final degrees = ratios[0].toDouble();
        final minutes = ratios[1].toDouble();
        final seconds = ratios[2].toDouble();
        var decimal = degrees + (minutes / 60) + (seconds / 3600);
        if (ref == 'S' || ref == 'W') decimal = -decimal;
        return decimal;
    }

    double? _parseRatio(String value) {
        if (value.contains('/')) {
            final parts = value.split('/');
            if (parts.length != 2) return null;
            final numerator = double.tryParse(parts[0]);
            final denominator = double.tryParse(parts[1]);
            if (numerator == null || denominator == null || denominator == 0) return null;
            return numerator / denominator;
        }
        return double.tryParse(value);
    }

    static final String _tag = "ParseImageMetadataUseCase";
}
