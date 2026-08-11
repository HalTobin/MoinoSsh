import 'package:util/ssh/ssh_key_algorithm.dart';

sealed class MySshKeysEvent {}

class SelectKey extends MySshKeysEvent {
    final String keyPath;
    SelectKey({required this.keyPath});
}

class AddKey extends MySshKeysEvent {
    final String keyPath;
    AddKey({required this.keyPath});
}

class GenerateKey extends MySshKeysEvent {
    final String name;
    final String? password;
    final SshKeyAlgorithm algorithm;
    GenerateKey({
        required this.name,
        this.password,
        this.algorithm = SshKeyAlgorithm.ed25519,
    });
}

class RenameKey extends MySshKeysEvent {
    final String keyPath;
    final String newName;
    RenameKey({
        required this.keyPath,
        required this.newName
    });
}

class DeleteKey extends MySshKeysEvent {
    final String keyPath;
    DeleteKey({required this.keyPath});
}
