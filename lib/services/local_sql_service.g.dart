// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_sql_service.dart';

// ignore_for_file: type=lint
class $ChatsTable extends Chats with TableInfo<$ChatsTable, Chat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _chatStartInMeta =
      const VerificationMeta('chatStartIn');
  @override
  late final GeneratedColumn<DateTime> chatStartIn = GeneratedColumn<DateTime>(
      'chat_start_in', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, people, chatStartIn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(Insertable<Chat> instance,
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
    if (data.containsKey('chat_start_in')) {
      context.handle(
          _chatStartInMeta,
          chatStartIn.isAcceptableOrUnknown(
              data['chat_start_in']!, _chatStartInMeta));
    } else if (isInserting) {
      context.missing(_chatStartInMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      people: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}people'])!,
      chatStartIn: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}chat_start_in'])!,
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class Chat extends DataClass implements Insertable<Chat> {
  final String id;
  final String people;
  final DateTime chatStartIn;
  const Chat(
      {required this.id, required this.people, required this.chatStartIn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['people'] = Variable<String>(people);
    map['chat_start_in'] = Variable<DateTime>(chatStartIn);
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      people: Value(people),
      chatStartIn: Value(chatStartIn),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      id: serializer.fromJson<String>(json['id']),
      people: serializer.fromJson<String>(json['people']),
      chatStartIn: serializer.fromJson<DateTime>(json['chatStartIn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'people': serializer.toJson<String>(people),
      'chatStartIn': serializer.toJson<DateTime>(chatStartIn),
    };
  }

  Chat copyWith({String? id, String? people, DateTime? chatStartIn}) => Chat(
        id: id ?? this.id,
        people: people ?? this.people,
        chatStartIn: chatStartIn ?? this.chatStartIn,
      );
  Chat copyWithCompanion(ChatsCompanion data) {
    return Chat(
      id: data.id.present ? data.id.value : this.id,
      people: data.people.present ? data.people.value : this.people,
      chatStartIn:
          data.chatStartIn.present ? data.chatStartIn.value : this.chatStartIn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('id: $id, ')
          ..write('people: $people, ')
          ..write('chatStartIn: $chatStartIn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, people, chatStartIn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          other.id == this.id &&
          other.people == this.people &&
          other.chatStartIn == this.chatStartIn);
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<String> id;
  final Value<String> people;
  final Value<DateTime> chatStartIn;
  final Value<int> rowid;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.people = const Value.absent(),
    this.chatStartIn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatsCompanion.insert({
    required String id,
    required String people,
    required DateTime chatStartIn,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        people = Value(people),
        chatStartIn = Value(chatStartIn);
  static Insertable<Chat> custom({
    Expression<String>? id,
    Expression<String>? people,
    Expression<DateTime>? chatStartIn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (people != null) 'people': people,
      if (chatStartIn != null) 'chat_start_in': chatStartIn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatsCompanion copyWith(
      {Value<String>? id,
      Value<String>? people,
      Value<DateTime>? chatStartIn,
      Value<int>? rowid}) {
    return ChatsCompanion(
      id: id ?? this.id,
      people: people ?? this.people,
      chatStartIn: chatStartIn ?? this.chatStartIn,
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
    if (chatStartIn.present) {
      map['chat_start_in'] = Variable<DateTime>(chatStartIn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('id: $id, ')
          ..write('people: $people, ')
          ..write('chatStartIn: $chatStartIn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $ChatsTable chats = $ChatsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [chats];
}

typedef $$ChatsTableCreateCompanionBuilder = ChatsCompanion Function({
  required String id,
  required String people,
  required DateTime chatStartIn,
  Value<int> rowid,
});
typedef $$ChatsTableUpdateCompanionBuilder = ChatsCompanion Function({
  Value<String> id,
  Value<String> people,
  Value<DateTime> chatStartIn,
  Value<int> rowid,
});

class $$ChatsTableFilterComposer
    extends Composer<_$LocalDatabase, $ChatsTable> {
  $$ChatsTableFilterComposer({
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

  ColumnFilters<DateTime> get chatStartIn => $composableBuilder(
      column: $table.chatStartIn, builder: (column) => ColumnFilters(column));
}

class $$ChatsTableOrderingComposer
    extends Composer<_$LocalDatabase, $ChatsTable> {
  $$ChatsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get chatStartIn => $composableBuilder(
      column: $table.chatStartIn, builder: (column) => ColumnOrderings(column));
}

class $$ChatsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $ChatsTable> {
  $$ChatsTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get chatStartIn => $composableBuilder(
      column: $table.chatStartIn, builder: (column) => column);
}

class $$ChatsTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $ChatsTable,
    Chat,
    $$ChatsTableFilterComposer,
    $$ChatsTableOrderingComposer,
    $$ChatsTableAnnotationComposer,
    $$ChatsTableCreateCompanionBuilder,
    $$ChatsTableUpdateCompanionBuilder,
    (Chat, BaseReferences<_$LocalDatabase, $ChatsTable, Chat>),
    Chat,
    PrefetchHooks Function()> {
  $$ChatsTableTableManager(_$LocalDatabase db, $ChatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> people = const Value.absent(),
            Value<DateTime> chatStartIn = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatsCompanion(
            id: id,
            people: people,
            chatStartIn: chatStartIn,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String people,
            required DateTime chatStartIn,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatsCompanion.insert(
            id: id,
            people: people,
            chatStartIn: chatStartIn,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatsTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $ChatsTable,
    Chat,
    $$ChatsTableFilterComposer,
    $$ChatsTableOrderingComposer,
    $$ChatsTableAnnotationComposer,
    $$ChatsTableCreateCompanionBuilder,
    $$ChatsTableUpdateCompanionBuilder,
    (Chat, BaseReferences<_$LocalDatabase, $ChatsTable, Chat>),
    Chat,
    PrefetchHooks Function()>;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db, _db.chats);
}
