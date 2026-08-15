import 'package:util/ssh/public_key_line.dart';

/// One line of an `authorized_keys` file, keeping its original text so anything
/// the app does not understand survives a rewrite untouched.
sealed class AuthorizedKeysLine {
    /// Position in the file, stable for as long as the snapshot lives. Used to
    /// address a line so two identical keys can be told apart.
    final int id;

    /// The line exactly as read from the file.
    final String raw;

    const AuthorizedKeysLine({
        required this.id,
        required this.raw,
    });
}

/// A line holding a usable public key.
class AuthorizedKeyEntry extends AuthorizedKeysLine {
    final SshPublicKeyLine key;
    final bool markedForDeletion;

    const AuthorizedKeyEntry({
        required super.id,
        required super.raw,
        required this.key,
        this.markedForDeletion = false,
    });

    String? get comment => key.comment;
    String get fingerprint => key.fingerprint;
    String get algorithmLabel => key.algorithmLabel;

    AuthorizedKeyEntry copyWith({bool? markedForDeletion}) {
        return AuthorizedKeyEntry(
            id: id,
            raw: raw,
            key: key,
            markedForDeletion: markedForDeletion ?? this.markedForDeletion,
        );
    }
}

/// A comment, a blank line, or a line that is not a public key. Preserved
/// verbatim and never shown as a key.
class AuthorizedKeysOtherLine extends AuthorizedKeysLine {
    const AuthorizedKeysOtherLine({
        required super.id,
        required super.raw,
    });
}

/// The parsed contents of an `authorized_keys` file.
class AuthorizedKeysFile {
    final List<AuthorizedKeysLine> lines;

    const AuthorizedKeysFile(this.lines);

    static const AuthorizedKeysFile empty = AuthorizedKeysFile([]);

    static AuthorizedKeysFile parse(String content) {
        final rawLines = content.split('\n');
        // A trailing newline terminates the last line, it does not start a new one.
        if (rawLines.isNotEmpty && rawLines.last.isEmpty) {
            rawLines.removeLast();
        }

        final lines = <AuthorizedKeysLine>[];
        for (var index = 0; index < rawLines.length; index++) {
            final raw = rawLines[index];
            final trimmed = raw.trim();

            if (trimmed.isEmpty || trimmed.startsWith('#')) {
                lines.add(AuthorizedKeysOtherLine(id: index, raw: raw));
                continue;
            }

            final key = SshPublicKeyLine.tryParse(trimmed);
            if (key == null) {
                lines.add(AuthorizedKeysOtherLine(id: index, raw: raw));
                continue;
            }

            lines.add(AuthorizedKeyEntry(id: index, raw: raw, key: key));
        }

        return AuthorizedKeysFile(lines);
    }

    List<AuthorizedKeyEntry> get keyEntries =>
        lines.whereType<AuthorizedKeyEntry>().toList();

    Iterable<AuthorizedKeyEntry> get entriesMarkedForDeletion =>
        keyEntries.where((entry) => entry.markedForDeletion);

    int get deletionCount => entriesMarkedForDeletion.length;

    bool get hasDeletions => deletionCount > 0;

    bool containsKey(SshPublicKeyLine key) =>
        keyEntries.any((entry) => entry.key.identity == key.identity);

    /// True when applying [stagedPublicKeyLines] would leave no keys at all,
    /// which locks key based login out of the account.
    bool wouldRemoveEveryKey(List<String> stagedPublicKeyLines) {
        if (stagedPublicKeyLines.isNotEmpty) {
            return false;
        }
        final entries = keyEntries;
        return entries.isNotEmpty && entries.every((entry) => entry.markedForDeletion);
    }

    AuthorizedKeysFile toggleDeletion(int id) {
        return AuthorizedKeysFile(
            lines.map((line) {
                if (line case AuthorizedKeyEntry entry when entry.id == id) {
                    return entry.copyWith(markedForDeletion: !entry.markedForDeletion);
                }
                return line;
            }).toList(),
        );
    }

    AuthorizedKeysFile clearDeletions() {
        return AuthorizedKeysFile(
            lines.map((line) {
                if (line case AuthorizedKeyEntry entry) {
                    return entry.copyWith(markedForDeletion: false);
                }
                return line;
            }).toList(),
        );
    }

    /// Carries deletion marks over to a freshly loaded [file], keeping them only
    /// for keys that are still present.
    AuthorizedKeysFile transferDeletionsTo(AuthorizedKeysFile file) {
        final markedIdentities = entriesMarkedForDeletion
            .map((entry) => entry.key.identity)
            .toSet();
        if (markedIdentities.isEmpty) {
            return file;
        }

        return AuthorizedKeysFile(
            file.lines.map((line) {
                if (line case AuthorizedKeyEntry entry
                    when markedIdentities.contains(entry.key.identity)) {
                    return entry.copyWith(markedForDeletion: true);
                }
                return line;
            }).toList(),
        );
    }

    /// Renders the file back to text: untouched lines keep their original form,
    /// lines marked for deletion are dropped, and [stagedPublicKeyLines] are
    /// appended.
    String render({List<String> stagedPublicKeyLines = const []}) {
        final rendered = <String>[];

        for (final line in lines) {
            switch (line) {
                case AuthorizedKeyEntry():
                    if (!line.markedForDeletion) {
                        rendered.add(line.raw);
                    }
                case AuthorizedKeysOtherLine():
                    rendered.add(line.raw);
            }
        }

        rendered.addAll(stagedPublicKeyLines);

        if (rendered.isEmpty) {
            return '';
        }
        return '${rendered.join('\n')}\n';
    }
}

/// What was read from the remote, together with where it came from.
class RemoteAuthorizedKeysSnapshot {
    final String authorizedKeysPath;
    final AuthorizedKeysFile file;

    /// False only when the remote confirmed the file is absent. An unreadable
    /// file never produces a snapshot, so an empty [file] always means empty.
    final bool fileExists;

    /// Digest of the content this snapshot was built from, empty when the file
    /// did not exist. Compared before writing to catch a concurrent change.
    final String contentHash;

    const RemoteAuthorizedKeysSnapshot({
        required this.authorizedKeysPath,
        required this.file,
        required this.fileExists,
        required this.contentHash,
    });
}
