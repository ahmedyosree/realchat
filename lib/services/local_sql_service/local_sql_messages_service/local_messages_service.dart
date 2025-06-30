import 'package:drift/drift.dart';
import '../../../core/models/Local_Message.dart';
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

@TableIndex(
  name: 'messages_chat_id_idx',
  columns: {#chatId},
)
@TableIndex(
  name: 'messages_chat_id_sent_at_idx',
  columns: {#chatId, #sentAt},
)
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

  /// Emits a list containing, for each distinct chatId, the single message
  /// whose sentAt is the most recent.
  // --- New function: Stream of latest message for each chat ---
  Stream<List<LocalMessage>> watchLatestMessagesForAllChats() {
    final latestQuery = _db.customSelect(
      '''
      SELECT m.*
      FROM message_table m
      INNER JOIN (
        SELECT chat_id, MAX(sent_at) as max_sent_at
        FROM message_table
        GROUP BY chat_id
      ) grouped
      ON m.chat_id = grouped.chat_id AND m.sent_at = grouped.max_sent_at
      ORDER BY m.sent_at DESC
      ''',
      readsFrom: {_db.messageTable},
    );

    return latestQuery.watch().map((rows) {
      return rows.map((row) {
        return LocalMessage(
          id: row.read<String>('id'),
          chatId: row.read<String>('chat_id'),
          senderId: row.read<String>('sender_id'),
          text: row.read<String>('message'),
          sentAt: row.read<DateTime>('sent_at'),
        );
      }).toList();
    });
  }

}