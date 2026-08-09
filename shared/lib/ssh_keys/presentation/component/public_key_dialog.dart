import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';
import 'package:util/ssh/ssh_key_details.dart';

class PublicKeyDialog extends StatefulWidget {
  final String keyName;
  final Future<SshKeyDetails> Function(String? password) loadDetails;
  final Function() onDismiss;

  const PublicKeyDialog({
    super.key,
    required this.keyName,
    required this.loadDetails,
    required this.onDismiss,
  });

  @override
  State<PublicKeyDialog> createState() => _PublicKeyDialogState();
}

class _PublicKeyDialogState extends State<PublicKeyDialog> {
  final _passwordController = TextEditingController();
  bool _loading = true;
  bool _obscurePassword = true;
  bool _passwordRequired = false;
  String? _error;
  SshKeyDetails? _details;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _load({String? password}) async {
    setState(() {
      _loading = true;
      _error = null;
      _passwordRequired = false;
    });

    try {
      final details = await widget.loadDetails(password);
      if (!mounted) return;
      setState(() {
        _details = details;
        _loading = false;
      });
    } on SshKeyDetailsLoadException catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _passwordRequired = error.passwordRequired;
        _error = error.message;
        _details = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not read public key';
        _details = null;
      });
    }
  }

  Future<void> _copy() async {
    final line = _details?.publicKeyLine;
    if (line == null) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: line));
    if (!mounted) return;
    setState(() => _copied = true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppDialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.keyRound,
            title: 'Public key',
            trailingContent: TitleHeaderTrailingContent.dismissable(
              onDismiss: widget.onDismiss,
            ),
          ),
          Text(
            widget.keyName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_details != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: const Icon(LucideIcons.binary, size: 16),
                label: Text(_details!.algorithmLabel),
                visualDensity: VisualDensity.compact,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _details!.publicKeyLine,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: _copy,
              icon: Icon(_copied ? LucideIcons.check : LucideIcons.copy),
              label: Text(_copied ? 'Copied' : 'Copy to clipboard'),
            ),
          ] else ...[
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: colorScheme.error),
              ),
            if (_passwordRequired) ...[
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                    ),
                    onPressed: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () => _load(password: _passwordController.text),
                icon: const Icon(LucideIcons.unlock),
                label: const Text('Unlock'),
              ),
            ] else
              TextButton(
                onPressed: () => _load(),
                child: const Text('Retry'),
              ),
          ],
        ],
      ),
    );
  }
}
