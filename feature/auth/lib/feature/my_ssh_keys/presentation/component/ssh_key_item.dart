import 'package:feature_auth/feature/my_ssh_keys/domain/ssh_key_file.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/selectable.dart';

class SshKeyItem extends StatefulWidget {
  final SshKeyFile sshKeyFile;
  final bool selected;
  final Function() onClick;

  final bool editionMode;
  final Function() onEditionMode;
  final Function(String newName) onEdit;
  final Function() onDelete;

  const SshKeyItem({
    super.key,
    required this.sshKeyFile,
    required this.selected,
    required this.onClick,

    required this.editionMode,
    required this.onEditionMode,
    required this.onEdit,
    required this.onDelete
  });

  @override
  State<StatefulWidget> createState() => _SshKeyItemState();

}

enum _SshKeyItemInteractionState {
  idle,
  editing,
  deleting
}

class _SshKeyItemState extends State<SshKeyItem> {

  _SshKeyItemInteractionState state = _SshKeyItemInteractionState.idle;
  final FocusNode _nameFieldFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _deleteFieldFocusNode = FocusNode();
  final TextEditingController _deleteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameFieldFocusNode.addListener(() {
      if (!_nameFieldFocusNode.hasFocus && state == _SshKeyItemInteractionState.editing) {
        backToIdle();
      }
    });

    _deleteFieldFocusNode.addListener(() {
      if (!_deleteFieldFocusNode.hasFocus && state == _SshKeyItemInteractionState.deleting) {
        backToIdle();
      }
    });
  }

  @override
  void dispose() {
    _nameFieldFocusNode.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void enableRenameMode() {
    setState(() {
      _nameController.text = widget.sshKeyFile.name;
      state = _SshKeyItemInteractionState.editing;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFieldFocusNode.requestFocus();
    });
  }

  void confirmRename() {
    setState(() {
      state = _SshKeyItemInteractionState.idle;
      widget.onEdit(_nameController.text);
    });
  }

  void enableDeleteMode() {
    setState(() {
      _deleteController.text = "";
      state = _SshKeyItemInteractionState.deleting;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deleteFieldFocusNode.requestFocus();
    });
  }

  void backToIdle() {
    setState(() {
      state = _SshKeyItemInteractionState.idle;
    });
  }

  void confirmDeletion() {
    setState(() {
      state = _SshKeyItemInteractionState.idle;
      if (_deleteController.text == widget.sshKeyFile.name) {
        widget.onDelete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Selectable(
      selectionEnable: true,
      selected: widget.selected,
      onSelect: widget.onClick,
      child: AnimatedCrossFade(
        crossFadeState: !widget.editionMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: Row(
          children: [
            _BaseKeyItem(sshKeyFile: widget.sshKeyFile),
            const Spacer(),
            IconButton(
              icon: const Icon(LucideIcons.ellipsisVertical),
              onPressed: widget.onEditionMode,
            )
          ],
        ),
        secondChild: switch (state) {
          _SshKeyItemInteractionState.idle => Row(
            children: [
              _BaseKeyItem(sshKeyFile: widget.sshKeyFile),
              const Spacer(),
              IconButton(
                icon: Icon(
                  LucideIcons.pen,
                  color: Colors.orange
                ),
                onPressed: enableRenameMode,
              ),
              IconButton(
                icon: Icon(
                  LucideIcons.trash2,
                  color: Colors.red
                ),
                onPressed: enableDeleteMode,
              ),
              IconButton(
                icon: const Icon(LucideIcons.undo),
                onPressed: widget.onEditionMode,
              )
            ],
          ),
          _SshKeyItemInteractionState.editing => Row(
            children: [
              const _SshKeyFile(color: Colors.orange),

              Expanded(
                  child: TextField(
                      maxLines: 1,
                      focusNode: _nameFieldFocusNode,
                      controller: _nameController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                              onPressed: confirmRename,
                              icon: const Icon(LucideIcons.check)
                          )
                      )
                  )
              ),

              IconButton(
                icon: Icon(LucideIcons.x),
                onPressed: backToIdle,
              )
            ],
          ),
          _SshKeyItemInteractionState.deleting => Row(
            children: [
              _SshKeyFile(color: Theme.of(context).colorScheme.error),

              Expanded(
                  child: TextField(
                      maxLines: 1,
                      focusNode: _deleteFieldFocusNode,
                      controller: _deleteController,
                      decoration: InputDecoration(
                          hintText: "Enter: \"${widget.sshKeyFile.name}\" to confirm",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                          ),
                          suffixIcon: IconButton(
                              onPressed: confirmDeletion,
                              icon: const Icon(LucideIcons.trash2)
                          )
                      )
                  )
              ),

              IconButton(
                icon: Icon(LucideIcons.x),
                onPressed: backToIdle,
              )
            ],
          ),
        },
        duration: Duration(milliseconds: 300),
      )
    );

  }

}

class _BaseKeyItem extends StatelessWidget {
  final SshKeyFile sshKeyFile;

  const _BaseKeyItem({
    super.key,
    required this.sshKeyFile
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SshKeyFile(),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sshKeyFile.name,
              style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700
              ),
            ),
            if (sshKeyFile.secured)
              Row(
                spacing: 4,
                children: [
                  const Icon(
                    LucideIcons.lock,
                    color: Colors.green,
                    size: 16
                  ),
                  const Text(
                    "This file is protected by a password.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green
                    )
                  )
                ],
              )
          ],
        )
      ],
    );
  }

}

class _SshKeyFile extends StatelessWidget {
  final Color? color;

  const _SshKeyFile({
    super.key,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        LucideIcons.fileKey,
        size: 32,
        color: color
      )
    );
  }
}