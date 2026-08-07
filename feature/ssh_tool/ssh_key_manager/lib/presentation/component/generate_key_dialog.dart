import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class GenerateKeyDialog extends StatefulWidget {
  final Function(String name) onGenerate;
  final Function() onDismiss;

  const GenerateKeyDialog({
    super.key,
    required this.onGenerate,
    required this.onDismiss,
  });

  @override
  State<GenerateKeyDialog> createState() => _GenerateKeyDialogState();
}

class _GenerateKeyDialogState extends State<GenerateKeyDialog> {
  final _nameController = TextEditingController(text: 'id_ed25519');

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.keyRound,
            title: 'Generate SSH key pair',
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: widget.onDismiss),
          ),
          const Text(
            'A new Ed25519 key pair will be generated. The public key will be staged for the remote whitelist and the private key will be saved locally when you apply.',
          ),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Key name',
              border: OutlineInputBorder(),
            ),
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
                  onPressed: () => widget.onGenerate(_nameController.text.trim()),
                  icon: const Icon(LucideIcons.sparkles),
                  label: const Text('Generate'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
