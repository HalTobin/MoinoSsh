import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/direct_auth_viewmodel.dart';
import '../use_case/direct_auth_use_cases.dart';

class DirectAuthProvider extends StatelessWidget {
  final Widget child;

  const DirectAuthProvider({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => DirectAuthUseCases(
            loadSshFileUseCase: context.read(),
            checkWrongFieldsUseCase: context.read(),
            sshConnectUseCase: context.read()
          )
        ),
        ChangeNotifierProvider(
          create: (context) => DirectAuthViewModel(
            directAuthUseCases: context.read()
          )
        ),
      ],
      child: child
    );
  }

}