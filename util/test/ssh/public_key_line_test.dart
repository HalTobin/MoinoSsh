import 'package:flutter_test/flutter_test.dart';
import 'package:util/ssh/public_key_line.dart';

/// Fixtures produced with `ssh-keygen`; the expected fingerprints are the ones
/// `ssh-keygen -lf` prints for the same keys.
const _ed25519Line =
    'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbqATrCUopG1s0pnzHRRUyKZk9h2iVv4t7YfpaPIBYb test@moino';
const _ed25519Fingerprint = 'SHA256:QiDN8f9htYeJVw+ph134AGvlXs6pyh7yRqfnHJ0AA7s';

const _rsaLine =
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCNxpbxY3/x7UWszZ2ohAMcm6CbIEtk0u7dq+9EulOYE+Kc01R4BV+wAN2mTF55OILcsEsyZ8XYCIczVPmCvsZc+8i0/DnzReskZV7R1om9nx9bCr5PZUi/FhKOzFVXGyf9FYs1+/Wz3hKJZlprPsJlSSExjjkElVHNmCD79rPeCSK6rtIgXrXWRH3dUXYadZynWFXIMO4eDmO4YrZWZX77z5zm8ihx2zg2EiFYVtJf6Q/DCfG9V20PCAxm3taAj4dAeUdw1YrqwXrtzivLoCb1TX3tBQpzSVtmIhGLJdaEQlI2tlDCNWp30hqRQZVJ4rHuZF3IGt5M6L+xVs6Ogbb rsa test key';
const _rsaFingerprint = 'SHA256:pNcWOqg4TLW9D8+L4V06KT8tgsZV4K/xmMMVEDK9Ako';

const _ecdsaLine =
    'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBALp0f4+kmobD2PE9pD+x5tWJUh/uJmARNCry21voReKoxpXEQVMbniSIrPwZWtZsk6tFHngyIjDLlM+rYso6xI= ';
const _ecdsaFingerprint = 'SHA256:Rqiww5T1Ow85t07g/37GxFKvvVtFUE7/1UE+CVPLGgA';

SshPublicKeyLine _parse(String line) {
    final key = SshPublicKeyLine.tryParse(line);
    expect(key, isNotNull, reason: 'expected $line to parse');
    return key!;
}

String _errorFor(String line) {
    final result = SshPublicKeyLine.parse(line);
    expect(result, isA<SshPublicKeyInvalid>(), reason: 'expected $line to fail');
    return (result as SshPublicKeyInvalid).message;
}

void main() {
    group('fingerprints match ssh-keygen', () {
        test('ed25519', () {
            expect(_parse(_ed25519Line).fingerprint, _ed25519Fingerprint);
        });

        test('rsa', () {
            expect(_parse(_rsaLine).fingerprint, _rsaFingerprint);
        });

        test('ecdsa', () {
            expect(_parse(_ecdsaLine).fingerprint, _ecdsaFingerprint);
        });
    });

    group('parsing', () {
        test('splits type, key data and comment', () {
            final key = _parse(_ed25519Line);

            expect(key.options, isNull);
            expect(key.algorithm, 'ssh-ed25519');
            expect(key.comment, 'test@moino');
            expect(key.algorithmLabel, 'Ed25519');
        });

        test('a missing comment stays null', () {
            expect(_parse(_ecdsaLine).comment, isNull);
        });

        test('keeps a multi word comment intact', () {
            expect(_parse(_rsaLine).comment, 'rsa test key');
        });

        test('reads leading options', () {
            final key = _parse('no-pty $_ed25519Line');

            expect(key.options, 'no-pty');
            expect(key.algorithm, 'ssh-ed25519');
            expect(key.comment, 'test@moino');
        });

        test('keeps blanks inside quoted option values', () {
            final key = _parse('command="echo hello world",no-pty $_ed25519Line');

            expect(key.options, 'command="echo hello world",no-pty');
            expect(key.algorithm, 'ssh-ed25519');
            expect(key.fingerprint, _ed25519Fingerprint);
        });

        test('tolerates surrounding whitespace and missing padding', () {
            final unpadded = _ecdsaLine.trim().replaceAll('=', '');

            expect(_parse('  $unpadded  ').fingerprint, _ecdsaFingerprint);
        });

        test('formatting a parsed line round trips it', () {
            expect(_parse(_ed25519Line).format(), _ed25519Line);
            expect(_parse('no-pty $_ed25519Line').format(), 'no-pty $_ed25519Line');
        });

        test('identity ignores options and comment', () {
            final bare = _parse(_ed25519Line);
            final decorated = _parse('no-pty ${_ed25519Line.replaceAll('test@moino', 'other@host')}');

            expect(decorated.identity, bare.identity);
        });

        test('identity differs between keys', () {
            expect(_parse(_rsaLine).identity, isNot(_parse(_ed25519Line).identity));
        });
    });

    group('rejects', () {
        test('an empty line', () {
            expect(_errorFor('   '), contains('Enter a public key'));
        });

        test('a private key block', () {
            const privateKey =
                '-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaA==\n-----END OPENSSH PRIVATE KEY-----';

            expect(_errorFor(privateKey), contains('private key'));
        });

        test('several keys pasted at once', () {
            expect(_errorFor('$_ed25519Line\n$_rsaLine'), contains('single public key line'));
        });

        test('an embedded newline that would inject a second entry', () {
            expect(
                _errorFor('$_ed25519Line\ncommand="rm -rf /" $_rsaLine'),
                contains('single public key line'),
            );
        });

        test('arbitrary text', () {
            expect(_errorFor('hello world'), contains('not a supported key type'));
        });

        test('an unknown key type', () {
            expect(_errorFor('ssh-magic AAAAC3NzaC1lZDI1NTE5'), contains('not a supported key type'));
        });

        test('a line with no key data', () {
            expect(_errorFor('ssh-ed25519'), contains('key data is missing'));
        });

        test('key data that is not base64', () {
            expect(_errorFor('ssh-ed25519 not-base64!!'), contains('not valid base64'));
        });

        test('base64 that is not a key blob', () {
            expect(_errorFor('ssh-ed25519 aGVsbG8gd29ybGQ='), contains('not a public key'));
        });

        test('a key type that disagrees with the key data', () {
            final swapped = _rsaLine.replaceFirst('ssh-rsa', 'ssh-ed25519');

            expect(_errorFor(swapped), contains('but the line says ssh-ed25519'));
        });

        test('truncated key data', () {
            final truncated = _ed25519Line.replaceFirst(
                'AAAAC3NzaC1lZDI1NTE5AAAAIIbqATrCUopG1s0pnzHRRUyKZk9h2iVv4t7YfpaPIBYb',
                'AAAAC3',
            );

            expect(SshPublicKeyLine.tryParse(truncated), isNull);
        });
    });

    group('known algorithms', () {
        test('accepts the common types', () {
            for (final algorithm in [
                'ssh-ed25519',
                'ssh-rsa',
                'rsa-sha2-512',
                'ecdsa-sha2-nistp521',
                'sk-ssh-ed25519@openssh.com',
            ]) {
                expect(SshPublicKeyLine.isKnownAlgorithm(algorithm), isTrue, reason: algorithm);
            }
        });

        test('accepts certificate variants', () {
            for (final algorithm in [
                'ssh-ed25519-cert-v01@openssh.com',
                'ssh-rsa-cert-v01@openssh.com',
                'ecdsa-sha2-nistp256-cert-v01@openssh.com',
                'sk-ssh-ed25519-cert-v01@openssh.com',
            ]) {
                expect(SshPublicKeyLine.isKnownAlgorithm(algorithm), isTrue, reason: algorithm);
            }
        });

        test('rejects anything else', () {
            expect(SshPublicKeyLine.isKnownAlgorithm('ssh-magic'), isFalse);
            expect(SshPublicKeyLine.isKnownAlgorithm('no-pty'), isFalse);
        });
    });
}
