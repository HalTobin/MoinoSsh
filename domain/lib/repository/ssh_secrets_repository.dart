import '../model/ssh_secret_entry.dart';

abstract interface class SshSecretsRepository {

    Future<SshSecretEntry?> getSecretsByIdentifier(String identifier);

    Future<void> addSecret(SshSecretEntry secret);

    Future<void> deleteSecretsByIdentifier(String identifier);

}