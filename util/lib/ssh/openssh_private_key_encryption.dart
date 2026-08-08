import 'dart:math';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:dartssh2/src/utils/bcrypt.dart';
import 'package:dartssh2/src/utils/cipher_ext.dart';

class OpenSshPrivateKeyEncryption {
    static const int _bcryptRounds = 16;

    static OpenSSHKeyPairs encrypt({
        required OpenSSHKeyPairs unencryptedPairs,
        required String passphrase,
    }) {
        final cipher = SSHCipherType.aes256ctr;
        final salt = _randomBytes(16);
        final kdfOptions = OpenSSHBcryptKdfOptions(salt, _bcryptRounds);
        final paddedPrivateKeyBlob = _padToCipherBlockSize(
            unencryptedPairs.privateKeyBlob,
            cipher.blockSize,
        );

        final passphraseBytes = Uint8List.fromList(passphrase.codeUnits);
        final kdfHash = Uint8List(cipher.keySize + cipher.ivSize);

        bcrypt_pbkdf(
            passphraseBytes,
            passphraseBytes.length,
            salt,
            salt.length,
            kdfHash,
            kdfHash.length,
            _bcryptRounds,
        );

        final key = Uint8List.sublistView(kdfHash, 0, cipher.keySize);
        final iv = Uint8List.sublistView(kdfHash, cipher.keySize, cipher.keySize + cipher.ivSize);
        final encryptCipher = cipher.createCipher(key, iv, forEncryption: true);
        final encryptedPrivateKeyBlob = encryptCipher.processAll(paddedPrivateKeyBlob);

        return OpenSSHKeyPairs(
            cipherName: cipher.name,
            kdfName: 'bcrypt',
            kdfOptions: kdfOptions,
            publicKeys: unencryptedPairs.publicKeys,
            privateKeyBlob: encryptedPrivateKeyBlob,
        );
    }

    static Uint8List _padToCipherBlockSize(Uint8List data, int blockSize) {
        final padLength = (blockSize - (data.length % blockSize)) % blockSize;
        if (padLength == 0) {
            return data;
        }

        final padded = Uint8List(data.length + padLength);
        padded.setRange(0, data.length, data);
        for (var i = 0; i < padLength; i++) {
            padded[data.length + i] = i + 1;
        }
        return padded;
    }

    static Uint8List _randomBytes(int length) {
        final random = Random.secure();
        return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
    }
}
