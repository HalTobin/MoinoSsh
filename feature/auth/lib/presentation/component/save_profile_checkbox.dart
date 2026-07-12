import 'package:flutter/material.dart';

class SaveProfileCheckbox extends StatelessWidget {
  final bool checked;
  final Function(bool) onChecked;

  const SaveProfileCheckbox({
    super.key,
    required this.checked,
    required this.onChecked
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: checked,
          onChanged: (value) => onChecked(value ?? false)
        ),
        Text("Save profile")
      ],
    );
  }

}