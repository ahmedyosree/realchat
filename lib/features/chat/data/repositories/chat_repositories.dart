import 'dart:async';

import 'package:cryptography/cryptography.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/chat_model.dart';
import '../../../../core/models/message.dart';
import '../../../../services/encryption_service.dart';
import '../../../../services/firebase_firestore_chat_service.dart';
import '../../../../services/firebase_firestore_user_service.dart';
import '../../../../services/local_sql_service.dart';
import '../../../../services/local_storage_service.dart';
class ChatRepository {
  final FireStoreChatService _firestoreChatService;
  final LocalStorageService _localStorageService;
  final FireStoreUserService _fireStoreUserService; // Added user service
  final encryptionService = EncryptionService();
final localSqlService = LocalSqlService();
  StreamSubscription<List<ChatModel>>? _firestoreChatsSubscription;

  ChatRepository({
    required FireStoreChatService firestoreChatService,
    required LocalStorageService localStorageService,
    required FireStoreUserService fireStoreUserService,
  })  : _firestoreChatService = firestoreChatService,
        _localStorageService = localStorageService,
  _fireStoreUserService = fireStoreUserService;


  Future<SecretKey> computedAesKey({
    required String friendPublicKeyStr,
    required String chatId,
  }) async {
    // 1. Wait for the key-pair map to come back from storage
    final Map<String, String>? mapKeyPair =
    await _localStorageService.getKeyPair();
    if (mapKeyPair == null) {
      throw StateError('No X25519 key pair found in local storage.');
    }

    // 2. Deserialize it into a SimpleKeyPairData (which implements KeyPair)
    final SimpleKeyPairData keyPairData =
    await encryptionService.mapToKeyPair(mapKeyPair);

    // 3. Compute the shared secret, waiting for that too
    final SecretKey sharedSecret = await encryptionService.computeSharedSecret(
      myKeyPair: keyPairData,
      friendPublicKeyStr: friendPublicKeyStr,
    );
   final aesKey = await encryptionService.deriveAesKey(sharedSecret);
// Convert and persist
    final aesKeyString = await encryptionService.secretKeyToString(aesKey);
    await _localStorageService.saveSharedSecret(chatId , aesKeyString);

    return aesKey;
  }

  Future<Map<String, dynamic>> encryptMessage(
      SecretKey aesKey,
      String plainText,
      ) async {
    final secretBox = await encryptionService.encryptMessage(aesKey, plainText);
    return encryptionService.secretBoxToMap(secretBox);
  }


  Future<void> startNewChat(String? firstMessage, String? friendId , String? friendKey) async {
    // Validate required parameters.
    if (firstMessage == null || friendId == null || friendKey == null) {
      throw Exception(
          "Missing required parameters: firstMessage , friendKey and friendId must be provided.");
    }

    // Generate a unique chat id.
    final String chatId = const Uuid().v4();
    final String currentUserId = _localStorageService.getUser()!.id;

    // Create chat metadata without messages.
    final ChatModel newChat = ChatModel(
      id: chatId,
      people: [currentUserId, friendId],
      chatStartIn: DateTime.now().toUtc(),
    );

    // Create the chat document in Firestore.
    await _firestoreChatService.createChat(newChat);

    // Create the starter message.
    final Message initialMessage = Message(
      id: '', // Firestore will generate a document id for the message.
      senderId: currentUserId,
      encryptedData: await encryptMessage(await computedAesKey(friendPublicKeyStr: friendKey , chatId: chatId), firstMessage),
      timestamp: DateTime.now(),
    );

    // Add the starter message to the 'messages' subcollection.
    await _firestoreChatService.addMessage(chatId, initialMessage);

    // Update both users' chat lists by adding the new chat id.
    await _fireStoreUserService.addChatToUser(currentUserId, chatId);
    await _fireStoreUserService.addChatToUser(friendId, chatId);
  }

  /// Starts syncing new chats from Firestore to local SQLite storage in real time.
    Future<void> startChatSync() async {
    // Get the latest chat's start time from the local database
    final DateTime? latestChatTime = await localSqlService.getMostRecentChatTime();
    final String currentUserId = _localStorageService.getUser()!.id;

    // If no chats exist locally, use a very old date
    final Timestamp since = Timestamp.fromDate(latestChatTime ?? DateTime.fromMillisecondsSinceEpoch(0).toUtc());

print(since);
print(currentUserId);
    _firestoreChatsSubscription = _firestoreChatService.streamUserChats(currentUserId, since).listen((chats)  {
      print("dgdfgdhdjgdhjghdjfgjfghjfjjfjfjfjfgjfjfjgdhjghjhgjhgj");
      for (final chat in chats) {
        print("chatttttttt");
         localSqlService.addChats(chat);
      }
    });
  }

  /// Stop syncing chats from Firestore to local SQLite database
  Future<void> stopChatSync() async {
    await _firestoreChatsSubscription?.cancel();
    _firestoreChatsSubscription = null;
  }

  /// Get all chats from the local database as a stream to use in the UI via BLoC
  Stream<List<ChatModel>> getChatsForUI() {
    return localSqlService.getChatsStream();
  }
}

