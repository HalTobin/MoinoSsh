import 'package:domain/service/ssh_service.dart';
import 'package:feature_file_explorer/data/navigation_result.dart';

import '../data/file_entry.dart';

class NavigateUpUseCase {
    final SshService sshService;

    const NavigateUpUseCase({
        required this.sshService
    });

    Future<NavigationResult> execute(String path) async {
        //TODO()
        throw UnimplementedError();
    }

}