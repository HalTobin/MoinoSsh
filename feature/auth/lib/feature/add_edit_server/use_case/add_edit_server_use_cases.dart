import 'package:domain/use_case/add_edit_server_use_case.dart';
import 'package:domain/use_case/load_ssh_file_use_case.dart';
import 'package:feature_auth/feature/add_edit_server/use_case/delete_server_use_case.dart';

import 'load_server_profile_use_case.dart';

class AddEditServerUseCases {
    final LoadServerProfileUseCase loadServerProfileUseCase;
    final AddEditServerUseCase addEditServerUseCase;
    final LoadSshFileUseCase loadSshFileUseCase;
    final DeleteServerUseCase deleteServerUseCase;

    AddEditServerUseCases({
        required this.loadServerProfileUseCase,
        required this.addEditServerUseCase,
        required this.loadSshFileUseCase,
        required this.deleteServerUseCase
    });
}