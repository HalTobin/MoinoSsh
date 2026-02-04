import 'package:domain/use_case/load_ssh_file_use_case.dart';
import 'package:domain/use_case/ssh_connect_use_case.dart';
import 'package:feature_auth/feature/my_servers/use_case/auth_from_profile_use_case.dart';
import 'package:feature_auth/feature/my_servers/use_case/watch_server_profiles_use_case.dart';

import 'check_password_requirement_by_server_profile_id_usecase.dart';
import 'check_quick_connect_availability_use_case.dart';
import 'load_profiles_use_case.dart';

class MyServersUseCases {
    final AuthFromProfileUseCase authFromProfileUseCase;
    final LoadProfilesUseCase loadProfilesUseCase;
    final LoadSshFileUseCase loadSshFileUseCase;
    final SshConnectUseCase sshConnectUseCase;
    final CheckPasswordRequirementByServerProfileIdUseCase checkPasswordRequirementByServerProfileIdUseCase;
    final CheckQuickConnectAvailabilityUseCase checkQuickConnectAvailabilityUseCase;
    final WatchServerProfilesUseCase watchServerProfilesUseCase;

    MyServersUseCases({
        required this.authFromProfileUseCase,
        required this.loadProfilesUseCase,
        required this.loadSshFileUseCase,
        required this.sshConnectUseCase,
        required this.checkPasswordRequirementByServerProfileIdUseCase,
        required this.checkQuickConnectAvailabilityUseCase,
        required this.watchServerProfilesUseCase
    });
}