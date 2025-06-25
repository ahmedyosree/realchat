import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../core/models/chat.dart';
import '../core/models/message.dart';
class FireStoreChatService {
  final FirebaseFirestore _firestore;
  final String collectionPath = 'chats';

  FireStoreChatService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Creates a new chat document with the chat metadata.
  Future<void> createChat(Chat chat) async {
    await _firestore.collection(collectionPath).doc(chat.id).set(chat.toMap());
  }

  /// Adds a message to the 'messages' subcollection within the chat document.
  Future<void> addMessage(String chatId, Message message) async {
    final chatDoc = _firestore.collection(collectionPath).doc(chatId);
    // The document ID for the message is auto-generated.
    await chatDoc.collection('messages').add(message.toMap());
  }


  /// Stream all chats that involve [userId] and whose start is *after* [since].
  Stream<List<Chat>> streamUserChats(String userId, Timestamp since) {
    return _firestore
        .collection(collectionPath)
        .where('people', arrayContains: userId)
        .where('chatStartIn', isGreaterThan: since)
        .snapshots()
        .map((snap) => snap.docChanges
          .where((change) => change.type == DocumentChangeType.added)
          .map((docChange) => Chat.fromMap(docChange.doc.data()!))
          .toList());
  }




  /// Stream all messages in chat [chatId] whose timestamp is *after* [since].
  Stream<List<Message>> streamMessages(String chatId, DateTime since) {
    return _firestore
        .collection(collectionPath)
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .where('sentAt', isGreaterThan: since)
        .snapshots()
        .map((snap) => snap.docChanges
        .where((change) => change.type == DocumentChangeType.added)
        .map((docChange) => Message.fromMap(docChange.doc.data()!, docChange.doc.id)).toList());
  }
}



