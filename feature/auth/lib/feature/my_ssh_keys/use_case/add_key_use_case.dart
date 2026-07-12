import 'package:domain/repository/file_repository.dart';

import '../domain/ssh_key_folder.dart';

class AddKeyUseCase {
    AddKeyUseCase({
        required FileRepository fileRepository
    })
      : _fileRepository = fileRepository;

    final FileRepository _fileRepository;

    Future<String?> execute(String sshKeyFilePath) async {
        final copiedKey = await _fileRepository.copyFileInternal(sshKeyFilePath, SshKeyFolder.path);
        return copiedKey?.path;
    }

}