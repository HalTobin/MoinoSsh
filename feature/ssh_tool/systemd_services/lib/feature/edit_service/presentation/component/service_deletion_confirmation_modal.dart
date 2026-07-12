import 'package:flutter/material.dart';
import 'package:ui/component/app_dialog_layout.dart';

class ServiceDeletionConfirmationModal extends StatelessWidget {
  final Function() onDismiss;
  final Function() onDelete;
  
  const ServiceDeletionConfirmationModal({
    super.key,
    required this.onDismiss,
    required this.onDelete
  });
  
  @override
  Widget build(BuildContext context) {
    return AppDialogLayout(
      padding: EdgeInsets.all(12),
      child: Column(

      )
    );
  }
  
}