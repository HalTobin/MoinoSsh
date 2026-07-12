import 'dart:math';

class DetermineEditedLinesUseCase {

    List<int> execute(TextComparison texts) {
        final String original = texts.original;
        final String modified = texts.edited;

        if (original == modified) {
           return [];
        }

        final origLines = original.split('\n');
        final modLines = modified.split('\n');

        // 1. FAST TRIM: Find common prefix
        int start = 0;
        while (start < origLines.length &&
            start < modLines.length &&
            origLines[start] == modLines[start]) {
            start++;
        }

        // 2. FAST TRIM: Find common suffix
        int endOrig = origLines.length - 1;
        int endMod = modLines.length - 1;
        while (endOrig >= start &&
            endMod >= start &&
            origLines[endOrig] == modLines[endMod]) {
            endOrig--;
            endMod--;
        }

        // Isolate the dirty regions
        final dirtyOrig = origLines.sublist(start, endOrig + 1);
        final dirtyMod = modLines.sublist(start, endMod + 1);

        if (dirtyOrig.isEmpty) {
            // Pure insertion (User just pasted new lines)
            return List.generate(dirtyMod.length, (i) => start + i);
        }
        if (dirtyMod.isEmpty) {
            // Pure deletion (Nothing to highlight in the new text)
            return [];
        }

        // PERFORMANCE SAFETY NET:
        // If the dirty region is massive (e.g., user highlighted and replaced
        // 5,000 lines of code at once), the DP matrix will freeze the UI thread.
        // In that extreme case, we fall back to marking the whole block.
        if (dirtyOrig.length > 1000 || dirtyMod.length > 1000) {
           return List.generate(dirtyMod.length, (i) => start + i);
        }

        // 3. EXACT DIFF: Longest Common Subsequence (DP Matrix)
        // Now we compare the exact lines inside the dirty region
        List<List<int>> dp = List.generate(
          dirtyOrig.length + 1,
              (_) => List.filled(dirtyMod.length + 1, 0),
        );

        for (int i = 1; i <= dirtyOrig.length; i++) {
            for (int j = 1; j <= dirtyMod.length; j++) {
                if (dirtyOrig[i - 1] == dirtyMod[j - 1]) {
                   dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }

        // 4. BACKTRACK: Find which lines in the modified string are new/changed
        List<int> modifiedIndices = [];
        int i = dirtyOrig.length;
        int j = dirtyMod.length;

        while (i > 0 || j > 0) {
            if (i > 0 && j > 0 && dirtyOrig[i - 1] == dirtyMod[j - 1]) {
                // Line matches, move diagonally
                i--;
                j--;
            } else if (j > 0 && (i == 0 || dp[i][j - 1] >= dp[i - 1][j])) {
                // Line was modified or added in the new string
                j--;
                modifiedIndices.add(start + j); // Add absolute line index
            } else {
                // Line was deleted from original (we just skip it)
                i--;
            }
        }

        return modifiedIndices.reversed.toList();
    }

}

class TextComparison {
    final String original;
    final String edited;

    const TextComparison({required this.original, required this.edited});
}