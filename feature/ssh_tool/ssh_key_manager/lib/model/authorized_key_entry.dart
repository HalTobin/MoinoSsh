class AuthorizedKeyEntry {
    final String line;
    final String? comment;
    final bool markedForDeletion;

    const AuthorizedKeyEntry({
        required this.line,
        this.comment,
        this.markedForDeletion = false,
    });

    AuthorizedKeyEntry copyWith({
        bool? markedForDeletion,
    }) {
        return AuthorizedKeyEntry(
            line: line,
            comment: comment,
            markedForDeletion: markedForDeletion ?? this.markedForDeletion,
        );
    }
}

class PendingGeneratedKey {
    final String name;
    final String publicKeyLine;
    final String privateKeyContent;
    final String privateKeyFileName;

    const PendingGeneratedKey({
        required this.name,
        required this.publicKeyLine,
        required this.privateKeyContent,
        required this.privateKeyFileName,
    });
}

class RemoteAuthorizedKeysSnapshot {
    final String authorizedKeysPath;
    final List<AuthorizedKeyEntry> entries;

    const RemoteAuthorizedKeysSnapshot({
        required this.authorizedKeysPath,
        required this.entries,
    });
}
