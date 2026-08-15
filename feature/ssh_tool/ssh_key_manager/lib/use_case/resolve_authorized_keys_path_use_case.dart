import 'package:domain/model/response_result.dart';
import 'package:domain/service/ssh_service.dart';

import '../model/authorized_keys_location.dart';

/// Asks the server where its own authorized keys live, rather than assuming.
class ResolveAuthorizedKeysPathUseCase {
    ResolveAuthorizedKeysPathUseCase({required SshService sshService})
        : _sshService = sshService;

    final SshService _sshService;

    /// Prints the home directory, the user name and the `AuthorizedKeysFile`
    /// line, one per line. `sshd -T` needs root and is expected to fail for a
    /// normal account, so the config file is read as a fallback and an empty
    /// third line simply means "the default applies".
    static const String _probeCommand = r'''
home=$(cd ~ 2>/dev/null && pwd) || home=$HOME
user=$(id -un 2>/dev/null || whoami)
setting=$( { sshd -T 2>/dev/null || /usr/sbin/sshd -T 2>/dev/null; } | grep -i '^authorizedkeysfile' | head -n 1 )
if [ -z "$setting" ]; then
    setting=$(grep -iE '^[[:space:]]*AuthorizedKeysFile[[:space:]]+' /etc/ssh/sshd_config 2>/dev/null | head -n 1)
fi
printf '%s\n%s\n%s\n' "$home" "$user" "$setting"
''';

    Future<ResponseResult<String>> execute() async {
        final result = await _sshService.executeCommand(_probeCommand);
        switch (result) {
            case ResponseFailed(error: final error):
                return ResponseFailed(error: error);
            case ResponseSucceed(data: final output):
                final lines = output.split('\n');
                final path = AuthorizedKeysLocation.resolve(
                    home: lines.isNotEmpty ? lines[0] : '',
                    user: lines.length > 1 ? lines[1] : '',
                    directiveLine: lines.length > 2 ? lines[2].trim() : '',
                );

                if (path == null) {
                    return ResponseFailed(
                        error: 'Could not resolve the remote home directory',
                    );
                }
                return ResponseSucceed(path);
        }
    }
}
