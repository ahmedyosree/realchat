import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/models/LocalMessage.dart';
import '../local_sql_chats_service/local_chats_service.dart';

import 'local_messages_service_mobile.dart'
if (dart.library.html) 'local_messages_service_web.dart';

part 'local_messages_service.g.dart';

@DriftDatabase(tables: [MessageTable, ChatTable])
class LocalMessagesDatabase extends _$LocalMessagesDatabase {
  LocalMessagesDatabase() : super(openMessagesDbConnection());

  @override
  int get schemaVersion => 1;
}

@TableIndex(name: 'messages_chat_id_idx', columns: {#chatId})
class MessageTable extends Table {
  TextColumn get id       => text()();
  TextColumn get chatId   => text().references(ChatTable, #id)();
  TextColumn get senderId => text()();
  TextColumn get message  => text()(); // or use `body` or `text` as you like
  DateTimeColumn get sentAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalMessagesService {
  static final LocalMessagesService _instance = LocalMessagesService._internal();
  final LocalMessagesDatabase _db;

  factory LocalMessagesService() => _instance;
  LocalMessagesService._internal() : _db = LocalMessagesDatabase();

  Future<void> saveMessage(LocalMessage msg) {
    return _db.into(_db.messageTable).insertOnConflictUpdate(
      MessageTableCompanion(
        id: Value(msg.id),
        chatId: Value(msg.chatId),
        senderId: Value(msg.senderId),
        message: Value(msg.text),
        sentAt: Value(msg.sentAt),
      ),
    );
  }

  Future<DateTime?> getMostRecentMessageTime(String chatId) async {
    final query = _db.select(_db.messageTable)
      ..where((tbl) => tbl.chatId.equals(chatId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.sentAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();
    return row?.sentAt;
  }

  // Watch messages stream for a specific chat
  Stream<List<LocalMessage>> watchMessagesForChat(String chatId) {
    final query = _db.select(_db.messageTable)
      ..where((tbl) => tbl.chatId.equals(chatId))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.sentAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return LocalMessage(
          id: row.id,
          chatId: row.chatId,
          senderId: row.senderId,
          text: row.message,
          sentAt: row.sentAt,
        );
      }).toList();
    });
  }
}