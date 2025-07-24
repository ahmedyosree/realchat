//
// import 'dart:convert';
// import 'dart:math';
// import 'package:cryptography/cryptography.dart';
//
//
// /// A singleton service for end-to-end encryption using X25519 + AES-GCM.
// class EncryptionService {
//   // Private constructor
//   EncryptionService._privateConstructor();
//
//   // The single instance of the service
//   static final EncryptionService _instance = EncryptionService._privateConstructor();
//
//   /// Factory constructor returns the same instance every time.
//   factory EncryptionService() => _instance;
//
//   final X25519 algorithm = X25519();
//
//
//
//
//
//
//
//
//
//   ///Computes and returns the AES-GCM key for a chat.
//   Future<SecretKey> computedAesKey({
//     required String friendPublicKeyStr,
//     required String chatId,
//     required Map<String, String> myMapKeyPair
//   }) async {
//
//     final SimpleKeyPairData keyPairData =
//     await mapToKeyPair(myMapKeyPair);
//
//     final SecretKey sharedSecret = await computeSharedSecret(
//       myKeyPair: keyPairData,
//       friendPublicKeyStr: friendPublicKeyStr,
//     );
//     final aesKey = await deriveAesKey(sharedSecret);
//
//
//     return aesKey;
//   }
//
//   /// Converts a [SecretKey] to a base64-encoded string for storage.
//   Future<String> secretKeyToString(SecretKey key) async {
//     final keyData = await key.extract(); // SecretKeyData
//     return base64Encode(keyData.bytes);
//   }
//
//   /// Imports a base64-encoded string back into a [SecretKey].
//   Future<SecretKey> importSecretKey(String base64Key) async {
//     final bytes = base64Decode(base64Key);
//     return SecretKey(bytes);
//   }
//
//
//   /// Encrypts the plainText using AES-GCM and returns a SecretBox containing ciphertext, nonce, and MAC.
//   Future<SecretBox> encryptMessage(SecretKey aesKey, String plainText) async {
//     final aesGcm = AesGcm.with256bits();
//     final nonce = List<int>.generate(12, (_) => Random.secure().nextInt(256));
//     final secretBox = await aesGcm.encrypt(
//       utf8.encode(plainText),
//       secretKey: aesKey,
//       nonce: nonce,
//     );
//     return secretBox;
//   }
//
//   /// Decrypts the SecretBox to retrieve the clear-text message.
//   Future<String> decryptMessage(SecretKey aesKey, SecretBox secretBox) async {
//     final aesGcm = AesGcm.with256bits();
//     final clearText = await aesGcm.decrypt(
//       secretBox,
//       secretKey: aesKey,
//     );
//     return utf8.decode(clearText);
//   }
//
//   /// Serializes a SecretBox into a Map that can be stored in Firestore.
//   Map<String, dynamic> secretBoxToMap(SecretBox secretBox) {
//     return {
//       'cipherText': base64Encode(secretBox.cipherText),
//       'nonce': base64Encode(secretBox.nonce),
//       'mac': base64Encode(secretBox.mac.bytes),
//     };
//   }
//
//   /// Deserializes the map from Firestore back into a SecretBox.
//   SecretBox secretBoxFromMap(Map<String, dynamic> map) {
//     return SecretBox(
//       base64Decode(map['cipherText'] as String),
//       nonce: base64Decode(map['nonce'] as String),
//       mac: Mac(base64Decode(map['mac'] as String)),
//     );
//   }
//   /// Encrypts the plainText using AES-GCM and returns a SecretBox containing ciphertext, nonce, and MAC.
//   /// then Serializes a SecretBox into a Map that can be stored in Firestore.
//   Future<Map<String, dynamic>> encryptMessageToMap(
//       SecretKey aesKey,
//       String plainText,
//       ) async {
//     final secretBox = await encryptMessage(aesKey, plainText);
//     return secretBoxToMap(secretBox);
//   }
// }
