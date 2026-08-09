import 'package:util/ssh/ssh_key_details.dart';

class GetSshKeyDetailsUseCase {
    Future<SshKeyDetails> execute(
        String keyPath, {
        String? password,
        String? comment,
    }) {
        return Future(() => LoadSshKeyDetails.load(
            keyPath,
            passphrase: password,
            comment: comment,
        ));
    }
}
