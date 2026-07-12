
import '../model/ssh_connect_fields.dart';

class CheckWrongFieldsUseCase {
    List<SshConnectFields> execute({
        required String user,
        required String url,
        required String port,
        required String filePath,
        required String? password,
        required bool passwordRequired
    }) {
        List<SshConnectFields> wrongFields = [];

        if (user.isEmpty) {
            wrongFields.add(SshConnectFields.user);
        }
        if (url.isEmpty) {
            wrongFields.add(SshConnectFields.url);
        }
        if (port.isEmpty) {
            wrongFields.add(SshConnectFields.port);
        }
        if (filePath.isEmpty) {
            wrongFields.add(SshConnectFields.filePath);
        }
        if (passwordRequired && (password?.isEmpty ?? true)) {
            wrongFields.add(SshConnectFields.password);
        }

        return wrongFields;
    }
}