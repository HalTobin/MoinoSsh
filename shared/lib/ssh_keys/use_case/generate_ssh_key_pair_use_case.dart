import 'package:util/ssh/generate_ssh_key_pair.dart';
import 'package:util/ssh/ssh_key_algorithm.dart';

class GenerateSshKeyPairUseCase {
    Future<GeneratedSshKeyPair> execute({
        required String name,
        String? password,
        SshKeyAlgorithm algorithm = SshKeyAlgorithm.ed25519,
    }) async {
        return GenerateSshKeyPair.generate(
            name: name,
            passphrase: password,
            algorithm: algorithm,
        );
    }
}
