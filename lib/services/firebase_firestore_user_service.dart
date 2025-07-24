import 'package:cloud_firestore/cloud_firestore.dart';

/// A service for performing CRUD operations on the Firestore 'users' collection.
class FireStoreUserService {
  final FirebaseFirestore _firestore;
  final String collectionPath = 'users';

  FireStoreUserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Creates or overwrites a user document.
  Future<void> setDocument(
      {required String docId, required Map<String, dynamic> data}) async {
    await _firestore.collection(collectionPath).doc(docId).set(data);
  }

  /// Updates one field in a user document.
  Future<void> updateDocumentField({
    required String docId,
    required String field,
    required dynamic value,
  }) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(docId)
          .update({field: value});
    } catch (e) {
      print('Error updating document field: $e');
      rethrow;
    }
  }

  /// Returns true if a nickname exists.
  Future<bool> doesNicknameExist(String nickname) async {
    final querySnapshot = await _firestore
        .collection(collectionPath)
        .where('nickname', isEqualTo: nickname)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  /// Fetches a user document snapshot.

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
      {required String docId}) async {
    return await _firestore.collection(collectionPath).doc(docId).get();
  }

  /// Searches users by nickname prefix up to [limit].
  Future<QuerySnapshot<Map<String, dynamic>>> searchUsersByNickname(
      {required String nickname, required int limit}) async {
    return await _firestore
        .collection(collectionPath)
        .orderBy('nickname')
        .startAt([nickname])
        .endAt(['$nickname\uf8ff'])
        .limit(limit)
        .get();
  }

  /// Returns a stream of this user’s `{ 'publicKey': String, 'Date': DateTime }`
  /// whenever their `publicKeyInfo` field changes in Firestore.
  Stream<Map<String, dynamic>> streamPublicKeyInfo(String userId) {
    return _firestore
        .collection(collectionPath)
        .doc(userId)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> snap) {
      final data = snap.data();
      if (data == null) {
        throw StateError('User $userId does not exist');
      }

      final pkInfo = data['publicKeyInfo'] as Map<String, dynamic>?;
      if (pkInfo == null ||
          pkInfo['publicKey'] == null ||
          pkInfo['Date'] == null) {
        throw StateError('publicKeyInfo missing or malformed for user $userId');
      }

      return {
        'publicKey': pkInfo['publicKey'] as String,
        // Firestore stores timestamps as Timestamp objects
        'Date': (pkInfo['Date'] as Timestamp).toDate().toLocal(),
      };
    });
  }

  /// Fetches publicKeyInfo once for a user.

  Future<Map<String, dynamic>> getPublicKeyInfoOnce(String userId) async {
    final doc = await _firestore.collection(collectionPath).doc(userId).get();
    final data = doc.data();
    if (data == null) {
      throw StateError('User $userId does not exist');
    }

    final pkInfo = data['publicKeyInfo'] as Map<String, dynamic>?;
    if (pkInfo == null ||
        pkInfo['publicKey'] == null ||
        pkInfo['Date'] == null) {
      throw StateError('publicKeyInfo missing or malformed for user $userId');
    }

    return {
      'publicKey': pkInfo['publicKey'] as String,
      'Date': (pkInfo['Date'] as Timestamp).toDate().toLocal(),
    };
  }
}
