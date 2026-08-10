import 'package:feature_file_explorer/presentation/component/pinned_folder/pinned_folders_menu.dart';
import 'package:feature_file_explorer/presentation/file_explorer_event.dart';
import 'package:feature_file_explorer/presentation/file_explorer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:ui/component/title_header.dart';

class PinnedFolderModal extends StatefulWidget {

  const PinnedFolderModal({super.key});

  @override
  State<PinnedFolderModal> createState() => _PinnedFolderModalState();
}

class _PinnedFolderModalState extends State<PinnedFolderModal> {
  final ScrollController _scrollController = ScrollController();
  bool _showDivider = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = _scrollController.hasClients && _scrollController.offset > 0;
    if (shouldShow != _showDivider) {
      setState(() => _showDivider = shouldShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FileExplorerViewModel>();
    final state = viewModel.state;
    final onEvent = viewModel.onEvent;
    
    final padding = 16.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.directional(top: padding, bottom: 12, start: padding, end: padding/2),
          child: TitleHeader(
            icon: LucideIcons.folders,
            title: "Pinned folders",
            trailingContent: TitleHeaderTrailingContent.dismissable(
                onDismiss: () => Navigator.of(context).pop()
            ),
          )
        ),
        AnimatedOpacity(
          opacity: _showDivider ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: const Divider(height: 1, thickness: 1),
        ),
        Expanded(
          child: PinnedFoldersMenu(
            scrollController: _scrollController,
            currentPath: state.currentPath,
            folders: state.pinnedFolders,
            onFolderTap: (folder) {
              Navigator.of(context).pop();
              onEvent(OpenFolder(folderPath: folder));
            },
            onUnpin: (folder) => onEvent(PinUnpinEvent(path: folder)),
            onFolderRename: (folder, newAlias) => onEvent(RenamePinnedFolder(path: folder, newAlias: newAlias)),
            onIconEdit: (folder, newIcon) => onEvent(EditPinnedFolderIcon(path: folder, newIcon: newIcon)),
          ),
        ),
      ],
    );
  }

}
