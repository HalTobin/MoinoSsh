import 'package:domain/repository/file_repository.dart';

class DeleteKeyUseCase {
    DeleteKeyUseCase({
        required FileRepository fileRepository
    })
      : _fileRepository = fileRepository;

    final FileRepository _fileRepository;

    Future<void> execute(String sshKeyFilePath) async {
        await _fileRepository.deleteFile(sshKeyFilePath);
    }

}