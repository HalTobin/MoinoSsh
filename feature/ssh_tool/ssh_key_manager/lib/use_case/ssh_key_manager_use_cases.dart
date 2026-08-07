import 'apply_remote_authorized_keys_use_case.dart';
import 'generate_ssh_key_pair_use_case.dart';
import 'get_remote_authorized_keys_use_case.dart';

class SshKeyManagerUseCases {
    final GetRemoteAuthorizedKeysUseCase getRemoteAuthorizedKeysUseCase;
    final ApplyRemoteAuthorizedKeysUseCase applyRemoteAuthorizedKeysUseCase;
    final GenerateSshKeyPairUseCase generateSshKeyPairUseCase;

    SshKeyManagerUseCases({
        required this.getRemoteAuthorizedKeysUseCase,
        required this.applyRemoteAuthorizedKeysUseCase,
        required this.generateSshKeyPairUseCase,
    });
}
