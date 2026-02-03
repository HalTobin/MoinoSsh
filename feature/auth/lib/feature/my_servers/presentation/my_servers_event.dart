import '../model/ConnectWithProfilePasswordMethod.dart';

sealed class MyServersEvent {}

class SelectServer extends MyServersEvent {
    final int serverProfileId;
    SelectServer({required this.serverProfileId});
}

class EditionMode extends MyServersEvent {
    final int? serverProfileId;
    EditionMode({required this.serverProfileId});
}

class ConnectWithProfile extends MyServersEvent {
    final ConnectWithProfilePasswordMethod method;
    ConnectWithProfile({required this.method});
}