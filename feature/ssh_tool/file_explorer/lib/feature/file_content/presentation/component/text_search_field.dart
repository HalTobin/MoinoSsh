import 'package:feature_file_explorer/feature/file_content/model/search_result.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TextSearchField extends StatelessWidget {
  final Function(String) enterSearch;
  final Function() resetSearch;

  final int? selectedSearchIndex;
  final Function(int) selectSearchIndex;
  final SearchResult? search;

  const TextSearchField({
    super.key,
    required this.enterSearch,
    required this.resetSearch,

    required this.selectedSearchIndex,
    required this.selectSearchIndex,
    required this.search
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController(text: search?.keyword);
    final colorScheme = Theme.of(context).colorScheme;

    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: colorScheme.surface),
      ),
      child: TextField(
        controller: searchController,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: "Search content...",
          isDense: true,
          contentPadding: const EdgeInsets.all(12),
          prefixIcon: IconButton(
            icon: const Icon(LucideIcons.search),
            constraints: const BoxConstraints(),
            onPressed: () => enterSearch(searchController.text),
          ),
          suffixIcon: search != null
            ? _SearchFieldSuffix(
              clear: () {
                searchController.clear();
                resetSearch();
              },
              selectedSearchIndex: selectedSearchIndex,
              selectSearchIndex: selectSearchIndex,
              searchResult: search!,
            )
            : null,
        ),
        onSubmitted: enterSearch,
      ),
    );
  }

}

class _SearchFieldSuffix extends StatelessWidget {
  final Function() clear;

  final int? selectedSearchIndex;
  final Function(int) selectSearchIndex;
  final SearchResult searchResult;

  const _SearchFieldSuffix({
    super.key,
    required this.clear,
    required this.selectedSearchIndex,
    required this.selectSearchIndex,
    required this.searchResult
  });

  @override
  Widget build(BuildContext context) {
    final searchResult = this.searchResult;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        searchResult.linesWithMatch.isEmpty
          ? const Text("No result")
          : _buildSearchIndexes(searchResult),

        IconButton(
          icon: const Icon(LucideIcons.x),
          constraints: const BoxConstraints(),
          onPressed: clear,
        )
      ],
    );
  }

  Widget _buildSearchIndexes(SearchResult search) {
    final String indexesText = "${(selectedSearchIndex ?? 0) + 1} / ${search.linesWithMatch.length}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          indexesText,
          style: TextStyle(
            fontFeatures: [ FontFeature.tabularFigures() ],
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: const Icon(LucideIcons.chevronUp),
          constraints: const BoxConstraints(),
          onPressed: () {
            final int currentIndex = selectedSearchIndex ?? 0;
            final int newIndex = currentIndex == 0 ? (search.linesWithMatch.length-1) : currentIndex-1;
            selectSearchIndex(newIndex);
          },
        ),
        IconButton(
          icon: const Icon(LucideIcons.chevronDown),
          constraints: const BoxConstraints(),
          onPressed: () {
            final int currentIndex = selectedSearchIndex ?? 0;
            final int newIndex = currentIndex == search.linesWithMatch.length-1 ? 0 : currentIndex+1;
            selectSearchIndex(newIndex);
          },
        )
      ]
    );
  }

}