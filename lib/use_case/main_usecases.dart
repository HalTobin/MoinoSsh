import 'package:domain/use_case/check_biometrics_availability_use_case.dart';
import 'package:ls_server_app/use_case/fetch_ssh_password_use_case.dart';
import 'package:ls_server_app/use_case/get_current_ssh_profile_use_case.dart';
import 'package:ls_server_app/use_case/listen_is_current_ssh_profile_password_available_use_case.dart';
import 'package:ls_server_app/use_case/listen_ssh_connect_usecase.dart';
import 'package:ls_server_app/use_case/save_ssh_user_password_use_case.dart';
import 'package:ls_server_app/use_case/set_on_password_request_use_case.dart';
import 'package:ls_server_app/use_case/ssh_log_out_usecase.dart';

class MainUseCases {
    final ListenSshConnectUseCase listenSshConnectUseCase;
    final SshLogOutUseCase sshLogOutUseCase;
    final GetCurrentSshProfileUseCase getCurrentSshProfileUseCase;
    final SetOnPasswordRequestUseCase setOnPasswordRequestUseCase;
    final ListenIsCurrentSshProfilePasswordAvailableUseCase listenIsCurrentSshProfilePasswordAvailableUseCase;
    final FetchSshPasswordUseCase fetchSshPasswordUseCase;
    final CheckBiometricsAvailabilityUseCase checkBiometricsAvailabilityUseCase;
    final SaveSshUserPasswordUseCase saveSshUserPasswordUseCase;

    MainUseCases({
        required this.listenSshConnectUseCase,
        required this.sshLogOutUseCase,
        required this.getCurrentSshProfileUseCase,
        required this.setOnPasswordRequestUseCase,
        required this.listenIsCurrentSshProfilePasswordAvailableUseCase,
        required this.fetchSshPasswordUseCase,
        required this.checkBiometricsAvailabilityUseCase,
        required this.saveSshUserPasswordUseCase
    });
}