import 'package:domain/repository/file_repository.dart';

class RenameKeyUseCase {
    RenameKeyUseCase({
        required FileRepository fileRepository
    })
      : _fileRepository = fileRepository;

    final FileRepository _fileRepository;

    Future<String?> execute(String sshKeyFilePath, String newName) async {
        final file = await _fileRepository.rename(sshKeyFilePath, newName);
        return file?.path;
    }

}