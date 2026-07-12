sealed class MySshKeysEvent {}

class SelectKey extends MySshKeysEvent {
    final String keyPath;
    SelectKey({required this.keyPath});
}

class EditionMode extends MySshKeysEvent {
    final String keyPath;
    EditionMode({required this.keyPath});
}

class AddKey extends MySshKeysEvent {
    final String keyPath;
    AddKey({required this.keyPath});
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