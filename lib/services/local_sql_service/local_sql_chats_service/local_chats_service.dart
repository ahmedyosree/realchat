import 'dart:convert';

import 'package:drift/drift.dart';
import '../../../core/models/chat.dart';

// Conditional import for platform-specific database opening
import 'local_chats_service_mobile.dart'
if (dart.library.html) 'local_chats_service_web.dart';

part 'local_chats_service.g.dart';

class ChatTable extends Table {
  TextColumn get id => text()();
  TextColumn get people => text()();
  DateTimeColumn get chatStartedAt => dateTime()();
  TextColumn get startTheChatId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [ChatTable])
class LocalChatsDatabase extends _$LocalChatsDatabase {
  LocalChatsDatabase() : super(openChatsDbConnection());

  @override
  int get schemaVersion => 1;

  Future<void> clearChats() async {
    await delete(chatTable).go();
  }
}

class LocalChatsService {
  static final LocalChatsService _instance = LocalChatsService._internal();
  final LocalChatsDatabase _db;

  factory LocalChatsService() => _instance;

  LocalChatsService._internal() : _db = LocalChatsDatabase();
  // Inserts or updates a chat
  Future<void> addChat(Chat chat) async {
    await _db.into(_db.chatTable).insertOnConflictUpdate(
      ChatTableCompanion(
        id: Value(chat.id),
        people: Value(jsonEncode(chat.people)),
        chatStartedAt: Value(chat.chatStartIn),
          startTheChatId : Value(chat.startTheChatId),
      ),
    );
  }
  // Gets the DateTime of the most recent chat
  Future<DateTime?> getMostRecentChatTime() async {
    final result = await (_db.selectOnly(_db.chatTable)
      ..addColumns([_db.chatTable.chatStartedAt])
      ..orderBy([
        OrderingTerm(expression: _db.chatTable.chatStartedAt, mode: OrderingMode.desc),
      ])
      ..limit(1)).getSingleOrNull();
    return result?.read(_db.chatTable.chatStartedAt);
  }

  // Streams list of chats as Chat objects
  Stream<List<Chat>> getChatsStream() {
    return _db.select(_db.chatTable).watch().map((rows) {
      return rows.map((row) {
        return Chat(
          id: row.id,
          people: (jsonDecode(row.people) as List<dynamic>).cast<String>(),
          chatStartIn: row.chatStartedAt,
            startTheChatId : row.startTheChatId,

        );
      }).toList();
    });
  }

  // Fetches a chat by its ID
  Future<Chat?> getChatById(String id) async {
    final row = await (_db.select(_db.chatTable)
      ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return Chat(
      id: row.id,
      people: (jsonDecode(row.people) as List<dynamic>).cast<String>(),
      chatStartIn: row.chatStartedAt,
      startTheChatId : row.startTheChatId,

    );
  }

}