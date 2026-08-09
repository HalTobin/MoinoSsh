import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class GenerateKeyDialog extends StatefulWidget {
  final Function(String name, String? password) onGenerate;
  final Function() onDismiss;
  final String description;

  const GenerateKeyDialog({
    super.key,
    required this.onGenerate,
    required this.onDismiss,
    this.description =
        'A new Ed25519 key pair will be generated. The private key is saved to local storage.',
  });

  @override
  State<GenerateKeyDialog> createState() => _GenerateKeyDialogState();
}

class _GenerateKeyDialogState extends State<GenerateKeyDialog> {
  final _nameController = TextEditingController(text: 'id_ed25519');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordEnabled = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _validationError;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _validationError = 'Key name is required');
      return;
    }

    if (_passwordEnabled) {
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      if (password.isEmpty) {
        setState(() => _validationError = 'Password is required');
        return;
      }

      if (password != confirmPassword) {
        setState(() => _validationError = 'Passwords do not match');
        return;
      }
    }

    setState(() => _validationError = null);
    widget.onGenerate(
      name,
      _passwordEnabled ? _passwordController.text : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.bookKey,
            title: 'Generate SSH key pair',
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: widget.onDismiss),
          ),
          Text(widget.description),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Key name',
              border: OutlineInputBorder(),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.onSurface)
            ),
            onPressed: () {
              {
                setState(() {
                  _passwordEnabled = !_passwordEnabled;
                  _validationError = null;
                  if (!_passwordEnabled) {
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                  }
                });
              }
            },
            child: Row(
              spacing: 8,
              children: [
                Checkbox(
                  value: _passwordEnabled,
                  onChanged: (value) {
                    setState(() {
                      _passwordEnabled = value ?? false;
                      _validationError = null;
                      if (!_passwordEnabled) {
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                      }
                    });
                  },
                ),
                const Expanded(
                  child: Text('Protect private key with a password'),
                ),
              ],
            )
          ),
          if (_passwordEnabled) ...[
            TextFormField(
              controller: _passwordController,
              enabled: _passwordEnabled,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            TextFormField(
              controller: _confirmPasswordController,
              enabled: _passwordEnabled,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? LucideIcons.eye : LucideIcons.eyeOff),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
              ),
            ),
          ],
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
                  icon: const Icon(LucideIcons.bookKey),
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
