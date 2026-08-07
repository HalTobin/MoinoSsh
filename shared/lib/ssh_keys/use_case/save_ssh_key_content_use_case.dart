import 'package:domain/repository/file_repository.dart';

import '../model/ssh_key_folder.dart';

class SaveSshKeyContentUseCase {
    SaveSshKeyContentUseCase({
        required FileRepository fileRepository
    }) : _fileRepository = fileRepository;

    final FileRepository _fileRepository;

    Future<String?> execute({
        required String fileName,
        required String content,
    }) async {
        final savedFile = await _fileRepository.writeInternalFile(
            folder: SshKeyFolder.path,
            fileName: fileName,
            content: content,
        );
        return savedFile?.path;
    }
}
