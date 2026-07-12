import 'package:feature_file_explorer/presentation/component/pinned_folder/pinned_folders_menu.dart';
import 'package:feature_file_explorer/presentation/file_explorer_event.dart';
import 'package:feature_file_explorer/presentation/file_explorer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:ui/component/title_header.dart';

class PinnedFolderModal extends StatelessWidget {

  const PinnedFolderModal({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FileExplorerViewModel>();
    final state = viewModel.state;
    final onEvent = viewModel.onEvent;
    
    final padding = 16.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.directional(top: padding, bottom: 0, start: padding, end: padding/2),
          child: TitleHeader(
            icon: LucideIcons.folders,
            title: "Pinned folders",
            trailingContent: TitleHeaderTrailingContent.dismissable(
                onDismiss: () => Navigator.of(context).pop()
            ),
          )
        ),
        PinnedFoldersMenu(
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
        SizedBox(
          height: 12,
        )
      ],
    );
  }

}