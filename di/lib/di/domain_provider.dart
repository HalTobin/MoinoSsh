import 'package:domain/use_case/close_sftp_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domain/use_case/add_edit_server_use_case.dart';
import 'package:domain/use_case/check_wrong_fields_use_case.dart';
import 'package:domain/use_case/load_ssh_file_use_case.dart';
import 'package:domain/use_case/ssh_connect_use_case.dart';
import 'package:domain/use_case/check_biometrics_availability_use_case.dart';
import 'package:domain/use_case/get_current_server_profile_use_case.dart';
import 'package:domain/use_case/listen_user_preferences_use_case.dart';
import 'package:data/use_case/check_biometrics_availability_use_case_impl.dart';

class DomainProvider extends StatelessWidget {
  final Widget child;

  const DomainProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => (LoadSshFileUseCase())),
        Provider(create: (context) => (AddEditServerUseCase(serverProfileRepository: context.read()))),
        Provider(create: (context) => (SshConnectUseCase(sshClientService: context.read()))),
        Provider(create: (context) => (CloseSftpUseCase(sftpService: context.read()))),
        Provider(create: (_) => (CheckWrongFieldsUseCase())),
        Provider<CheckBiometricsAvailabilityUseCase>(create: (context) => (CheckBiometricsAvailabilityUseCaseImpl())),
        Provider(
          create: (context) => (
            GetCurrentServerProfileUseCase(
              sshClientService: context.read(),
              serverProfileRepository: context.read(),
            )
          )
        ),
        Provider(create: (context) => (ListenUserPreferencesUseCase(preferenceRepository: context.read()))),
      ],
      child: child,
    );
  }

}