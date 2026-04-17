import 'package:domain/model/response_result.dart';
import 'package:domain/model/ssh/systemctl_command.dart';
import 'package:domain/service/ssh_service.dart';

class RunSystemctlCommandUseCase {
    RunSystemctlCommandUseCase({required SshService sshService})
      : _sshService = sshService;

    final SshService _sshService;

    Future<ResponseResult<bool>> execute({
        required SystemctlCommand command,
        required String service
    }) async {
        return _sshService.systemCtlCommand(command: command, service: service);
    }
}