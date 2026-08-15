import 'package:feature_ssh_key_manager/model/authorized_keys_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:util/ssh/public_key_line.dart';

const _keyA =
    'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbqATrCUopG1s0pnzHRRUyKZk9h2iVv4t7YfpaPIBYb test@moino';
const _keyB =
    'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBALp0f4+kmobD2PE9pD+x5tWJUh/uJmARNCry21voReKoxpXEQVMbniSIrPwZWtZsk6tFHngyIjDLlM+rYso6xI=';

void main() {
    group('parse', () {
        test('reads key lines', () {
            final file = AuthorizedKeysFile.parse('$_keyA\n$_keyB\n');

            expect(file.keyEntries.length, 2);
            expect(file.keyEntries.first.comment, 'test@moino');
            expect(file.keyEntries.last.comment, isNull);
        });

        test('keeps comments and blank lines as non key lines', () {
            final file = AuthorizedKeysFile.parse('# managed by moino\n\n$_keyA\n');

            expect(file.keyEntries.length, 1);
            expect(file.lines.length, 3);
            expect(file.lines.first, isA<AuthorizedKeysOtherLine>());
        });

        test('keeps unrecognised lines instead of treating them as keys', () {
            final file = AuthorizedKeysFile.parse('this is not a key\n$_keyA\n');

            expect(file.keyEntries.length, 1);
            expect(file.lines.first, isA<AuthorizedKeysOtherLine>());
        });

        test('an empty file has no lines', () {
            expect(AuthorizedKeysFile.parse('').lines, isEmpty);
        });

        test('gives every line a distinct id', () {
            final file = AuthorizedKeysFile.parse('$_keyA\n$_keyA\n');
            final ids = file.keyEntries.map((entry) => entry.id).toList();

            expect(ids.length, 2);
            expect(ids.first, isNot(ids.last));
        });
    });

    group('render', () {
        test('an untouched file round trips byte for byte', () {
            const content =
                '# moino managed\n\n$_keyA\nnot a key line\n  $_keyB  \n# trailing comment\n';

            expect(AuthorizedKeysFile.parse(content).render(), content);
        });

        test('a file without a trailing newline gains one', () {
            expect(AuthorizedKeysFile.parse(_keyA).render(), '$_keyA\n');
        });

        test('preserves a blank line at the end', () {
            const content = '$_keyA\n\n';

            expect(AuthorizedKeysFile.parse(content).render(), content);
        });

        test('drops only the key marked for deletion', () {
            final file = AuthorizedKeysFile.parse('# keep me\n$_keyA\n$_keyB\n');
            final target = file.keyEntries.first.id;

            expect(
                file.toggleDeletion(target).render(),
                '# keep me\n$_keyB\n',
            );
        });

        test('deleting one of two identical keys keeps the other', () {
            final file = AuthorizedKeysFile.parse('$_keyA\n$_keyA\n');

            expect(
                file.toggleDeletion(file.keyEntries.first.id).render(),
                '$_keyA\n',
            );
        });

        test('appends staged keys after the existing content', () {
            final file = AuthorizedKeysFile.parse('# header\n$_keyA\n');

            expect(
                file.render(stagedPublicKeyLines: [_keyB]),
                '# header\n$_keyA\n$_keyB\n',
            );
        });

        test('removing every key yields an empty file', () {
            var file = AuthorizedKeysFile.parse('$_keyA\n$_keyB\n');
            for (final entry in file.keyEntries) {
                file = file.toggleDeletion(entry.id);
            }

            expect(file.render(), '');
        });
    });

    group('deletion marks', () {
        test('toggle on and off', () {
            final file = AuthorizedKeysFile.parse('$_keyA\n');
            final id = file.keyEntries.first.id;

            expect(file.toggleDeletion(id).hasDeletions, isTrue);
            expect(file.toggleDeletion(id).toggleDeletion(id).hasDeletions, isFalse);
        });

        test('clearDeletions resets every mark', () {
            var file = AuthorizedKeysFile.parse('$_keyA\n$_keyB\n');
            for (final entry in file.keyEntries) {
                file = file.toggleDeletion(entry.id);
            }

            expect(file.clearDeletions().deletionCount, 0);
        });

        test('carry over to a reloaded file by key, not by position', () {
            final original = AuthorizedKeysFile.parse('$_keyA\n$_keyB\n');
            final marked = original.toggleDeletion(original.keyEntries.last.id);

            // The same keys came back in the opposite order.
            final reloaded = AuthorizedKeysFile.parse('$_keyB\n$_keyA\n');
            final result = marked.transferDeletionsTo(reloaded);

            expect(result.deletionCount, 1);
            expect(result.entriesMarkedForDeletion.first.key.comment, isNull);
        });

        test('are dropped for keys that are gone from the reloaded file', () {
            final original = AuthorizedKeysFile.parse('$_keyA\n$_keyB\n');
            final marked = original.toggleDeletion(original.keyEntries.last.id);

            final reloaded = AuthorizedKeysFile.parse('$_keyA\n');

            expect(marked.transferDeletionsTo(reloaded).deletionCount, 0);
        });
    });

    group('safety checks', () {
        test('containsKey ignores the comment', () {
            final file = AuthorizedKeysFile.parse('$_keyA\n');
            final sameKeyOtherComment = SshPublicKeyLine.tryParse(
                _keyA.replaceAll('test@moino', 'someone@else'),
            );

            expect(file.containsKey(sameKeyOtherComment!), isTrue);
        });

        test('containsKey is false for a different key', () {
            final file = AuthorizedKeysFile.parse('$_keyA\n');

            expect(file.containsKey(SshPublicKeyLine.tryParse(_keyB)!), isFalse);
        });

        test('wouldRemoveEveryKey is true when all keys are marked', () {
            var file = AuthorizedKeysFile.parse('$_keyA\n$_keyB\n');
            for (final entry in file.keyEntries) {
                file = file.toggleDeletion(entry.id);
            }

            expect(file.wouldRemoveEveryKey(const []), isTrue);
        });

        test('wouldRemoveEveryKey is false when a key is staged to replace them', () {
            var file = AuthorizedKeysFile.parse('$_keyA\n');
            file = file.toggleDeletion(file.keyEntries.first.id);

            expect(file.wouldRemoveEveryKey([_keyB]), isFalse);
        });

        test('wouldRemoveEveryKey is false when a key is kept', () {
            final file = AuthorizedKeysFile.parse('$_keyA\n$_keyB\n');

            expect(
                file.toggleDeletion(file.keyEntries.first.id).wouldRemoveEveryKey(const []),
                isFalse,
            );
        });

        test('wouldRemoveEveryKey is false for an already empty file', () {
            expect(AuthorizedKeysFile.empty.wouldRemoveEveryKey(const []), isFalse);
        });
    });
}
