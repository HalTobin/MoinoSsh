import 'dart:math' as math;

class SizeHelper {

    static String formatSize(int size) {
        if (size <= 0) return "0 B";
        const suffixes = ["B", "KB", "MB", "GB", "TB"];
        int i = (math.log(size) / math.log(1024)).floor();
        i = math.min(i, suffixes.length - 1);

        double calculatedSize = size / math.pow(1024, i);
        return "${calculatedSize.toStringAsFixed(1)} ${suffixes[i]}";
    }

}