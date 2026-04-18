import 'package:feature_systemd_services/use_case/run_systemctl_command_use_case.dart';
import 'package:feature_systemd_services/use_case/service_watcher_use_case.dart';

import 'list_folder_content_use_case.dart';

class FileExplorerUseCases {
    final ListFolderContentUseCase listFolderContentUseCase;

    FileExplorerUseCases({
        required this.listFolderContentUseCase
    });
}