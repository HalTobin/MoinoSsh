import 'package:feature_auth/feature/my_ssh_keys/presentation/component/ssh_key_item.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ui/component/app_button.dart';
import 'package:ui/component/empty_list.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

import 'my_ssh_keys_event.dart';
import 'my_ssh_keys_state.dart';

class MySshKeysView extends StatelessWidget {
  final MySshKeysState state;
  final Function(MySshKeysEvent) onEvent;
  final bool selectionEnable;

  final Function(String?)? onSelect;
  final Function() onDismiss;

  const MySshKeysView({
    super.key,
    required this.state,
    required this.onEvent,
    required this.selectionEnable,
    required this.onSelect,
    required this.onDismiss
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: onDismiss, icon: const Icon(LucideIcons.arrowLeft)),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            Icon(LucideIcons.folderKey),
            Text("My SSH keys"),
          ],
        )
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = ScreenFormatHelper.isNarrow(constraints);
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
            child: Column(
              spacing: 16,
              children: [
                Expanded(
                  child: AnimatedCrossFade(
                    firstChild: Center(
                      child: CircularProgressIndicator()
                    ),
                    secondChild: state.keys.isNotEmpty
                      ? _KeyList(
                        state: state,
                        onEvent: onEvent,
                        isShrink: isNarrow,
                        isBottomSheet: isNarrow,
                      )
                      : EmptyList(
                        message: "No profile found",
                        onAction: null
                      ),
                    crossFadeState: state.loading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300)
                  )
                ),

                _ModalBottomActions(
                  state: state,
                  onEvent: onEvent,
                  isShrink: isNarrow,
                  onKeySelect: onSelect
                ),

                SizedBox(height: 8)
              ],
            ),
          );
        }
      ),
    );
  }
}

class _KeyList extends StatelessWidget {
  final MySshKeysState state;
  final Function(MySshKeysEvent) onEvent;
  final bool isShrink;
  final bool isBottomSheet;
  final bool shouldEditDeleteInDialog;

  const _KeyList({
    super.key,
    required this.state,
    required this.onEvent,
    required this.isShrink,
    required this.isBottomSheet
  }): shouldEditDeleteInDialog = isShrink && isBottomSheet;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: state.keys.length,
        itemBuilder: (BuildContext context, int index) {
          final key = state.keys[index];

          final MySshKeysEvent selectEvent = SelectKey(keyPath: key.path);
          final MySshKeysEvent deleteEvent = DeleteKey(keyPath: key.path);
          final MySshKeysEvent editEvent = EditionMode(keyPath: key.path);

          return SshKeyItem(
            sshKeyFile: key,
            selected: state.selectedKeyPath == key.path,
            onClick: () => onEvent(selectEvent),
            shouldEditDeleteInDialog: shouldEditDeleteInDialog,
            editionMode: state.editionModeKeyPath == key.path,
            onEditionMode: () => onEvent(editEvent),
            onEdit: (newName) {
              final MySshKeysEvent editEvent = RenameKey(keyPath: key.path, newName: newName);
              onEvent(editEvent);
            },
            onDelete: () => onEvent(deleteEvent),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider()
      ),
    );
  }

}

class _ModalBottomActions extends StatelessWidget {
  final MySshKeysState state;
  final Function(MySshKeysEvent) onEvent;
  final bool isShrink;

  final Function(String?)? onKeySelect;

  const _ModalBottomActions({
    super.key,
    required this.state,
    required this.onEvent,
    required this.isShrink,
    required this.onKeySelect
  });

  @override
  Widget build(BuildContext context) {

    Widget wrapButton(Widget button) {
      if (isShrink) {
        return Expanded(child: button);
      } else {
        return SizedBox(width: 180, child: button);
      }
    }

    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        wrapButton(
          AppButton(
            onClick: () async {
              FilePickerResult? result = await FilePicker.pickFiles();
              if (result != null && result.files.single.path != null) {
                final String sshFile = result.files.single.path!;
                final event = AddKey(keyPath: sshFile);
                onEvent(event);
              }
            },
            icon: LucideIcons.plus,
            text: "ADD",
            stretch: true
          )
        ),
        if (onKeySelect != null)
          wrapButton(
            AppButton(
              onClick: () => onKeySelect?.call(state.selectedKeyPath),
              icon: LucideIcons.key,
              text: "SELECT",
              enabled: state.selectedKeyPath != null,
              stretch: true
            )
          )
      ],
    );
  }

}