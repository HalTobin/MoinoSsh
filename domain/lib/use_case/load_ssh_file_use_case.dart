import 'package:util/ssh/load_ssh_file.dart';

class LoadSshFileUseCase {

    bool execute(String filePath) {
        return LoadSshFile.isKeyProtected(filePath);
    }

}