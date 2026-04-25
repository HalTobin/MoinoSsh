import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class DeleteSshKeyDialog extends StatefulWidget {
  final String textToTarget;
  final Function() onDelete;
  final Function() onDismiss;

  const DeleteSshKeyDialog({
    super.key,
    required this.textToTarget,
    required this.onDelete,
    required this.onDismiss
  });

  @override
  State<StatefulWidget> createState() => _DeleteSshKeyDialogState();

}

class _DeleteSshKeyDialogState extends State<DeleteSshKeyDialog> {
  final _deleteConfirmField = TextEditingController();

  bool _textFieldMatchTarget = false;

  @override
  void initState() {
    super.initState();
    _deleteConfirmField.addListener(_onTextFieldChange);
  }

  void _onTextFieldChange() {
    setState(() {
      _textFieldMatchTarget = (_deleteConfirmField.text == widget.textToTarget);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppDialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.trash2,
            title: "Delete a key",
            trailingContent: TitleHeaderTrailingContent.dismissable(
                onDismiss: Navigator.of(context).pop
            ),
          ),

          TextFormField(
            controller: _deleteConfirmField,
            decoration: InputDecoration(
              hintText: "Enter: \"${widget.textToTarget}\" to confirm",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              Expanded(
                child: TextButton(onPressed: widget.onDismiss, child: const Text("Cancel"))
              ),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _textFieldMatchTarget ? widget.onDelete : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.errorContainer,
                    foregroundColor: colorScheme.onErrorContainer,
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.white
                  ),
                  icon: const Icon(LucideIcons.pen),
                  label: const Text("Delete")
                )
              )
            ],
          )
        ],
      )
    );
  }

}