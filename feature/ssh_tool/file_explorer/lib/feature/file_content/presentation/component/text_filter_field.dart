import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TextFilterField extends StatelessWidget {
  final Function(String) enterFilter;
  final Function() resetFilter;

  const TextFilterField({
    super.key,
    required this.enterFilter,
    required this.resetFilter
  });

  @override
  Widget build(BuildContext context) {
    final filterController = TextEditingController();
    return TextField(
      controller: filterController,
      decoration: InputDecoration(
        hintText: "Filter content...",
        prefixIcon: IconButton(
          onPressed: () => enterFilter(filterController.text),
          icon: const Icon(LucideIcons.listFilter)
        ),
        suffixIcon: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () {
            filterController.clear();
            resetFilter();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onSubmitted: enterFilter,
    );
  }

}