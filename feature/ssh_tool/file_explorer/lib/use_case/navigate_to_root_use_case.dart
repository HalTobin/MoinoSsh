import 'package:domain/service/ssh_service.dart';
import 'package:feature_file_explorer/data/navigation_result.dart';

import '../data/file_entry.dart';

class NavigateToRootUseCase {
    final SshService sshService;

    const NavigateToRootUseCase({
        required this.sshService
    });

    Future<NavigationResult> execute() async {
        //TODO()
        throw UnimplementedError();
    }

}