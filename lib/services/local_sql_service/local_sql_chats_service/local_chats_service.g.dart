// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_chats_service.dart';

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

abstract class _$LocalChatsDatabase extends GeneratedDatabase {
  _$LocalChatsDatabase(QueryExecutor e) : super(e);
  $LocalChatsDatabaseManager get managers => $LocalChatsDatabaseManager(this);
  late final $ChatTableTable chatTable = $ChatTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [chatTable];
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

class $$ChatTableTableFilterComposer
    extends Composer<_$LocalChatsDatabase, $ChatTableTable> {
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
}

class $$ChatTableTableOrderingComposer
    extends Composer<_$LocalChatsDatabase, $ChatTableTable> {
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
    extends Composer<_$LocalChatsDatabase, $ChatTableTable> {
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
}

class $$ChatTableTableTableManager extends RootTableManager<
    _$LocalChatsDatabase,
    $ChatTableTable,
    ChatTableData,
    $$ChatTableTableFilterComposer,
    $$ChatTableTableOrderingComposer,
    $$ChatTableTableAnnotationComposer,
    $$ChatTableTableCreateCompanionBuilder,
    $$ChatTableTableUpdateCompanionBuilder,
    (
      ChatTableData,
      BaseReferences<_$LocalChatsDatabase, $ChatTableTable, ChatTableData>
    ),
    ChatTableData,
    PrefetchHooks Function()> {
  $$ChatTableTableTableManager(_$LocalChatsDatabase db, $ChatTableTable table)
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatTableTableProcessedTableManager = ProcessedTableManager<
    _$LocalChatsDatabase,
    $ChatTableTable,
    ChatTableData,
    $$ChatTableTableFilterComposer,
    $$ChatTableTableOrderingComposer,
    $$ChatTableTableAnnotationComposer,
    $$ChatTableTableCreateCompanionBuilder,
    $$ChatTableTableUpdateCompanionBuilder,
    (
      ChatTableData,
      BaseReferences<_$LocalChatsDatabase, $ChatTableTable, ChatTableData>
    ),
    ChatTableData,
    PrefetchHooks Function()>;

class $LocalChatsDatabaseManager {
  final _$LocalChatsDatabase _db;
  $LocalChatsDatabaseManager(this._db);
  $$ChatTableTableTableManager get chatTable =>
      $$ChatTableTableTableManager(_db, _db.chatTable);
}
