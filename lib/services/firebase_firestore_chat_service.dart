import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/models/chat_model.dart';
import '../core/models/message.dart';
class FireStoreChatService {
  final FirebaseFirestore _firestore;
  final String collectionPath = 'chats';

  FireStoreChatService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Creates a new chat document with the chat metadata.
  Future<void> createChat(ChatModel chat) async {
    await _firestore.collection(collectionPath).doc(chat.id).set(chat.toMap());
  }

  /// Adds a message to the 'messages' subcollection within the chat document.
  Future<void> addMessage(String chatId, Message message) async {
    final chatDoc = _firestore.collection(collectionPath).doc(chatId);
    // The document ID for the message is auto-generated.
    await chatDoc.collection('messages').add(message.toMap());
  }


  /// Stream all chats that involve [userId] and whose start is *after* [since].
  Stream<List<ChatModel>> streamUserChats(String userId, Timestamp  since) {

      return _firestore
          .collection(collectionPath)
          .where('people', arrayContains: userId)
          .where('chatStartIn', isGreaterThan: since)
          .snapshots()
          .map((snap) => snap.docs.map((doc) => ChatModel.fromMap(doc.data())).toList());
    }




  /// Stream all messages in chat [chatId] whose timestamp is *after* [since].
  Stream<List<Message>> streamMessages(
      String chatId, DateTime since) {
    final tsSince = Timestamp.fromDate(since);
    return _firestore
        .collection(collectionPath)
        .doc(chatId)
        .collection('messages')
        .where('timestamp', isGreaterThan: tsSince)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      return Message.fromMap({
        ...doc.data(),
        'timestamp': doc.data()['timestamp'],
      }, doc.id);
    }).toList());
  }
}
