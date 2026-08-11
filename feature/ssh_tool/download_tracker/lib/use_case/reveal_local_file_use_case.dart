import 'package:util/file/reveal_in_file_manager.dart';

class RevealLocalFileUseCase {
    Future<bool> execute(String filePath) {
        return RevealInFileManager.reveal(filePath);
    }
}
