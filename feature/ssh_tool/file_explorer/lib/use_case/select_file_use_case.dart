import 'package:domain/service/ssh_service.dart';

import '../data/file_entry.dart';

class SelectFileUseCase {
    final SshService sshService;

    const SelectFileUseCase({
        required this.sshService
    });

    Future<List<FileEntry>> execute(String path) async {
        //TODO()
        throw UnimplementedError();
    }

}