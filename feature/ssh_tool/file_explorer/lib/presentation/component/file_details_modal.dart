import 'package:feature_file_explorer/data/file_entry.dart';
import 'package:flutter/material.dart';

class FileDetailsModal extends StatelessWidget {
  final File file;

  const FileDetailsModal({
    super.key,
    required this.file
  });

  @override
  Widget build(BuildContext context) {
    return Text("FILE_DETAILS");
  }

}