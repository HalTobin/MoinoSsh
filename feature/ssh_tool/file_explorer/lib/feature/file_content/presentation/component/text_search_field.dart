import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TextSearchField extends StatelessWidget {
  final Function(String) enterSearch;
  final Function() resetSearch;

  const TextSearchField({
    super.key,
    required this.enterSearch,
    required this.resetSearch
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: "Search content...",
        prefixIcon: IconButton(
          onPressed: () => enterSearch(searchController.text),
          icon: const Icon(LucideIcons.search)
        ),
        suffixIcon: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () {
            searchController.clear();
            resetSearch();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onSubmitted: enterSearch,
    );
  }

}