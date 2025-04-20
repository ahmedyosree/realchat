import 'package:uuid/uuid.dart';

import '../../../../core/models/chat_model.dart';
import '../../../../core/models/message.dart';
import '../../../../services/firebase_firestore_chat_service.dart';
import '../../../../services/firebase_firestore_user_service.dart';
import '../../../../services/local_storage_service.dart';
class ChatRepository {
  final FireStoreChatService _firestoreChatService;
  final LocalStorageService _localStorageService;
  final FireStoreUserService _fireStoreUserService; // Added user service


  ChatRepository({
    required FireStoreChatService firestoreChatService,
    required LocalStorageService localStorageService,
    required FireStoreUserService fireStoreUserService,
  })  : _firestoreChatService = firestoreChatService,
        _localStorageService = localStorageService,
  _fireStoreUserService = fireStoreUserService;

  Future<void> createChat(String? firstMessage, String? friendId) async {
    // Validate required parameters.
    if (firstMessage == null || friendId == null) {
      throw Exception(
          "Missing required parameters: firstMessage and friendId must be provided.");
    }

    // Generate a unique chat id.
    final String chatId = const Uuid().v4();
    final String currentUserId = _localStorageService.getUser()!.id;

    // Create chat metadata without messages.
    final ChatModel newChat = ChatModel(
      id: chatId,
      people: [currentUserId, friendId],
      chatStartIn: DateTime.now(),
    );

    // Create the chat document in Firestore.
    await _firestoreChatService.createChat(newChat);

    // Create the starter message.
    final Message initialMessage = Message(
      id: '', // Firestore will generate a document id for the message.
      senderId: currentUserId,
      text: firstMessage,
      timestamp: DateTime.now(),
    );

    // Add the starter message to the 'messages' subcollection.
    await _firestoreChatService.addMessage(chatId, initialMessage);

    // Update both users' chat lists by adding the new chat id.
    await _fireStoreUserService.addChatToUser(currentUserId, chatId);
    await _fireStoreUserService.addChatToUser(friendId, chatId);
  }
}
