import 'package:domain/model/moino_ssh_icon.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

import 'moino_ssh_icon_data.dart';

class IconSelectDialog extends StatefulWidget {
  final int? initialSelection;
  final Function(int?) onSelect;
  final Function() onDismiss;

  const IconSelectDialog({
    super.key,
    this.initialSelection = null,
    required this.onSelect,
    required this.onDismiss
  });

  @override
  State<StatefulWidget> createState() => _IconSelectDialogState();

}

class _IconSelectDialogState extends State<IconSelectDialog> {
  int? _currentSelection;
  final TextEditingController _searchController = TextEditingController();
  List<MoinoSshIcon> _filteredIcons = MoinoSshIcon.values.toList();

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.initialSelection;
    _searchController.addListener(_onSearchChanged);
  }

  void _handleSelect(int? id) {
    setState(() {
      _currentSelection = id;
    });
  }

  void _onSearchChanged() {
    setState(() {
      _currentSelection = null;
      if (_searchController.text.isEmpty) {
        _filteredIcons = MoinoSshIcon.values;
      }
      else {
        _filteredIcons = MoinoSshIcon.search(_searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.image,
            title: "Select an icon",
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: widget.onDismiss),
          ),
          TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "Search",
              border: const OutlineInputBorder()
            )
          ),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: _filteredIcons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = _filteredIcons[index];
                final isSelected = _currentSelection == item.id;

                return InkWell(
                  onTap: () => _handleSelect(isSelected ? null : item.id),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer.withAlpha(50)
                        : null,
                    ),
                    child: Icon(
                      item.icon,
                      color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => widget.onDismiss(),
                  child: Text("Cancel")
                )
              ),
              Expanded(
                child: FilledButton(
                  onPressed: () => widget.onSelect(_currentSelection),
                  child: Text("Select")
                )
              )
            ],
          )
        ],
      ),
    );
  }

}