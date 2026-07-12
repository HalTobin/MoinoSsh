sealed class ConnectionStatus {}

class ConnectionSucceed extends ConnectionStatus {}

class ConnectionFailed extends ConnectionStatus {
    final String error;
    ConnectionFailed({required this.error});
}