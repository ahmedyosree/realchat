import 'dart:convert';

import 'package:drift/drift.dart';
import '../../../core/models/chat.dart';

// Conditional import for platform-specific database opening
import 'local_chats_service_mobile.dart'
if (dart.library.html) 'local_chats_service_web.dart';

part 'local_chats_service.g.dart';

class ChatTable extends Table {
  TextColumn get id => text()();
  TextColumn get people => text()(); // Store as JSON string
  DateTimeColumn get chatStartedAt => dateTime()();

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

  Future<void> addChat(Chat chat) async {
    await _db.into(_db.chatTable).insertOnConflictUpdate(
      ChatTableCompanion(
        id: Value(chat.id),
        people: Value(jsonEncode(chat.people)),
        chatStartedAt: Value(chat.chatStartIn),
      ),
    );
  }

  Future<DateTime?> getMostRecentChatTime() async {
    final result = await (_db.selectOnly(_db.chatTable)
      ..addColumns([_db.chatTable.chatStartedAt])
      ..orderBy([
        OrderingTerm(expression: _db.chatTable.chatStartedAt, mode: OrderingMode.desc),
      ])
      ..limit(1)).getSingleOrNull();
    return result?.read(_db.chatTable.chatStartedAt);
  }

  Stream<List<Chat>> getChatsStream() {
    return _db.select(_db.chatTable).watch().map((rows) {
      return rows.map((row) {
        return Chat(
          id: row.id,
          people: (jsonDecode(row.people) as List<dynamic>).cast<String>(),
          chatStartIn: row.chatStartedAt,
        );
      }).toList();
    });
  }
}