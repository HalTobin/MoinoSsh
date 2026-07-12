import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SearchIconButton extends StatelessWidget {
  final Function() onToggleSearch;
  final bool showSearch;

  const SearchIconButton({
    super.key,
    required this.onToggleSearch,
    required this.showSearch
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: IconButton(
        onPressed: () => onToggleSearch(),
        icon: const Icon(LucideIcons.searchX)
      ),
      secondChild: IconButton(
        onPressed: () => onToggleSearch(),
        icon: const Icon(LucideIcons.search)
      ),
      crossFadeState: showSearch ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300)
    );
  }

}