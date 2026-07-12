import 'package:domain/service/ssh_service.dart';
import 'package:feature_file_explorer/data/file_data.dart';

class SelectFileUseCase {
    final SshService sshService;

    const SelectFileUseCase({
        required this.sshService
    });

    Future<FileData> execute(String path) async {
        //TODO()
        throw UnimplementedError();
    }

}