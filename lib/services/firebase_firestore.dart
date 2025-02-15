import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {

  final FirebaseFirestore _firestore;

  FireStoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addDocument(
      {required String collectionPath, required Map<String, dynamic> data}) async {
    await _firestore.collection(collectionPath).add(data);
  }

  Future<void> setDocument(
      {required String collectionPath,
        required String docId,
        required Map<String, dynamic> data}) async {
    await _firestore.collection(collectionPath).doc(docId).set(data);
  }

  Future<void> updateDocument(
      {required String collectionPath,
        required String docId,
        required Map<String, dynamic> data}) async {
    await _firestore.collection(collectionPath).doc(docId).update(data);
  }

  Future<void> deleteDocument({required String collectionPath, required String docId}) async {
    await _firestore.collection(collectionPath).doc(docId).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
      {required String collectionPath, required String docId}) async {
    return await _firestore.collection(collectionPath).doc(docId).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCollectionStream(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }
}