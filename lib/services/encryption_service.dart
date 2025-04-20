
import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';


/// A singleton service for end-to-end encryption using X25519 + AES-GCM.
class EncryptionService {
  // Private constructor
  EncryptionService._privateConstructor();

  // The single instance of the service
  static final EncryptionService _instance = EncryptionService._privateConstructor();

  /// Factory constructor returns the same instance every time.
  factory EncryptionService() => _instance;

  final X25519 algorithm = X25519();

  /// Generates an X25519 key pair.
  Future<KeyPair> generateKeyPair() async {
    return await algorithm.newKeyPair();
  }

  /// Returns the public key as a base64 encoded string.
  Future<String> getPublicKeyString(KeyPair keyPair) async {
    // Extract the public key and cast it to SimplePublicKey.
    final publicKey = await keyPair.extractPublicKey() as SimplePublicKey;
    return base64Encode(publicKey.bytes);
  }


  /// Imports a base64 encoded public key and returns a SimplePublicKey.
  SimplePublicKey importPublicKey(String base64PublicKey) {
    final bytes = base64Decode(base64PublicKey);
    return SimplePublicKey(bytes, type: KeyPairType.x25519);
  }

  /// Computes the shared secret given my key pair and the friend's public key string.
  Future<SecretKey> computeSharedSecret({
    required KeyPair myKeyPair,
    required String friendPublicKeyStr,
  }) async {
    final friendPublicKey = importPublicKey(friendPublicKeyStr);
    return await algorithm.sharedSecretKey(
      keyPair: myKeyPair,
      remotePublicKey: friendPublicKey,
    );
  }

  /// Derives a 256-bit AES key (for AES-GCM) using HKDF based on the shared secret.
  Future<SecretKey> deriveAesKey(SecretKey sharedSecret) async {
    final hkdf = Hkdf(
      hmac: Hmac.sha256(),
      outputLength: 32, // 32 bytes = 256 bits
    );
    return await hkdf.deriveKey(
      secretKey: sharedSecret,
      nonce: [],
      info: utf8.encode('flutter chat encryption'),
    );
  }

  /// Encrypts the plainText using AES-GCM and returns a SecretBox containing ciphertext, nonce, and MAC.
  Future<SecretBox> encryptMessage(SecretKey aesKey, String plainText) async {
    final aesGcm = AesGcm.with256bits();
    final nonce = List<int>.generate(12, (_) => Random.secure().nextInt(256));
    final secretBox = await aesGcm.encrypt(
      utf8.encode(plainText),
      secretKey: aesKey,
      nonce: nonce,
    );
    return secretBox;
  }

  /// Decrypts the SecretBox to retrieve the clear-text message.
  Future<String> decryptMessage(SecretKey aesKey, SecretBox secretBox) async {
    final aesGcm = AesGcm.with256bits();
    final clearText = await aesGcm.decrypt(
      secretBox,
      secretKey: aesKey,
    );
    return utf8.decode(clearText);
  }

  /// Serializes a SecretBox into a Map that can be stored in Firestore.
  Map<String, dynamic> secretBoxToMap(SecretBox secretBox) {
    return {
      'cipherText': base64Encode(secretBox.cipherText),
      'nonce': base64Encode(secretBox.nonce),
      'mac': base64Encode(secretBox.mac.bytes),
    };
  }

  /// Deserializes the map from Firestore back into a SecretBox.
  SecretBox secretBoxFromMap(Map<String, dynamic> map) {
    return SecretBox(
      base64Decode(map['cipherText'] as String),
      nonce: base64Decode(map['nonce'] as String),
      mac: Mac(base64Decode(map['mac'] as String)),
    );
  }
}
