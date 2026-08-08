import 'package:util/ssh/generate_ssh_key_pair.dart';

class GenerateSshKeyPairUseCase {
    Future<GeneratedSshKeyPair> execute({
        required String name,
        String? password,
    }) async {
        return GenerateSshKeyPair.generate(
            name: name,
            passphrase: password,
        );
    }
}
