import 'dart:async';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
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
  final FireStoreUserService _fireStoreUserService; // Added user service
  final encryptionService = EncryptionService();
  final localChatsService = LocalChatsService();
  final localMessagesService = LocalMessagesService();
  StreamSubscription<List<Chat>>? _firestoreChatsSubscription;
// <chat-id, <SharedSecretKey, PublicKeyFriendTimeMadeAt>>
  final Map<String, (SecretKey, DateTime)> _sharedSecretKeys = {};
  final List<StreamSubscription> _publicKeySubs = [];
  bool _isLoggedIn = true;

  ChatRepository({
    required FireStoreChatService firestoreChatService,
    required LocalStorageService localStorageService,
    required FireStoreUserService fireStoreUserService,
  })  : _firestoreChatService = firestoreChatService,
        _localStorageService = localStorageService,
        _fireStoreUserService = fireStoreUserService;



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
      encryptedData: await encryptionService.encryptMessageToMap(
          await encryptionService.computedAesKey(
              friendPublicKeyStr: friendKey,
              chatId: chatId,
              myMapKeyPair: myMapKeyPair),
          firstMessage),
      sentAt: DateTime.now().toUtc(),
      chatId: chatId,
    );

    // Add the starter message to the 'messages' subCollection.
    await _firestoreChatService.addMessage(chatId, initialMessage);
  }


  Future<void> addNewMessage(
      String? text, String? chatId) async {
    // Validate required parameters.
    if (text == null || chatId == null ) {
      throw Exception(
          "Missing required parameters: text and chatId must be provided.");
    }


    final String currentUserId = myUserId;


    // Create the starter message.
    final Message message = Message(
      id: '', // Firestore will generate a document id for the message.
      senderId: currentUserId,
      encryptedData: await encryptionService.encryptMessageToMap(
          _sharedSecretKeys[chatId]!.$1,
          text),
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
        latestChatTime ?? DateTime.fromMillisecondsSinceEpoch(0).toUtc());

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
    // User Public Key Info
    final String currentUserId = myUserId;
    final myInfo =
        await _fireStoreUserService.getPublicKeyInfoOnce(currentUserId);
    final myKeyTime = myInfo['Date'] as DateTime;

    // take stream of list<chat> and return stream of chat that every chat will not be repeated.
    final Stream<Chat> chatsStream = localChatsService
        .getChatsStream()
        .expand((chats) => chats)
        .distinctUnique();

    final Stream<Message> encryptedMessagesStream = chatsStream
        .flatMap((chat) async* {
          // for every chat , listen to a stream that emit public key for the other person in that chat
          // and make shared secret key and save it in the map to used for decrypt the messages.
          if (!_sharedSecretKeys.containsKey(chat.id)) {
            final Map<String, String>? myMapKeyPair =
                await _localStorageService.getKeyPair();
            if (myMapKeyPair == null) {
              throw StateError('No X25519 key pair found in local storage.');
            }
            _publicKeySubs.add(_fireStoreUserService
                .streamPublicKeyInfo(chat.people.firstWhere(
                    (id) => id != myUserId))
                .listen((publicKeyFriendInfo) => encryptionService
                        .computedAesKey(
                            friendPublicKeyStr:
                                publicKeyFriendInfo['publicKey'],
                            chatId: chat.id,
                            myMapKeyPair: myMapKeyPair)
                        .then((secretKey) {
                      _sharedSecretKeys[chat.id] =
                          (secretKey, publicKeyFriendInfo['Date'] as DateTime);
                    })));
          }

          // 1) await the most‐recent‐time future
          final lastSeen =
              await localMessagesService.getMostRecentMessageTime(chat.id)
                  // decide on a fallback if it was null
                  ??
                  DateTime.fromMillisecondsSinceEpoch(0).toUtc();
          //streamMessages return Stream<List<Message>>
          // 2) yield all messages from your Firestore stream.
          yield* _firestoreChatService.streamMessages(chat.id, lastSeen);
        })
        .expand((messages) => messages)
        .distinctUnique();


    await for (final message in encryptedMessagesStream) {
      if (!_isLoggedIn) {
        // this break will cancel the underlying StreamSubscription
        break;
      }
      if (message.sentAt.isAfter(_sharedSecretKeys[message.chatId]?.$2 ??
              DateTime.fromMillisecondsSinceEpoch(0)) &&
          message.sentAt.isAfter(myKeyTime)) {
        SecretBox secretBox =
            encryptionService.secretBoxFromMap(message.encryptedData);
        String textMessage = await encryptionService.decryptMessage(
            _sharedSecretKeys[message.chatId]!.$1, secretBox);
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
              '“To help keep your chat private, your conversation is now using a new secure key. '
              'The last message couldn’t be delivered, ask your friend to resend anything important!”',
          sentAt: message.sentAt.subtract(const Duration(milliseconds: 500)),
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
        // For each emitted List<LocalMessage>, we need to asynchronously
        // fetch the matching Chat and build ChatPreview objects.
        .asyncMap((messageList) async {
      // Kick off all the getChatById futures in parallel:
      final previewFutures = messageList.map((msg) async {
        final chat = await localChatsService.getChatById(msg.chatId);
        final docSnapshot = await _fireStoreUserService.getDocument(
            docId: chat!.people
                .firstWhere((id) => id != myUserId));
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


  Stream<List<LocalMessage>> watchMessagesForChat(String chatId){
    return localMessagesService.watchMessagesForChat(chatId);
  }



}
