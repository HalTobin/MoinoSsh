import 'package:shared/ssh_keys/use_case/rename_key_use_case.dart';
import 'package:shared/ssh_keys/use_case/save_ssh_key_content_use_case.dart';

import 'add_key_use_case.dart';
import 'delete_key_use_case.dart';
import 'generate_ssh_key_pair_use_case.dart';
import 'get_ssh_key_details_use_case.dart';
import 'list_ssh_keys_use_case.dart';

class MySshKeysUseCases {
    final AddKeyUseCase addKeyUseCase;
    final DeleteKeyUseCase deleteKeyUseCase;
    final ListSshKeysUseCase listSshKeysUseCase;
    final RenameKeyUseCase renameKeyUseCase;
    final GenerateSshKeyPairUseCase generateSshKeyPairUseCase;
    final SaveSshKeyContentUseCase saveSshKeyContentUseCase;
    final GetSshKeyDetailsUseCase getSshKeyDetailsUseCase;

    MySshKeysUseCases({
        required this.addKeyUseCase,
        required this.deleteKeyUseCase,
        required this.listSshKeysUseCase,
        required this.renameKeyUseCase,
        required this.generateSshKeyPairUseCase,
        required this.saveSshKeyContentUseCase,
        required this.getSshKeyDetailsUseCase,
    });
}
