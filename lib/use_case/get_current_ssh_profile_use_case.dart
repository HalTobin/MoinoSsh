import 'package:domain/model/ssh/ssh_profile.dart';
import 'package:domain/service/ssh_client_service.dart';

class GetCurrentSshProfileUseCase {
    GetCurrentSshProfileUseCase({required SshClientService sshClientService})
        : _sshClientService = sshClientService;

    final SshClientService _sshClientService;

    SshProfile execute() {
        return _sshClientService.getProfile() ?? SshProfile.blank;
    }
}