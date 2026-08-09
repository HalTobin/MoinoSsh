import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class PastePublicKeyDialog extends StatefulWidget {
  final Function(String publicKeyLine) onConfirm;
  final Function() onDismiss;

  const PastePublicKeyDialog({
    super.key,
    required this.onConfirm,
    required this.onDismiss,
  });

  @override
  State<PastePublicKeyDialog> createState() => _PastePublicKeyDialogState();
}

class _PastePublicKeyDialogState extends State<PastePublicKeyDialog> {
  final _controller = TextEditingController();
  String? _validationError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() => _validationError = 'Public key is required');
      return;
    }

    final parts = value.split(RegExp(r'\s+'));
    if (parts.length < 2) {
      setState(() => _validationError = 'Enter a valid OpenSSH public key line');
      return;
    }

    setState(() => _validationError = null);
    widget.onConfirm(value);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogLayout(
      width: 480,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.clipboardPaste,
            title: 'Paste public key',
            trailingContent: TitleHeaderTrailingContent.dismissable(
              onDismiss: widget.onDismiss,
            ),
          ),
          const Text(
            'Paste an OpenSSH public key line to stage it for the remote authorized_keys file.',
          ),
          TextFormField(
            controller: _controller,
            minLines: 4,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Public key',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          if (_validationError != null)
            Text(
              _validationError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: widget.onDismiss,
                  child: const Text('Cancel'),
                ),
              ),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(LucideIcons.plus),
                  label: const Text('Add'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
