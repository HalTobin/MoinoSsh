import 'package:domain/use_case/check_wrong_fields_use_case.dart';
import 'package:domain/use_case/load_ssh_file_use_case.dart';
import 'package:domain/use_case/ssh_connect_use_case.dart';

class DirectAuthUseCases {
    final LoadSshFileUseCase loadSshFileUseCase;
    final CheckWrongFieldsUseCase checkWrongFieldsUseCase;
    final SshConnectUseCase sshConnectUseCase;

    DirectAuthUseCases({
        required this.loadSshFileUseCase,
        required this.checkWrongFieldsUseCase,
        required this.sshConnectUseCase
    });
}