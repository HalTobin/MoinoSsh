import 'package:feature_auth/feature/my_servers/model/server_profile_ui.dart';

import '../model/connect_with_profile_password_method.dart';

sealed class MyServersEvent {}

class ConnectWithProfile extends MyServersEvent {
    final ServerProfileUi profile;
    final ConnectWithProfilePasswordMethod method;

    ConnectWithProfile({required this.profile, required this.method});
}