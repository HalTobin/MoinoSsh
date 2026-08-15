import 'package:path/path.dart' as p;

/// Works out which file sshd actually reads keys from.
///
/// `~/.ssh/authorized_keys` is only the default: `AuthorizedKeysFile` in
/// `sshd_config` can point somewhere else entirely, in which case editing the
/// default file has no effect at all.
class AuthorizedKeysLocation {
    const AuthorizedKeysLocation._();

    static const String defaultRelativePath = '.ssh/authorized_keys';

    /// Resolves the path from a home directory, a user name and the
    /// `AuthorizedKeysFile` line as reported by sshd or its config file.
    ///
    /// Returns null when [home] is not usable. [directiveLine] may be empty,
    /// which means the default location applies.
    static String? resolve({
        required String home,
        required String user,
        String directiveLine = '',
    }) {
        final homePath = home.trim();
        if (homePath.isEmpty || !p.posix.isAbsolute(homePath)) {
            return null;
        }

        final pattern = _firstPattern(directiveLine) ?? defaultRelativePath;
        final expanded = _expandTokens(pattern, home: homePath, user: user.trim());

        return p.posix.isAbsolute(expanded)
            ? p.posix.normalize(expanded)
            : p.posix.normalize(p.posix.join(homePath, expanded));
    }

    /// Takes the first path from a directive line, dropping the keyword itself.
    /// sshd accepts several paths and tries each; the first is where a new key
    /// belongs.
    static String? _firstPattern(String directiveLine) {
        final line = directiveLine.trim();
        if (line.isEmpty || line.startsWith('#')) {
            return null;
        }

        final keywordEnd = line.indexOf(RegExp(r'\s'));
        if (keywordEnd < 0 ||
            line.substring(0, keywordEnd).toLowerCase() != 'authorizedkeysfile') {
            return null;
        }

        final remainder = line.substring(keywordEnd).trimLeft();
        if (remainder.isEmpty) {
            return null;
        }

        // A path containing blanks is quoted, so the quotes decide where it ends.
        final String value;
        if (remainder.startsWith('"')) {
            final closingQuote = remainder.indexOf('"', 1);
            value = closingQuote < 0
                ? remainder.substring(1)
                : remainder.substring(1, closingQuote);
        } else {
            final valueEnd = remainder.indexOf(RegExp(r'\s'));
            value = valueEnd < 0 ? remainder : remainder.substring(0, valueEnd);
        }

        if (value.isEmpty || value.toLowerCase() == 'none') {
            return null;
        }
        return value;
    }

    /// Expands the tokens sshd supports in this setting: `%h` home, `%u` user
    /// and `%%` a literal percent.
    static String _expandTokens(
        String pattern, {
        required String home,
        required String user,
    }) {
        final result = StringBuffer();
        for (var i = 0; i < pattern.length; i++) {
            if (pattern[i] != '%' || i == pattern.length - 1) {
                result.write(pattern[i]);
                continue;
            }

            final token = pattern[i + 1];
            switch (token) {
                case 'h':
                    result.write(home);
                case 'u':
                    result.write(user);
                case '%':
                    result.write('%');
                default:
                    result.write('%$token');
            }
            i++;
        }
        return result.toString();
    }
}
