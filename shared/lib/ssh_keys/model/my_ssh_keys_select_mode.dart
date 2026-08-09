enum MySshKeysSelectMode {
  /// Returns the private key file path (e.g. auth profile picker).
  privateKeyPath,

  /// Returns the OpenSSH public key line (e.g. remote authorized_keys).
  publicKeyLine,
}
