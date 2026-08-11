enum SshKeyAlgorithm {
  ed25519,
  rsa2048,
  rsa3072,
  rsa4096,
  ecdsaP256,
  ecdsaP384,
  ecdsaP521;

  String get label {
    switch (this) {
      case SshKeyAlgorithm.ed25519:
        return 'Ed25519';
      case SshKeyAlgorithm.rsa2048:
        return 'RSA 2048';
      case SshKeyAlgorithm.rsa3072:
        return 'RSA 3072';
      case SshKeyAlgorithm.rsa4096:
        return 'RSA 4096';
      case SshKeyAlgorithm.ecdsaP256:
        return 'ECDSA nistp256';
      case SshKeyAlgorithm.ecdsaP384:
        return 'ECDSA nistp384';
      case SshKeyAlgorithm.ecdsaP521:
        return 'ECDSA nistp521';
    }
  }

  String get defaultFileName {
    switch (this) {
      case SshKeyAlgorithm.ed25519:
        return 'id_ed25519';
      case SshKeyAlgorithm.rsa2048:
      case SshKeyAlgorithm.rsa3072:
      case SshKeyAlgorithm.rsa4096:
        return 'id_rsa';
      case SshKeyAlgorithm.ecdsaP256:
      case SshKeyAlgorithm.ecdsaP384:
      case SshKeyAlgorithm.ecdsaP521:
        return 'id_ecdsa';
    }
  }

  int? get rsaBits {
    switch (this) {
      case SshKeyAlgorithm.rsa2048:
        return 2048;
      case SshKeyAlgorithm.rsa3072:
        return 3072;
      case SshKeyAlgorithm.rsa4096:
        return 4096;
      default:
        return null;
    }
  }

  String? get ecdsaCurveId {
    switch (this) {
      case SshKeyAlgorithm.ecdsaP256:
        return 'nistp256';
      case SshKeyAlgorithm.ecdsaP384:
        return 'nistp384';
      case SshKeyAlgorithm.ecdsaP521:
        return 'nistp521';
      default:
        return null;
    }
  }
}
