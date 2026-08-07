import 'package:util/ssh/generate_ssh_key_pair.dart';

import '../model/authorized_key_entry.dart';

class GenerateSshKeyPairUseCase {
    Future<PendingGeneratedKey> execute({required String name}) async {
        final generated = await GenerateSshKeyPair.generate(name: name);

        return PendingGeneratedKey(
            name: name.trim(),
            publicKeyLine: generated.publicKeyLine,
            privateKeyContent: generated.privateKeyContent,
            privateKeyFileName: generated.privateKeyFileName,
        );
    }
}
