import 'package:feature_file_explorer/feature/file_content/presentation/file_content_state.dart';
import 'package:flutter/material.dart';

class FileContentScreen extends StatelessWidget {
  final FileContentState state;

  const FileContentScreen({
    super.key,
    required this.state
  });

  @override
  Widget build(BuildContext context) {
    return Text("FILE_CONTENT");
  }

}