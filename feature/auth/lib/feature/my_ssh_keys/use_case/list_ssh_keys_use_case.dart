import 'package:domain/repository/file_repository.dart';
import 'package:util/ssh/load_ssh_file.dart';

import '../domain/ssh_key_file.dart';
import '../domain/ssh_key_folder.dart';

class ListSshKeysUseCase {
    ListSshKeysUseCase({
        required FileRepository fileRepository
    })
      : _fileRepository = fileRepository;

    final FileRepository _fileRepository;

    Future<List<SshKeyFile>> execute() async {
        final files = await _fileRepository.listInternalFolderContent(SshKeyFolder.path);

        return files
            .where((file) => !file.isDirectory)
            .map((file) =>
                SshKeyFile(
                    name: file.name,
                    path: file.path,
                    secured: LoadSshFile.isKeyProtected(file.path)
                )
            )
            .toList()
            ..sort((a, b) => a.name.compareTo(b.name));
    }

}