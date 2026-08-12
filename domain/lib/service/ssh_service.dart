import '../model/response_result.dart';
import '../model/ssh/systemctl_command.dart';

abstract interface class SshService {

    Future<ResponseResult<bool>> systemCtlCommand({
        required SystemctlCommand command,
        required String service
    });

    Future<bool> isServiceRunning(String service);

    Future<ResponseResult<List<String>>> getServiceList();

    Future<ResponseResult<String>> executeCommand(String command);

    Future<ResponseResult<bool>> writeFileWithSudo({
        required String filePath,
        required String content,
    });

}