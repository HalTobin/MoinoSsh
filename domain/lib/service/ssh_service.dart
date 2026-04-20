import 'package:flutter/foundation.dart';

import '../model/ssh/connection_status.dart';
import '../model/response_result.dart';
import '../model/ssh/ssh_profile.dart';
import '../model/ssh/systemctl_command.dart';

abstract interface class SshService {

    Future<ResponseResult<bool>> systemCtlCommand({
        required SystemctlCommand command,
        required String service
    });

    Future<bool> isServiceRunning(String service);

    Future<ResponseResult<List<String>>> getServiceList();

}