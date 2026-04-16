import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/add_edit_server_view.dart';
import '../presentation/add_edit_server_viewmodel.dart';
import '../use_case/add_edit_server_usecases.dart';
import '../use_case/load_server_profile_usecase.dart';

class AddEditServerProvider extends StatelessWidget {
  final int? serverProfileId;
  final Function() onDismiss;

  const AddEditServerProvider({
    super.key,
    this.serverProfileId,
    required this.onDismiss
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => (
            LoadServerProfileUseCase(
              serverProfileRepository: context.read()
            )
          )
        ),
        Provider(
          create: (context) => (
            AddEditServerUseCases(
              loadServerProfileUseCase: context.read(),
              addEditServerUseCase: context.read(),
              loadSshFileUseCase: context.read()
            )
          )
        ),
        ChangeNotifierProvider(
          create: (context) => AddEditServerViewModel(
            addEditServerUseCases: context.read()
          )
        )
      ],
      child: Consumer<AddEditServerViewModel>(
        builder: (context, viewmodel, child) {
          return AddEditServerView(
            serverProfileId: serverProfileId,
            state: viewmodel.state,
            onEvent: viewmodel.onEvent,
            uiEvent: viewmodel.uiEvent,
            onDismiss: onDismiss
          );
        }
      ),
    );
  }

}