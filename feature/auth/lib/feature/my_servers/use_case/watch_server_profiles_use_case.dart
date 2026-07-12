import 'package:domain/repository/server_profile_repository.dart';
import 'package:feature_auth/feature/my_servers/use_case/check_password_requirement_by_server_profile_id_use_case.dart';

import '../model/server_profile_ui.dart';

class WatchServerProfilesUseCase {
    final ServerProfileRepository serverProfileRepository;
    final CheckPasswordRequirementByServerProfileIdUseCase checkPasswordRequirementByServerProfileIdUseCase;

    WatchServerProfilesUseCase({
        required this.serverProfileRepository,
        required this.checkPasswordRequirementByServerProfileIdUseCase
    });

    Stream<List<ServerProfileUi>> execute() {
        return serverProfileRepository.watchAllProfiles().asyncMap((profiles) async {
            final profileFutures = profiles.map<Future<ServerProfileUi>>((profile) async {
                final requiresPassword = await checkPasswordRequirementByServerProfileIdUseCase.execute(profile.id);

                return ServerProfileUi(
                    id: profile.id,
                    name: profile.name,
                    url: profile.url,
                    port: profile.port,
                    user: profile.user,
                    keyPath: profile.keyPath,
                    securedSshKeyPassword: profile.securedSshKeyPassword,
                    securedSessionPassword: profile.securedSessionPassword,
                    keyRequiresPassword: requiresPassword,
                );
            }).toList();

            return await Future.wait(profileFutures);
        });
    }

}