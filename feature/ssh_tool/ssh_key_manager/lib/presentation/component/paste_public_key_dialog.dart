import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';
import 'package:util/ssh/public_key_line.dart';

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
  SshPublicKeyLine? _preview;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _controller.removeListener(_updatePreview);
    _controller.dispose();
    super.dispose();
  }

  void _updatePreview() {
    final preview = SshPublicKeyLine.tryParse(_controller.text);
    if (preview?.identity == _preview?.identity) {
      return;
    }
    setState(() {
      _preview = preview;
      if (preview != null) {
        _validationError = null;
      }
    });
  }

  void _submit() {
    final result = SshPublicKeyLine.parse(_controller.text);
    switch (result) {
      case SshPublicKeyInvalid(:final message):
        setState(() => _validationError = message);
      case SshPublicKeyValid(:final key):
        setState(() => _validationError = null);
        widget.onConfirm(key.format());
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview;

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
            'Paste a single OpenSSH public key line to stage it for the remote authorized_keys file.',
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
          if (preview != null) _KeyPreview(keyLine: preview),
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

class _KeyPreview extends StatelessWidget {
  final SshPublicKeyLine keyLine;

  const _KeyPreview({required this.keyLine});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(LucideIcons.circleCheck, size: 18, color: colorScheme.primary),
              Text(
                keyLine.algorithmLabel,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (keyLine.comment != null)
                Expanded(
                  child: Text(
                    keyLine.comment!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
          Text(
            keyLine.fingerprint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
