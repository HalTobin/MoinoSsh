import 'package:flutter/material.dart';
import 'package:ui/navigation/esc_to_close.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

import '../component/app_dialog_layout.dart';

Future<T?> autoModal<T>({
  required BuildContext context,
  required BoxConstraints constraints,
  required Widget child,
  bool dismissable = true
}) async {
  final isNarrow = ScreenFormatHelper.isNarrow(constraints);
  final EdgeInsets insets = EdgeInsets.all(isNarrow ? 12 : 24);

  return ScreenFormatHelper.isNarrow(constraints) ?
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (_) => dismissable 
          ? EscToClose(
            child: Padding(
              padding: insets,
              child: Wrap(children: [child])
            )
          )
          : Wrap(
            children: [
              Padding(
                padding: insets,
                child: child
              )
            ]
          ),
    )
    : showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (_) => dismissable
        ? EscToClose(child: AppDialogLayout(padding: EdgeInsets.zero, child: child))
        : AppDialogLayout(padding: EdgeInsets.zero, child: child)
    );
}