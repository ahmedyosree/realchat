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

/// Optionally, you can add methods for retrieving chats or messages...
}
