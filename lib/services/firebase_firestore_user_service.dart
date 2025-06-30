import 'package:cloud_firestore/cloud_firestore.dart';


class FireStoreUserService {

  final FirebaseFirestore _firestore;
  final String collectionPath = 'users';

  FireStoreUserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;


  Future<void> setDocument(
      {
        required String docId,
        required Map<String, dynamic> data}) async {
    await _firestore.collection(collectionPath).doc(docId).set(data);
  }

  /// Updates a specific field in a document.
  ///
  /// This method allows you to update a single field within a document
  /// without overwriting the entire document.
  ///
  /// Args:
  ///   docId: The ID of the document to update.
  ///   field: The name of the field to update.
  ///   value: The new value for the field.
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
      // Handle any errors that occur during the update.
      print('Error updating document field: $e');
      rethrow; // Re-throw the error to be handled by the caller.
    }
  }

  /// Checks if a given nickname exists in the 'users' collection.
  Future<bool> doesNicknameExist(String nickname) async {
    final querySnapshot = await _firestore
        .collection(collectionPath)
        .where('nickname', isEqualTo: nickname)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
      { required String docId}) async {
    return await _firestore.collection(collectionPath).doc(docId).get();
  }

  /// Searches for users by nickname and returns raw Firestore query snapshot
  Future<QuerySnapshot<Map<String, dynamic>>> searchUsersByNickname({ required String nickname , required int limit}) async {

    return await _firestore
        .collection(collectionPath)
        .orderBy('nickname')
        .startAt([nickname])
        .endAt(['$nickname\uf8ff']).limit(limit)
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
      if (pkInfo == null
          || pkInfo['publicKey'] == null
          || pkInfo['Date'] == null) {
        throw StateError('publicKeyInfo missing or malformed for user $userId');
      }

      return {
        'publicKey': pkInfo['publicKey'] as String,
        // Firestore stores timestamps as Timestamp objects
        'Date': DateTime.parse(pkInfo['Date'] as String),
      };
    });
  }
  /// Returns this user’s `{ 'publicKey': String, 'Date': DateTime }`
  /// from their `publicKeyInfo` field in Firestore, as a one-time fetch.
  /// Throws [StateError] if the user or their key info is missing or malformed.
  Future<Map<String, dynamic>> getPublicKeyInfoOnce(String userId) async {
    final doc = await _firestore
        .collection(collectionPath)
        .doc(userId)
        .get();
    final data = doc.data();
    if (data == null) {
      throw StateError('User $userId does not exist');
    }

    final pkInfo = data['publicKeyInfo'] as Map<String, dynamic>?;
    if (pkInfo == null || pkInfo['publicKey'] == null || pkInfo['Date'] == null) {
      throw StateError('publicKeyInfo missing or malformed for user $userId');
    }

    return {
      'publicKey': pkInfo['publicKey'] as String,
      'Date': DateTime.parse(pkInfo['Date'] as String),
    };
  }

}