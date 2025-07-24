// // lib/crypto/key_derivation_helpers.dart
//
// import 'dart:convert';
// import '../../../../services/encryption_service.dart';
//
// /// Simple DTO to wrap all inputs for the isolate.
// class KeyDerivationParams {
//   final String friendPublicKey;
//   final String chatId;
//   final Map<String, String> myKeyPairMap;
//
//   KeyDerivationParams({
//     required this.friendPublicKey,
//     required this.chatId,
//     required this.myKeyPairMap,
//   });
// }
//
// final X25519 algorithm = X25519();
//
//
// /// Imports a base64 encoded public key and returns a SimplePublicKey.
// SimplePublicKey importPublicKey(String base64PublicKey) {
//   final bytes = base64Decode(base64PublicKey);
//   return SimplePublicKey(bytes, type: KeyPairType.x25519);
// }
//
// /// Deserializes a map of Base64 strings back to an X25519 [SimpleKeyPairData].
// Future<SimpleKeyPairData> mapToKeyPair(Map<String, String> keyPairMap) async {
//   // Decode the Base64-encoded private key bytes
//   final privateKeyBytes = base64Decode(keyPairMap['privateKey']!);
//
//   // Use your importPublicKey helper to get a SimplePublicKey
//   final publicKey = importPublicKey(keyPairMap['publicKey']!);
//
//   // Reconstruct the full key pair
//   return SimpleKeyPairData(
//     privateKeyBytes,
//     publicKey: publicKey,
//     type: KeyPairType.x25519,
//   );
// }
//
// /// Computes the shared secret given my key pair and the friend's public key string.
// Future<SecretKey> computeSharedSecret({
//   required KeyPair myKeyPair,
//   required String friendPublicKeyStr,
// }) async {
//   final friendPublicKey = importPublicKey(friendPublicKeyStr);
//   return await algorithm.sharedSecretKey(
//     keyPair: myKeyPair,
//     remotePublicKey: friendPublicKey,
//   );
// }
//
// /// Derives a 256-bit AES key (for AES-GCM) using HKDF based on the shared secret.
// Future<SecretKey> deriveAesKey(SecretKey sharedSecret) async {
//   final salt = utf8.encode('flutter chat salt v1');
//   final hkdf = Hkdf(
//     hmac: Hmac.sha256(),
//     outputLength: 32, // 32 bytes = 256 bits
//   );
//   return await hkdf.deriveKey(
//     secretKey: sharedSecret,
//     nonce: salt,
//     info: utf8.encode('flutter chat encryption'),
//   );
// }
//
// /// This top-level function runs inside the background isolate.
// /// It must be at the global scope, not inside any class.
// Future<SecretKey> deriveAesKeyInBackground(KeyDerivationParams params) async {
//   // Reconstruct your key-pair from the map
//   final keyPairData = await mapToKeyPair(params.myKeyPairMap);
//
//   // Perform the expensive Diffie–Hellman operation
//   final sharedSecret = await computeSharedSecret(
//     myKeyPair: keyPairData,
//     friendPublicKeyStr: params.friendPublicKey,
//   );
//
//   // Derive and return the AES key
//   return deriveAesKey(sharedSecret);
// }
