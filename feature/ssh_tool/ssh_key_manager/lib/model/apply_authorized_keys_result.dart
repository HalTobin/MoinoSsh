sealed class ApplyAuthorizedKeysResult {
    const ApplyAuthorizedKeysResult();
}

class ApplyAuthorizedKeysSucceeded extends ApplyAuthorizedKeysResult {
    const ApplyAuthorizedKeysSucceeded();
}

/// The remote file no longer matches what was read, so writing would discard
/// somebody else's change.
class ApplyAuthorizedKeysConflict extends ApplyAuthorizedKeysResult {
    const ApplyAuthorizedKeysConflict();
}

class ApplyAuthorizedKeysFailed extends ApplyAuthorizedKeysResult {
    final String error;
    const ApplyAuthorizedKeysFailed(this.error);
}
