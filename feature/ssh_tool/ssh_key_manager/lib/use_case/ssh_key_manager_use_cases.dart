import 'apply_remote_authorized_keys_use_case.dart';
import 'get_remote_authorized_keys_use_case.dart';

class SshKeyManagerUseCases {
    final GetRemoteAuthorizedKeysUseCase getRemoteAuthorizedKeysUseCase;
    final ApplyRemoteAuthorizedKeysUseCase applyRemoteAuthorizedKeysUseCase;

    SshKeyManagerUseCases({
        required this.getRemoteAuthorizedKeysUseCase,
        required this.applyRemoteAuthorizedKeysUseCase,
    });
}
