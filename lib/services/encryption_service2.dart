
import 'dart:convert';
import 'dart:typed_data';

import 'package:sodium/sodium.dart';

/// A service for X25519 key generation and serialization using libsodium.
class EncryptionService2 {
  final Sodium sodium;

  EncryptionService2(this.sodium);

  /// Generates an X25519 key pair
  KeyPair generateKeyPair() => sodium.crypto.box.keyPair();

  /// Returns the public key as a base64 encoded string
  String publicKeyToBase64(KeyPair keyPair) =>
      base64Encode(keyPair.publicKey);

  /// Imports a base64 encoded public key
  Uint8List importPublicKey(String base64Key) =>
      base64Decode(base64Key);

  /// Serializes a [KeyPair] to a map of Base64-encoded strings
  Map<String, String> serializeKeyPair(KeyPair keyPair) =>
      {
        'publicKey': base64Encode(keyPair.publicKey),
        'secretKey' : keyPair.secretKey.runUnlockedSync((Uint8List bytes) {
          return base64Encode(bytes);
        }),
      };

  /// Deserializes a map of Base64 strings back to a [KeyPair]
  KeyPair deserializeKeyPair(

      Map<String, String> serialized,
      ) =>
      KeyPair(
        publicKey:
          base64Decode(serialized['publicKey']!),

        secretKey: sodium.secureCopy(
          base64Decode(serialized['secretKey']!),
        ),
      );

  /// Computes bidirectional session keys
  SessionKeys computeSessionKeys({
    required Map<String, String> myMapKeyPair,
    required String friendPublicKey,
    required bool isClient,
  }) {
    KeyPair myKeyPair = deserializeKeyPair(myMapKeyPair);
    if(isClient){
      return sodium.crypto.kx.clientSessionKeys(
        clientPublicKey: myKeyPair.publicKey, clientSecretKey: myKeyPair.secretKey, serverPublicKey: importPublicKey(friendPublicKey),
      );
    }else{
      return sodium.crypto.kx.serverSessionKeys(
        serverPublicKey: myKeyPair.publicKey, serverSecretKey: myKeyPair.secretKey, clientPublicKey: importPublicKey(friendPublicKey),
      );
    }


  }


  Future<SecureKey> deriveAeadKey(
      SecureKey sessionKey
      ) async {
    return sodium.crypto.kdf.deriveFromKey(masterKey: sessionKey, context: "Chacha20",
        subkeyId: BigInt.from(1), subkeyLen: 32);
  }

  /// Encrypts `plaintext` with `key` and returns base64-encoded nonce + ciphertext + tag.
  String encryptWithAead({
    required SecureKey key,              // 32-byte key from deriveAeadKey()
    required String plaintext,
  }) {



    // Generate a random 24-byte nonce for XChaCha20-Poly1305 (IETF variant)
    final nonce = sodium.randombytes.buf(
      sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
    );

    // Prepare plaintext and optional AAD
    final message = Uint8List.fromList(utf8.encode(plaintext));


    // Encrypt: combined = ciphertext + tag
    final combinedCipher = sodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
      message: message,
      nonce: nonce,
      key: key,
    );

    // Prepend nonce to combined data
    final packed = Uint8List.fromList(nonce + combinedCipher);

    // Return base64 of nonce + ciphertext + tag
    return base64.encode(packed);
  }

  /// Decrypts a base64-encoded value (nonce + ciphertext + tag) with `key`.
  String decryptWithAead({
    required SecureKey key,
    required String combinedBase64,

  }) {
    final packed = base64.decode(combinedBase64);
    print(packed.toString());
    final nonceLen = sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes;
    print(nonceLen);

    // Extract nonce and ciphertext+tag
    final nonce = packed.sublist(0, nonceLen);
    final cipherWithTag = packed.sublist(nonceLen);

    print(nonce.toString());
    print(cipherWithTag.toString());


    // Decrypt and verify
    final plaintextBytes = sodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
      cipherText: cipherWithTag,
      nonce: nonce,
      key: key,

    );
print(plaintextBytes.toString());
    return utf8.decode(plaintextBytes);
  }
}



