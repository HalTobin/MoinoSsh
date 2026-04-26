import 'package:feature_file_explorer/feature/file_content/presentation/component/text_filter_field.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/component/text_search_field.dart';
import 'package:flutter/material.dart';

import '../file_content_event.dart';

class FileContentTools extends StatelessWidget {
  final Function(FileContentEvent) onEvent;

  const FileContentTools({
    super.key,
    required this.onEvent
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextSearchField(
                enterSearch: (search) => onEvent(SearchContentEvent(search: search)),
                resetSearch: () => onEvent(SearchContentEvent(search: null))
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFilterField(
                enterFilter: (filter) => onEvent(FilterContentEvent(filter: filter)),
                resetFilter: () => onEvent(FilterContentEvent(filter: null))
              ),
            ),
          )
        ],
      ),
    );
  }

}