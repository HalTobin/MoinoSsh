import 'package:flutter/material.dart';

class EnableQuickConnectCheckbox extends StatelessWidget {
  final bool checked;
  final bool enable;
  final Function(bool) onChecked;

  const EnableQuickConnectCheckbox({
    super.key,
    required this.checked,
    required this.enable,
    required this.onChecked
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      firstChild: EnableQuickConnectCheckboxBase(
        checked: checked,
        enable: enable,
        onChecked: onChecked
      ),
      secondChild: EnableQuickConnectCheckboxBase(
        checked: null,
        enable: false,
        onChecked: (value) => {}
      ),
      crossFadeState: enable ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}

class EnableQuickConnectCheckboxBase extends StatelessWidget {
  final bool? checked;
  final bool enable;
  final Function(bool) onChecked;

  const EnableQuickConnectCheckboxBase({
    super.key,
    required this.checked,
    required this.enable,
    required this.onChecked
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          activeColor: enable ? null : Colors.grey,
          value: enable ? checked : null,
          tristate: !enable,
          onChanged: (value) => {
            if (enable) {
              onChecked(value ?? false)
            }
          }
        ),
        Text(
          "Enable quick connect",
          style: TextStyle(color: enable ? null : Colors.grey),
        )
      ],
    );
  }
}