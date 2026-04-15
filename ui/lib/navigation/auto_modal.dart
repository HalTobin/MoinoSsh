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
  return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (_) => dismissable
          ? EscToClose(child: AppDialogLayout(padding: EdgeInsets.zero, child: child))
          : AppDialogLayout(padding: EdgeInsets.zero, child: child)
  );

  // TODO - Need to fix the keyboard hiding TextField before using BottomSheet again
  return ScreenFormatHelper.isNarrow(constraints) ?
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (_) => dismissable 
          ? EscToClose(
            child: Wrap(children: [child])
          )
          : Wrap(children: [child]),
    )
    : showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (_) => dismissable
        ? EscToClose(child: AppDialogLayout(padding: EdgeInsets.zero, child: child))
        : AppDialogLayout(padding: EdgeInsets.zero, child: child)
    );
}