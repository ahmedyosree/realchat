import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../core/models/chat_model.dart';
import '../core/models/message.dart';

class SqlStorageService {
  static final SqlStorageService _instance = SqlStorageService._internal();
  factory SqlStorageService() => _instance;
  SqlStorageService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create chats table.
        await db.execute('''
          CREATE TABLE chats (
            id TEXT PRIMARY KEY,
            people TEXT,
            chatStartIn TEXT
          )
        ''');

        // Create messages table.
        await db.execute('''
          CREATE TABLE messages (
            id TEXT PRIMARY KEY,
            chatId TEXT,
            senderId TEXT,
            text TEXT,
            timestamp TEXT,
            FOREIGN KEY(chatId) REFERENCES chats(id)
          )
        ''');
      },
    );
  }

  Future<void> insertChat(ChatModel chat) async {
    final dbClient = await database;
    await dbClient.insert(
      'chats',
      {
        'id': chat.id,
        // Convert list to JSON string.
        'people': json.encode(chat.people),
        'chatStartIn': chat.chatStartIn.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMessage(String chatId, Message message) async {
    final dbClient = await database;
    await dbClient.insert(
      'messages',
      {
        'id': message.id,
        'chatId': chatId,
        'senderId': message.senderId,
        'text': message.text,
        'timestamp': message.timestamp.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Example: retrieve messages for a chat
  Future<List<Message>> getMessages(String chatId) async {
    final dbClient = await database;
    final maps = await dbClient.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
      orderBy: 'timestamp ASC',
    );
    return List.generate(maps.length, (i) {
      return Message(
        id: maps[i]['id'] as String,
        senderId: maps[i]['senderId'] as String,
        text: maps[i]['text'] as String,
        timestamp: DateTime.parse(maps[i]['timestamp'] as String),
      );
    });
  }

// Add similar methods for update or delete operations if needed.
}
