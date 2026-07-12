import 'package:feature_file_explorer/feature/file_content/model/search_result.dart';

class SearchInFileContentUseCase {

    SearchResult execute({required String search, required String content}) {
        if (search.isEmpty) {
            return SearchResult(keyword: search, linesWithMatch: []);
        }

        final List<String> lines = content.split('\n');
        final List<int> matchingLines = [];

        final searchLower = search.toLowerCase();

        for (int i = 0; i < lines.length; i++) {
            if (lines[i].toLowerCase().contains(searchLower)) {
                matchingLines.add(i);
            }
        }

        return SearchResult(
            keyword: search,
            linesWithMatch: matchingLines,
        );
    }

}