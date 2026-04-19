import 'package:feature_auth/feature/add_edit_server/use_case/delete_server_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/add_edit_server_view.dart';
import '../presentation/add_edit_server_view_model.dart';
import '../use_case/add_edit_server_use_cases.dart';
import '../use_case/load_server_profile_use_case.dart';

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
        Provider(create: (context) => (LoadServerProfileUseCase(serverProfileRepository: context.read()))),
        Provider(
          create: (context) => (
            DeleteServerUseCase(
              serverProfileRepository: context.read(),
              favoriteServiceRepository: context.read(),
              pinnedFolderRepository: context.read()
            )
          )
        ),
        Provider(
          create: (context) => (
            AddEditServerUseCases(
              loadServerProfileUseCase: context.read(),
              addEditServerUseCase: context.read(),
              loadSshFileUseCase: context.read(),
              deleteServerUseCase: context.read()
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