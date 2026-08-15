import 'package:feature_ssh_key_manager/model/authorized_keys_location.dart';
import 'package:flutter_test/flutter_test.dart';

String? resolve(String directiveLine, {String home = '/home/moino', String user = 'moino'}) {
    return AuthorizedKeysLocation.resolve(
        home: home,
        user: user,
        directiveLine: directiveLine,
    );
}

void main() {
    group('without a directive', () {
        test('falls back to the default location', () {
            expect(resolve(''), '/home/moino/.ssh/authorized_keys');
        });

        test('trims a home directory with trailing whitespace', () {
            expect(
                AuthorizedKeysLocation.resolve(home: '/home/moino\n', user: 'moino'),
                '/home/moino/.ssh/authorized_keys',
            );
        });

        test('rejects a home directory that is not absolute', () {
            expect(AuthorizedKeysLocation.resolve(home: 'moino', user: 'moino'), isNull);
        });

        test('rejects an empty home directory', () {
            expect(AuthorizedKeysLocation.resolve(home: '', user: 'moino'), isNull);
        });
    });

    group('with a directive', () {
        test('resolves a relative path against home', () {
            expect(
                resolve('AuthorizedKeysFile .ssh/my_keys'),
                '/home/moino/.ssh/my_keys',
            );
        });

        test('keeps an absolute path', () {
            expect(
                resolve('AuthorizedKeysFile /etc/ssh/keys/moino'),
                '/etc/ssh/keys/moino',
            );
        });

        test('expands %h', () {
            expect(
                resolve('AuthorizedKeysFile %h/.ssh/authorized_keys'),
                '/home/moino/.ssh/authorized_keys',
            );
        });

        test('expands %u', () {
            expect(
                resolve('AuthorizedKeysFile /etc/ssh/keys/%u'),
                '/etc/ssh/keys/moino',
            );
        });

        test('expands %h and %u together', () {
            expect(
                resolve('AuthorizedKeysFile %h/.ssh/%u.keys'),
                '/home/moino/.ssh/moino.keys',
            );
        });

        test('expands %% to a literal percent', () {
            expect(
                resolve('AuthorizedKeysFile /etc/keys/100%%/%u'),
                '/etc/keys/100%/moino',
            );
        });

        test('leaves an unknown token alone', () {
            expect(
                resolve('AuthorizedKeysFile /etc/keys/%z/%u'),
                '/etc/keys/%z/moino',
            );
        });

        test('takes the first of several paths', () {
            expect(
                resolve('AuthorizedKeysFile .ssh/first .ssh/second'),
                '/home/moino/.ssh/first',
            );
        });

        test('accepts the lower case form sshd -T prints', () {
            expect(
                resolve('authorizedkeysfile .ssh/authorized_keys .ssh/authorized_keys2'),
                '/home/moino/.ssh/authorized_keys',
            );
        });

        test('tolerates leading whitespace from the config file', () {
            expect(
                resolve('   AuthorizedKeysFile\t.ssh/tabbed'),
                '/home/moino/.ssh/tabbed',
            );
        });

        test('strips quotes around the path', () {
            expect(
                resolve('AuthorizedKeysFile "/etc/ssh/my keys"'),
                '/etc/ssh/my keys',
            );
        });

        test('normalises a path with redundant segments', () {
            expect(
                resolve('AuthorizedKeysFile .ssh/../.ssh/authorized_keys'),
                '/home/moino/.ssh/authorized_keys',
            );
        });
    });

    group('falls back to the default when the directive is unusable', () {
        test('a commented out line', () {
            expect(
                resolve('# AuthorizedKeysFile /etc/ssh/keys/%u'),
                '/home/moino/.ssh/authorized_keys',
            );
        });

        test('a different directive', () {
            expect(
                resolve('PermitRootLogin no'),
                '/home/moino/.ssh/authorized_keys',
            );
        });

        test('the keyword with no value', () {
            expect(
                resolve('AuthorizedKeysFile'),
                '/home/moino/.ssh/authorized_keys',
            );
        });

        test('the value none', () {
            expect(
                resolve('AuthorizedKeysFile none'),
                '/home/moino/.ssh/authorized_keys',
            );
        });
    });
}
