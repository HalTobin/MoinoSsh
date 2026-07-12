import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PasswordTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;

  const PasswordTextFormField({
    super.key,
    required this.controller,
    required this.enabled
  });

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();

}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _obscure = true;

  void invertObscuration() {
    setState(() { _obscure = !_obscure; });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _obscure,
      decoration: InputDecoration(
          labelText: "Password",
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
              icon: Icon(
                  _obscure
                      ? LucideIcons.eye
                      : LucideIcons.eyeOff
              ),
              onPressed: () => invertObscuration()
          )
      ),
    );
  }
}