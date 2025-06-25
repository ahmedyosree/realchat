// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_messages_service.dart';

// ignore_for_file: type=lint
class $ChatTableTable extends ChatTable
    with TableInfo<$ChatTableTable, ChatTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _peopleMeta = const VerificationMeta('people');
  @override
  late final GeneratedColumn<String> people = GeneratedColumn<String>(
      'people', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chatStartedAtMeta =
      const VerificationMeta('chatStartedAt');
  @override
  late final GeneratedColumn<DateTime> chatStartedAt =
      GeneratedColumn<DateTime>('chat_started_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, people, chatStartedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_table';
  @override
  VerificationContext validateIntegrity(Insertable<ChatTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('people')) {
      context.handle(_peopleMeta,
          people.isAcceptableOrUnknown(data['people']!, _peopleMeta));
    } else if (isInserting) {
      context.missing(_peopleMeta);
    }
    if (data.containsKey('chat_started_at')) {
      context.handle(
          _chatStartedAtMeta,
          chatStartedAt.isAcceptableOrUnknown(
              data['chat_started_at']!, _chatStartedAtMeta));
    } else if (isInserting) {
      context.missing(_chatStartedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      people: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}people'])!,
      chatStartedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}chat_started_at'])!,
    );
  }

  @override
  $ChatTableTable createAlias(String alias) {
    return $ChatTableTable(attachedDatabase, alias);
  }
}

class ChatTableData extends DataClass implements Insertable<ChatTableData> {
  final String id;
  final String people;
  final DateTime chatStartedAt;
  const ChatTableData(
      {required this.id, required this.people, required this.chatStartedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['people'] = Variable<String>(people);
    map['chat_started_at'] = Variable<DateTime>(chatStartedAt);
    return map;
  }

  ChatTableCompanion toCompanion(bool nullToAbsent) {
    return ChatTableCompanion(
      id: Value(id),
      people: Value(people),
      chatStartedAt: Value(chatStartedAt),
    );
  }

  factory ChatTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatTableData(
      id: serializer.fromJson<String>(json['id']),
      people: serializer.fromJson<String>(json['people']),
      chatStartedAt: serializer.fromJson<DateTime>(json['chatStartedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'people': serializer.toJson<String>(people),
      'chatStartedAt': serializer.toJson<DateTime>(chatStartedAt),
    };
  }

  ChatTableData copyWith(
          {String? id, String? people, DateTime? chatStartedAt}) =>
      ChatTableData(
        id: id ?? this.id,
        people: people ?? this.people,
        chatStartedAt: chatStartedAt ?? this.chatStartedAt,
      );
  ChatTableData copyWithCompanion(ChatTableCompanion data) {
    return ChatTableData(
      id: data.id.present ? data.id.value : this.id,
      people: data.people.present ? data.people.value : this.people,
      chatStartedAt: data.chatStartedAt.present
          ? data.chatStartedAt.value
          : this.chatStartedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatTableData(')
          ..write('id: $id, ')
          ..write('people: $people, ')
          ..write('chatStartedAt: $chatStartedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, people, chatStartedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatTableData &&
          other.id == this.id &&
          other.people == this.people &&
          other.chatStartedAt == this.chatStartedAt);
}

class ChatTableCompanion extends UpdateCompanion<ChatTableData> {
  final Value<String> id;
  final Value<String> people;
  final Value<DateTime> chatStartedAt;
  final Value<int> rowid;
  const ChatTableCompanion({
    this.id = const Value.absent(),
    this.people = const Value.absent(),
    this.chatStartedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatTableCompanion.insert({
    required String id,
    required String people,
    required DateTime chatStartedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        people = Value(people),
        chatStartedAt = Value(chatStartedAt);
  static Insertable<ChatTableData> custom({
    Expression<String>? id,
    Expression<String>? people,
    Expression<DateTime>? chatStartedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (people != null) 'people': people,
      if (chatStartedAt != null) 'chat_started_at': chatStartedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? people,
      Value<DateTime>? chatStartedAt,
      Value<int>? rowid}) {
    return ChatTableCompanion(
      id: id ?? this.id,
      people: people ?? this.people,
      chatStartedAt: chatStartedAt ?? this.chatStartedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (people.present) {
      map['people'] = Variable<String>(people.value);
    }
    if (chatStartedAt.present) {
      map['chat_started_at'] = Variable<DateTime>(chatStartedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatTableCompanion(')
          ..write('id: $id, ')
          ..write('people: $people, ')
          ..write('chatStartedAt: $chatStartedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessageTableTable extends MessageTable
    with TableInfo<$MessageTableTable, MessageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<String> chatId = GeneratedColumn<String>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chat_table (id)'));
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
      'sent_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, chatId, senderId, message, sentAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_table';
  @override
  VerificationContext validateIntegrity(Insertable<MessageTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(_sentAtMeta,
          sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta));
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_id'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      sentAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sent_at'])!,
    );
  }

  @override
  $MessageTableTable createAlias(String alias) {
    return $MessageTableTable(attachedDatabase, alias);
  }
}

class MessageTableData extends DataClass
    implements Insertable<MessageTableData> {
  final String id;
  final String chatId;
  final String senderId;
  final String message;
  final DateTime sentAt;
  const MessageTableData(
      {required this.id,
      required this.chatId,
      required this.senderId,
      required this.message,
      required this.sentAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chat_id'] = Variable<String>(chatId);
    map['sender_id'] = Variable<String>(senderId);
    map['message'] = Variable<String>(message);
    map['sent_at'] = Variable<DateTime>(sentAt);
    return map;
  }

  MessageTableCompanion toCompanion(bool nullToAbsent) {
    return MessageTableCompanion(
      id: Value(id),
      chatId: Value(chatId),
      senderId: Value(senderId),
      message: Value(message),
      sentAt: Value(sentAt),
    );
  }

  factory MessageTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageTableData(
      id: serializer.fromJson<String>(json['id']),
      chatId: serializer.fromJson<String>(json['chatId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      message: serializer.fromJson<String>(json['message']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chatId': serializer.toJson<String>(chatId),
      'senderId': serializer.toJson<String>(senderId),
      'message': serializer.toJson<String>(message),
      'sentAt': serializer.toJson<DateTime>(sentAt),
    };
  }

  MessageTableData copyWith(
          {String? id,
          String? chatId,
          String? senderId,
          String? message,
          DateTime? sentAt}) =>
      MessageTableData(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        senderId: senderId ?? this.senderId,
        message: message ?? this.message,
        sentAt: sentAt ?? this.sentAt,
      );
  MessageTableData copyWithCompanion(MessageTableCompanion data) {
    return MessageTableData(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      message: data.message.present ? data.message.value : this.message,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageTableData(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('senderId: $senderId, ')
          ..write('message: $message, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chatId, senderId, message, sentAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageTableData &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.senderId == this.senderId &&
          other.message == this.message &&
          other.sentAt == this.sentAt);
}

class MessageTableCompanion extends UpdateCompanion<MessageTableData> {
  final Value<String> id;
  final Value<String> chatId;
  final Value<String> senderId;
  final Value<String> message;
  final Value<DateTime> sentAt;
  final Value<int> rowid;
  const MessageTableCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.message = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageTableCompanion.insert({
    required String id,
    required String chatId,
    required String senderId,
    required String message,
    required DateTime sentAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        chatId = Value(chatId),
        senderId = Value(senderId),
        message = Value(message),
        sentAt = Value(sentAt);
  static Insertable<MessageTableData> custom({
    Expression<String>? id,
    Expression<String>? chatId,
    Expression<String>? senderId,
    Expression<String>? message,
    Expression<DateTime>? sentAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (senderId != null) 'sender_id': senderId,
      if (message != null) 'message': message,
      if (sentAt != null) 'sent_at': sentAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? chatId,
      Value<String>? senderId,
      Value<String>? message,
      Value<DateTime>? sentAt,
      Value<int>? rowid}) {
    return MessageTableCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      sentAt: sentAt ?? this.sentAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<String>(chatId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageTableCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('senderId: $senderId, ')
          ..write('message: $message, ')
          ..write('sentAt: $sentAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalMessagesDatabase extends GeneratedDatabase {
  _$LocalMessagesDatabase(QueryExecutor e) : super(e);
  $LocalMessagesDatabaseManager get managers =>
      $LocalMessagesDatabaseManager(this);
  late final $ChatTableTable chatTable = $ChatTableTable(this);
  late final $MessageTableTable messageTable = $MessageTableTable(this);
  late final Index messagesChatIdIdx = Index('messages_chat_id_idx',
      'CREATE INDEX messages_chat_id_idx ON message_table (chat_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [chatTable, messageTable, messagesChatIdIdx];
}

typedef $$ChatTableTableCreateCompanionBuilder = ChatTableCompanion Function({
  required String id,
  required String people,
  required DateTime chatStartedAt,
  Value<int> rowid,
});
typedef $$ChatTableTableUpdateCompanionBuilder = ChatTableCompanion Function({
  Value<String> id,
  Value<String> people,
  Value<DateTime> chatStartedAt,
  Value<int> rowid,
});

final class $$ChatTableTableReferences extends BaseReferences<
    _$LocalMessagesDatabase, $ChatTableTable, ChatTableData> {
  $$ChatTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MessageTableTable, List<MessageTableData>>
      _messageTableRefsTable(_$LocalMessagesDatabase db) =>
          MultiTypedResultKey.fromTable(db.messageTable,
              aliasName: $_aliasNameGenerator(
                  db.chatTable.id, db.messageTable.chatId));

  $$MessageTableTableProcessedTableManager get messageTableRefs {
    final manager = $$MessageTableTableTableManager($_db, $_db.messageTable)
        .filter((f) => f.chatId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messageTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChatTableTableFilterComposer
    extends Composer<_$LocalMessagesDatabase, $ChatTableTable> {
  $$ChatTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get people => $composableBuilder(
      column: $table.people, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get chatStartedAt => $composableBuilder(
      column: $table.chatStartedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> messageTableRefs(
      Expression<bool> Function($$MessageTableTableFilterComposer f) f) {
    final $$MessageTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messageTable,
        getReferencedColumn: (t) => t.chatId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessageTableTableFilterComposer(
              $db: $db,
              $table: $db.messageTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatTableTableOrderingComposer
    extends Composer<_$LocalMessagesDatabase, $ChatTableTable> {
  $$ChatTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get people => $composableBuilder(
      column: $table.people, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get chatStartedAt => $composableBuilder(
      column: $table.chatStartedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$ChatTableTableAnnotationComposer
    extends Composer<_$LocalMessagesDatabase, $ChatTableTable> {
  $$ChatTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get people =>
      $composableBuilder(column: $table.people, builder: (column) => column);

  GeneratedColumn<DateTime> get chatStartedAt => $composableBuilder(
      column: $table.chatStartedAt, builder: (column) => column);

  Expression<T> messageTableRefs<T extends Object>(
      Expression<T> Function($$MessageTableTableAnnotationComposer a) f) {
    final $$MessageTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messageTable,
        getReferencedColumn: (t) => t.chatId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessageTableTableAnnotationComposer(
              $db: $db,
              $table: $db.messageTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatTableTableTableManager extends RootTableManager<
    _$LocalMessagesDatabase,
    $ChatTableTable,
    ChatTableData,
    $$ChatTableTableFilterComposer,
    $$ChatTableTableOrderingComposer,
    $$ChatTableTableAnnotationComposer,
    $$ChatTableTableCreateCompanionBuilder,
    $$ChatTableTableUpdateCompanionBuilder,
    (ChatTableData, $$ChatTableTableReferences),
    ChatTableData,
    PrefetchHooks Function({bool messageTableRefs})> {
  $$ChatTableTableTableManager(
      _$LocalMessagesDatabase db, $ChatTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> people = const Value.absent(),
            Value<DateTime> chatStartedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatTableCompanion(
            id: id,
            people: people,
            chatStartedAt: chatStartedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String people,
            required DateTime chatStartedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatTableCompanion.insert(
            id: id,
            people: people,
            chatStartedAt: chatStartedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChatTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({messageTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (messageTableRefs) db.messageTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messageTableRefs)
                    await $_getPrefetchedData<ChatTableData, $ChatTableTable,
                            MessageTableData>(
                        currentTable: table,
                        referencedTable: $$ChatTableTableReferences
                            ._messageTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChatTableTableReferences(db, table, p0)
                                .messageTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.chatId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChatTableTableProcessedTableManager = ProcessedTableManager<
    _$LocalMessagesDatabase,
    $ChatTableTable,
    ChatTableData,
    $$ChatTableTableFilterComposer,
    $$ChatTableTableOrderingComposer,
    $$ChatTableTableAnnotationComposer,
    $$ChatTableTableCreateCompanionBuilder,
    $$ChatTableTableUpdateCompanionBuilder,
    (ChatTableData, $$ChatTableTableReferences),
    ChatTableData,
    PrefetchHooks Function({bool messageTableRefs})>;
typedef $$MessageTableTableCreateCompanionBuilder = MessageTableCompanion
    Function({
  required String id,
  required String chatId,
  required String senderId,
  required String message,
  required DateTime sentAt,
  Value<int> rowid,
});
typedef $$MessageTableTableUpdateCompanionBuilder = MessageTableCompanion
    Function({
  Value<String> id,
  Value<String> chatId,
  Value<String> senderId,
  Value<String> message,
  Value<DateTime> sentAt,
  Value<int> rowid,
});

final class $$MessageTableTableReferences extends BaseReferences<
    _$LocalMessagesDatabase, $MessageTableTable, MessageTableData> {
  $$MessageTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatTableTable _chatIdTable(_$LocalMessagesDatabase db) =>
      db.chatTable.createAlias(
          $_aliasNameGenerator(db.messageTable.chatId, db.chatTable.id));

  $$ChatTableTableProcessedTableManager get chatId {
    final $_column = $_itemColumn<String>('chat_id')!;

    final manager = $$ChatTableTableTableManager($_db, $_db.chatTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MessageTableTableFilterComposer
    extends Composer<_$LocalMessagesDatabase, $MessageTableTable> {
  $$MessageTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnFilters(column));

  $$ChatTableTableFilterComposer get chatId {
    final $$ChatTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $db.chatTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatTableTableFilterComposer(
              $db: $db,
              $table: $db.chatTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessageTableTableOrderingComposer
    extends Composer<_$LocalMessagesDatabase, $MessageTableTable> {
  $$MessageTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnOrderings(column));

  $$ChatTableTableOrderingComposer get chatId {
    final $$ChatTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $db.chatTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatTableTableOrderingComposer(
              $db: $db,
              $table: $db.chatTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessageTableTableAnnotationComposer
    extends Composer<_$LocalMessagesDatabase, $MessageTableTable> {
  $$MessageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  $$ChatTableTableAnnotationComposer get chatId {
    final $$ChatTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $db.chatTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatTableTableAnnotationComposer(
              $db: $db,
              $table: $db.chatTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessageTableTableTableManager extends RootTableManager<
    _$LocalMessagesDatabase,
    $MessageTableTable,
    MessageTableData,
    $$MessageTableTableFilterComposer,
    $$MessageTableTableOrderingComposer,
    $$MessageTableTableAnnotationComposer,
    $$MessageTableTableCreateCompanionBuilder,
    $$MessageTableTableUpdateCompanionBuilder,
    (MessageTableData, $$MessageTableTableReferences),
    MessageTableData,
    PrefetchHooks Function({bool chatId})> {
  $$MessageTableTableTableManager(
      _$LocalMessagesDatabase db, $MessageTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> chatId = const Value.absent(),
            Value<String> senderId = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<DateTime> sentAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessageTableCompanion(
            id: id,
            chatId: chatId,
            senderId: senderId,
            message: message,
            sentAt: sentAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String chatId,
            required String senderId,
            required String message,
            required DateTime sentAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MessageTableCompanion.insert(
            id: id,
            chatId: chatId,
            senderId: senderId,
            message: message,
            sentAt: sentAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MessageTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({chatId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (chatId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.chatId,
                    referencedTable:
                        $$MessageTableTableReferences._chatIdTable(db),
                    referencedColumn:
                        $$MessageTableTableReferences._chatIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MessageTableTableProcessedTableManager = ProcessedTableManager<
    _$LocalMessagesDatabase,
    $MessageTableTable,
    MessageTableData,
    $$MessageTableTableFilterComposer,
    $$MessageTableTableOrderingComposer,
    $$MessageTableTableAnnotationComposer,
    $$MessageTableTableCreateCompanionBuilder,
    $$MessageTableTableUpdateCompanionBuilder,
    (MessageTableData, $$MessageTableTableReferences),
    MessageTableData,
    PrefetchHooks Function({bool chatId})>;

class $LocalMessagesDatabaseManager {
  final _$LocalMessagesDatabase _db;
  $LocalMessagesDatabaseManager(this._db);
  $$ChatTableTableTableManager get chatTable =>
      $$ChatTableTableTableManager(_db, _db.chatTable);
  $$MessageTableTableTableManager get messageTable =>
      $$MessageTableTableTableManager(_db, _db.messageTable);
}
