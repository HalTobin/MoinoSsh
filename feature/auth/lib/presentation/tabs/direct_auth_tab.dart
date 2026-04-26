import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../feature/direct_auth/di/direct_auth_provider.dart';
import '../../feature/direct_auth/presentation/direct_auth_screen.dart';
import '../../feature/direct_auth/presentation/direct_auth_viewmodel.dart';

class DirectAuthTab extends StatelessWidget {
  const DirectAuthTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DirectAuthProvider(
      child: Consumer<DirectAuthViewModel>(
        builder: (context, viewmodel, child) {
          return DirectAuthScreen(
            state: viewmodel.state,
            onEvent: viewmodel.onEvent
          );
        }
      )
    );
  }
}