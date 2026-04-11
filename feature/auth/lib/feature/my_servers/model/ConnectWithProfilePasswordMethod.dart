sealed class ConnectWithProfilePasswordMethod {

    static ConnectWithProfilePasswordMethod none() {
        return None();
    }

    static ConnectWithProfilePasswordMethod password(String password, bool save) {
        return Password(password: password, save: save);
    }

    static ConnectWithProfilePasswordMethod biometrics() {
        return Biometrics();
    }

}

class None extends ConnectWithProfilePasswordMethod {}

class Password extends ConnectWithProfilePasswordMethod {
    final String password;
    final bool save;

    Password({
        required this.password,
        required this.save
    });
}

class Biometrics extends ConnectWithProfilePasswordMethod {}