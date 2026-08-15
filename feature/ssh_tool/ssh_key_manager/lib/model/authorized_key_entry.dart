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

class RemoteAuthorizedKeysSnapshot {
    final String authorizedKeysPath;
    final List<AuthorizedKeyEntry> entries;

    /// False only when the remote confirmed the file is absent. An unreadable
    /// file never produces a snapshot, so empty [entries] always means empty.
    final bool fileExists;

    const RemoteAuthorizedKeysSnapshot({
        required this.authorizedKeysPath,
        required this.entries,
        required this.fileExists,
    });
}
