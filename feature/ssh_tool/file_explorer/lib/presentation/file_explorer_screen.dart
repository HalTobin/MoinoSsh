import 'package:feature_file_explorer/presentation/file_explorer_event.dart';
import 'package:flutter/material.dart';

import 'file_explorer_state.dart';

class FileExplorerScreen extends StatelessWidget {
  final FileExplorerState state;
  final bool isNarrow;
  final Function(FileExplorerEvent event) onEvent;

  const FileExplorerScreen({
    super.key,
    required this.state,
    required this.isNarrow,
    required this.onEvent
  });

  @override
  Widget build(BuildContext context) {
    return Text("FILE MANAGER");
  }

}