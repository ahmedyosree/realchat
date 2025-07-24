import 'dart:convert';
import 'dart:typed_data';

import 'package:sodium/sodium.dart';

/// Provides X25519 key exchange and XChaCha20-Poly1305-IETF authenticated encryption using libsodium.
class EncryptionService {
  final Sodium sodium;

  EncryptionService(this.sodium);

  /// Generates an X25519 key pair
  KeyPair generateKeyPair() => sodium.crypto.box.keyPair();

  /// Encodes a public key as base64 string
  String publicKeyToBase64(KeyPair keyPair) => base64Encode(keyPair.publicKey);

  /// Decodes a base64-encoded public key into raw bytes
  Uint8List importPublicKey(String base64Key) => base64Decode(base64Key);

  /// Serializes a [KeyPair] to a map of Base64-encoded strings
  Map<String, String> serializeKeyPair(KeyPair keyPair) => {
        'publicKey': base64Encode(keyPair.publicKey),
        'secretKey': keyPair.secretKey.runUnlockedSync((Uint8List bytes) {
          return base64Encode(bytes);
        }),
      };

  /// Deserializes a map of Base64 strings back to a [KeyPair]
  KeyPair deserializeKeyPair(
    Map<String, String> serialized,
  ) =>
      KeyPair(
        publicKey: base64Decode(serialized['publicKey']!),
        secretKey: sodium.secureCopy(
          base64Decode(serialized['secretKey']!),
        ),
      );

  /// Computes session keys using X25519 key exchange (client/server mode)
  SessionKeys computeSessionKeys({
    required Map<String, String> myMapKeyPair,
    required String friendPublicKey,
    required bool isClient,
  }) {
    KeyPair myKeyPair = deserializeKeyPair(myMapKeyPair);
    if (isClient) {
      return sodium.crypto.kx.clientSessionKeys(
        clientPublicKey: myKeyPair.publicKey,
        clientSecretKey: myKeyPair.secretKey,
        serverPublicKey: importPublicKey(friendPublicKey),
      );
    } else {
      return sodium.crypto.kx.serverSessionKeys(
        serverPublicKey: myKeyPair.publicKey,
        serverSecretKey: myKeyPair.secretKey,
        clientPublicKey: importPublicKey(friendPublicKey),
      );
    }
  }

  /// Derives 32-byte AEAD key from session key using HKDF
  Future<SecureKey> deriveAeadKey(SecureKey sessionKey) async {
    return sodium.crypto.kdf.deriveFromKey(
        masterKey: sessionKey,
        context: "Chacha20",
        subkeyId: BigInt.from(1),
        subkeyLen: 32);
  }

  /// Encrypts text with XChaCha20-Poly1305-IETF, returns base64
  String encryptWithAead({
    required SecureKey key,
    required String plaintext,
  }) {
    final nonce = sodium.randombytes.buf(
      sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
    );

    final message = Uint8List.fromList(utf8.encode(plaintext));

    final combinedCipher = sodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
      message: message,
      nonce: nonce,
      key: key,
    );

    final packed = Uint8List.fromList(nonce + combinedCipher);

    return base64.encode(packed);
  }

  /// Decrypts base64 using XChaCha20-Poly1305-IETF
  String decryptWithAead({
    required SecureKey key,
    required String combinedBase64,
  }) {
    final packed = base64.decode(combinedBase64);
    final nonceLen = sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes;

    final nonce = packed.sublist(0, nonceLen);
    final cipherWithTag = packed.sublist(nonceLen);

    final plaintextBytes = sodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
      cipherText: cipherWithTag,
      nonce: nonce,
      key: key,
    );
    return utf8.decode(plaintextBytes);
  }
}
