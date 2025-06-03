import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../core/models/chat_model.dart';
part 'local_sql_service.g.dart';

// Drift table for chats
class Chats extends Table {
  TextColumn get id => text()();
  TextColumn get people => text()(); // Stored as a JSON-encoded string
  DateTimeColumn get chatStartIn => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Drift database definition
@DriftDatabase(tables: [Chats])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // A function to clear all chats (useful for debugging or reset purposes)
  Future<void> clearChats() async {
    await delete(chats).go();
  }
}

// Singleton service
class LocalSqlService {
  static final LocalSqlService _instance = LocalSqlService._internal();
  final LocalDatabase _database;

  factory LocalSqlService() {
    return _instance;
  }

  LocalSqlService._internal() : _database = LocalDatabase();

  Future<void> addChats(ChatModel chat) async {
        await _database.into(_database.chats).insertOnConflictUpdate(
          ChatsCompanion(
            id: Value(chat.id),
            people: Value(jsonEncode(chat.people)),
            chatStartIn: Value(chat.chatStartIn),
          ),
        );
  }

  Future<DateTime?> getMostRecentChatTime() async { // Renamed for clarity
    final result = await (_database.selectOnly(_database.chats)
      ..addColumns([_database.chats.chatStartIn])
      ..orderBy([
        // Fetch in descending order to get the latest chat first
        OrderingTerm(expression: _database.chats.chatStartIn, mode: OrderingMode.desc),
      ])
      ..limit(1))
        .getSingleOrNull();
    return result?.read(_database.chats.chatStartIn);
  }

  // Function to get chats from the local database as a stream
  Stream<List<ChatModel>> getChatsStream() {
    return _database.select(_database.chats).watch().map((rows) {
      return rows.map((row) {
        return ChatModel(
          id: row.id,
          people:  (jsonDecode(row.people) as List<dynamic>).cast<String>(),
          chatStartIn: row.chatStartIn,
        );
      }).toList();
    });
  }
}

// Function to open the database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}