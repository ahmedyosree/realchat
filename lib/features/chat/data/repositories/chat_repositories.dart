import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:sodium/sodium.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/Local_Message.dart';
import '../../../../core/models/chat.dart';
import '../../../../core/models/chat_preview.dart';
import '../../../../core/models/message.dart';
import '../../../../core/models/user.dart';
import '../../../../services/encryption_service.dart';
import '../../../../services/firebase_firestore_chat_service.dart';
import '../../../../services/firebase_firestore_user_service.dart';
import '../../../../services/local_sql_service/local_sql_chats_service/local_chats_service.dart';
import '../../../../services/local_sql_service/local_sql_messages_service/local_messages_service.dart';
import '../../../../services/local_storage_service.dart';

class ChatRepository {
  final FireStoreChatService _firestoreChatService;
  final LocalStorageService _localStorageService;
  final FireStoreUserService _fireStoreUserService;
  final EncryptionService _encryptionService;
  final localChatsService = LocalChatsService();
  final localMessagesService = LocalMessagesService();
  StreamSubscription<List<Chat>>? _firestoreChatsSubscription;
// <chat-id, <SharedSecretKey, PublicKeyFriendTimeMadeAt>>
  final Map<String, (SecureKey, DateTime)> _sharedSecretKeysEncrypt = {};
  final Map<String, (SecureKey, DateTime)> _sharedSecretKeysDecrypt = {};

  final List<StreamSubscription> _publicKeySubs = [];
  bool _isLoggedIn = true;

  ChatRepository({
    required FireStoreChatService firestoreChatService,
    required LocalStorageService localStorageService,
    required FireStoreUserService fireStoreUserService,
    required EncryptionService encryptionService,
  })  : _firestoreChatService = firestoreChatService,
        _localStorageService = localStorageService,
        _fireStoreUserService = fireStoreUserService,
        _encryptionService = encryptionService;

  String get myUserId => _localStorageService.getUser()!.id;

  Future<void> startNewChat(
      String? firstMessage, String? friendId, String? friendKey) async {
    // Validate required parameters.
    if (firstMessage == null || friendId == null || friendKey == null) {
      throw Exception(
          "Missing required parameters: firstMessage , friendKey and friendId must be provided.");
    }

    // Generate a unique chat id.
    final String chatId = const Uuid().v4();
    final String currentUserId = myUserId;

    // Create chat metadata without messages.
    final Chat newChat = Chat(
      id: chatId,
      people: [currentUserId, friendId],
      chatStartIn: DateTime.now().toUtc(),
      startTheChatId: currentUserId,
    );

    // Create the chat document in Firestore.
    await _firestoreChatService.createChat(newChat);
//  Wait for the key-pair map to come back from storage
    final Map<String, String>? myMapKeyPair =
        await _localStorageService.getKeyPair();
    if (myMapKeyPair == null) {
      throw StateError('No X25519 key pair found in local storage.');
    }

    // Create the starter message.
    final Message initialMessage = Message(
      id: '', // Firestore will generate a document id for the message.
      senderId: currentUserId,
      encryptedData: _encryptionService.encryptWithAead(
          key: await _encryptionService.deriveAeadKey(_encryptionService
              .computeSessionKeys(
                myMapKeyPair: myMapKeyPair,
                friendPublicKey: friendKey,
                isClient: true,
              )
              .tx),
          plaintext: firstMessage),
      sentAt: DateTime.now().toUtc(),
      chatId: chatId,
    );

    // Add the starter message to the 'messages' subCollection.
    await _firestoreChatService.addMessage(chatId, initialMessage);
  }

  Future<void> addNewMessage(String? text, String? chatId) async {
    // Validate required parameters.
    if (text == null || chatId == null) {
      throw Exception(
          "Missing required parameters: text and chatId must be provided.");
    }

    final String currentUserId = myUserId;

    // Create the starter message.
    final Message message = Message(
      id: '', // Firestore will generate a document id for the message.
      senderId: currentUserId,
      encryptedData: _encryptionService.encryptWithAead(
          key: _sharedSecretKeysEncrypt[chatId]!.$1, plaintext: text),

      sentAt: DateTime.now().toUtc(),
      chatId: chatId,
    );

    // Add the starter message to the 'messages' subCollection.
    await _firestoreChatService.addMessage(chatId, message);
  }

  /// Starts syncing new chats from Firestore to local SQLite storage in real time.
  Future<void> startChatSync() async {
    // Get the latest chat's start time from the local database
    final DateTime? latestChatTime =
        await localChatsService.getMostRecentChatTime();
    final String currentUserId = myUserId;

    // If no chats exist locally, use a very old date
    final Timestamp since = Timestamp.fromDate(
        latestChatTime ?? DateTime.fromMillisecondsSinceEpoch(0));

    _firestoreChatsSubscription = _firestoreChatService
        .streamUserChats(currentUserId, since)
        .listen((chats) {
      for (final chat in chats) {
        localChatsService.addChat(chat);
      }
    });
  }

  /// Start listening to ALL chats, fetching each friend's public key,
  /// deriving a shared secret per-chat, then streaming & decrypting new messages.
  void startMessageSync() async {
    final String currentUserId = myUserId;
    final myInfo =
        await _fireStoreUserService.getPublicKeyInfoOnce(currentUserId);
    final myKeyTime = myInfo['Date'] as DateTime;

    // take stream of list<chat> and return stream of chat that every chat will not be repeated.
    final Stream<Chat> chatsStream = localChatsService
        .getChatsStream()
        .expand((chats) => chats)
        .distinctUnique();

    final encryptedMessagesStream = chatsStream
        .flatMap((chat) {
          final friendId = chat.people.firstWhere((id) => id != myUserId);

          // Every time Firestore pushes a new publicKeyInfo, switch to a fresh message stream:
          return _fireStoreUserService
              .streamPublicKeyInfo(friendId)
              .switchMap((publicKeyInfo) async* {
            // 1) Compute & store your shared key
            final myKeyPair = await _localStorageService.getKeyPair();
            if (myKeyPair == null) {
              throw StateError('No X25519 key pair in local storage.');
            }

            final sessionKeys = _encryptionService.computeSessionKeys(
                myMapKeyPair: myKeyPair,
                friendPublicKey: publicKeyInfo['publicKey'],
                isClient: chat.startTheChatId == currentUserId);
            final rx = await _encryptionService.deriveAeadKey(sessionKeys.rx);
            final tx = await _encryptionService.deriveAeadKey(sessionKeys.tx);

            _sharedSecretKeysDecrypt[chat.id] = (
              rx,
              publicKeyInfo['Date'] as DateTime,
            );
            _sharedSecretKeysEncrypt[chat.id] = (
              tx,
              publicKeyInfo['Date'] as DateTime,
            );

            final t =
                await localMessagesService.getMostRecentMessageTime(chat.id) ??
                    DateTime.fromMillisecondsSinceEpoch(0);
            // 2) Figure out how far you’ve read already

            final lastSeenTs = Timestamp.fromDate(t.toUtc());

            // 3) Yield only the “new” messages under this key
            yield* _firestoreChatService.streamMessages(chat.id, lastSeenTs);
          });
        })
        .expand((messages) => messages)
        .distinctUnique();

    await for (final message in encryptedMessagesStream) {
      if (!_isLoggedIn) {
        // this break will cancel the underlying StreamSubscription
        break;
      }

      if (message.sentAt
              .isAfter(_sharedSecretKeysDecrypt[message.chatId]!.$2) &&
          message.sentAt.isAfter(myKeyTime)) {
        String textMessage = _encryptionService.decryptWithAead(
          key: message.senderId == myUserId
              ? _sharedSecretKeysEncrypt[message.chatId]!.$1
              : _sharedSecretKeysDecrypt[message.chatId]!.$1,
          combinedBase64: message.encryptedData,
        );
        LocalMessage localMessage = LocalMessage(
          id: message.id,
          senderId: message.senderId,
          text: textMessage,
          sentAt: message.sentAt,
          chatId: message.chatId,
        );
        localMessagesService.saveMessage(localMessage);
      } else {
        LocalMessage localMessage = LocalMessage(
          id: message.id,
          senderId: "System",
          text:
              "This message can't be decrypted. The encryption keys have changed.",
          sentAt: message.sentAt,
          chatId: message.chatId,
        );
        localMessagesService.saveMessage(localMessage);
      }
    }
  }

  /// Don’t forget to cancel when you no longer need it!
  Future<void> stopMessageSync() async {
    for (final sub in _publicKeySubs) {
      await sub.cancel();
    }
    _publicKeySubs.clear();
    _isLoggedIn = false;
  }

  /// Stop syncing chats from Firestore to local SQLite database
  Future<void> stopChatSync() async {
    await _firestoreChatsSubscription?.cancel();
    _firestoreChatsSubscription = null;
  }

  /// Get all chats from the local database as a stream to use in the UI via BLoC
  Stream<List<ChatPreview>> watchChatPreviews() {
    return localMessagesService
        .watchLatestMessagesForAllChats()
        .asyncMap((messageList) async {
      final previewFutures = messageList.map((msg) async {
        final chat = await localChatsService.getChatById(msg.chatId);
        final docSnapshot = await _fireStoreUserService.getDocument(
            docId: chat!.people.firstWhere((id) => id != myUserId));
        final user = UserModel.fromMap(docSnapshot.data()!);

        return ChatPreview(
          chatId: msg.chatId,
          senderId: msg.senderId,
          text: msg.text,
          sentAt: msg.sentAt,
          name: user.name,
          nickname: user.nickname,
        );
      });

      // Wait until all ChatPreview futures complete, then return the list:
      return Future.wait(previewFutures);
    });
  }

  Stream<List<LocalMessage>> watchMessagesForChat(String chatId) {
    return localMessagesService.watchMessagesForChat(chatId);
  }
}
