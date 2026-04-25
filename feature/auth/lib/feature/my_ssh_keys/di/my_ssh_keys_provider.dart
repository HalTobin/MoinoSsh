import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/my_ssh_keys_view.dart';
import '../presentation/my_ssh_keys_view_model.dart';
import '../use_case/add_key_use_case.dart';
import '../use_case/delete_key_use_case.dart';
import '../use_case/list_ssh_keys_use_case.dart';
import '../use_case/my_ssh_keys_use_cases.dart';
import '../use_case/rename_key_use_case.dart';

class MySshKeysProvider extends StatelessWidget {
  final Function(String?) onKeySelect;

  const MySshKeysProvider({
    super.key,
    required this.onKeySelect
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => AddKeyUseCase(fileRepository: context.read())),
        Provider(create: (context) => DeleteKeyUseCase(fileRepository: context.read())),
        Provider(create: (context) => ListSshKeysUseCase(fileRepository: context.read())),
        Provider(create: (context) => RenameKeyUseCase(fileRepository: context.read())),
        Provider(create: (context) =>
          MySshKeysUseCases(
            addKeyUseCase: context.read(),
            deleteKeyUseCase: context.read(),
            listSshKeysUseCase: context.read(),
            renameKeyUseCase: context.read()
          )
        ),
        ChangeNotifierProvider(
          create: (context) => MySshKeysViewModel(
            mySshKeysUseCases: context.read()
          )
        )
      ],
      child: Consumer<MySshKeysViewModel>(
        builder: (context, viewmodel, child) {
          return MySshKeysView(
            state: viewmodel.state,
            onEvent: viewmodel.onEvent,
            selectionEnable: true,
            onSelect: (String? keyPath) {
              onKeySelect(keyPath ?? "");
            },
            onDismiss: () => Navigator.pop(context),
          );
        }
      ),
    );
  }

}