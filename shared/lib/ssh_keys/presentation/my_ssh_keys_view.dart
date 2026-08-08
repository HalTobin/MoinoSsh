import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_button.dart';
import 'package:ui/component/empty_list.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

import 'component/ssh_key_item.dart';
import 'my_ssh_keys_event.dart';
import 'my_ssh_keys_state.dart';

class MySshKeysView extends StatelessWidget {
  final MySshKeysState state;
  final Function(MySshKeysEvent) onEvent;
  final bool selectionEnable;

  final Function(String?)? onSelect;
  final Function() onDismiss;
  final bool embedded;

  const MySshKeysView({
    super.key,
    required this.state,
    required this.onEvent,
    required this.selectionEnable,
    required this.onSelect,
    required this.onDismiss,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (embedded) {
      return SizedBox.expand(
        child: _buildBody(horizontalPadding: 0),
      );
    }

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
      body: _buildBody(),
    );
  }

  Widget _buildBody({double horizontalPadding = 16}) {
    return LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = ScreenFormatHelper.isNarrow(constraints);

          return Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: state.keys.isNotEmpty
                        ? _KeyList(
                          state: state,
                          onEvent: onEvent,
                        ) : EmptyList(message: "No profile found", onAction: null)
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
              ),
              if (state.loading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
    );
  }
}

class _KeyList extends StatelessWidget {
  final MySshKeysState state;
  final Function(MySshKeysEvent) onEvent;

  const _KeyList({
    required this.state,
    required this.onEvent,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: state.keys.length,
      itemBuilder: (BuildContext context, int index) {
        final key = state.keys[index];

        return SshKeyItem(
          sshKeyFile: key,
          selected: state.selectedKeyPath == key.path,
          onClick: () => onEvent(SelectKey(keyPath: key.path)),
          onEdit: (newName) {
            onEvent(RenameKey(keyPath: key.path, newName: newName));
          },
          onDelete: () => onEvent(DeleteKey(keyPath: key.path)),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
    );
  }

}

class _ModalBottomActions extends StatelessWidget {
  final MySshKeysState state;
  final Function(MySshKeysEvent) onEvent;
  final bool isShrink;

  final Function(String?)? onKeySelect;

  const _ModalBottomActions({
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
