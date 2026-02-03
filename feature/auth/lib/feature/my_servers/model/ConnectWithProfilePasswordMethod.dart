sealed class ConnectWithProfilePasswordMethod {
  static ConnectWithProfilePasswordMethod none() {
    return None();
  }
  static ConnectWithProfilePasswordMethod password(String password) {
    return Password(password: password);
  }
  static ConnectWithProfilePasswordMethod biometrics() {
    return Biometrics();
  }
}

class None extends ConnectWithProfilePasswordMethod {}

class Password extends ConnectWithProfilePasswordMethod {
  final String password;
  Password({required this.password});
}

class Biometrics extends ConnectWithProfilePasswordMethod {}