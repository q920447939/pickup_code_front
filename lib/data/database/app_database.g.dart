// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PickupItemsTable extends PickupItems
    with TableInfo<$PickupItemsTable, PickupItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PickupItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stationNameMeta = const VerificationMeta(
    'stationName',
  );
  @override
  late final GeneratedColumn<String> stationName = GeneratedColumn<String>(
    'station_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expireAtMeta = const VerificationMeta(
    'expireAt',
  );
  @override
  late final GeneratedColumn<DateTime> expireAt = GeneratedColumn<DateTime>(
    'expire_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PickupStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<PickupStatus>($PickupItemsTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<PickupSource, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(2),
      ).withConverter<PickupSource>($PickupItemsTable.$convertersource);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppMode, int> mode =
      GeneratedColumn<int>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<AppMode>($PickupItemsTable.$convertermode);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: Constant(DateTime(1970)),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    stationName,
    expireAt,
    status,
    source,
    note,
    mode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pickup_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PickupItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('station_name')) {
      context.handle(
        _stationNameMeta,
        stationName.isAcceptableOrUnknown(
          data['station_name']!,
          _stationNameMeta,
        ),
      );
    }
    if (data.containsKey('expire_at')) {
      context.handle(
        _expireAtMeta,
        expireAt.isAcceptableOrUnknown(data['expire_at']!, _expireAtMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {code, mode},
  ];
  @override
  PickupItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PickupItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      stationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_name'],
      ),
      expireAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expire_at'],
      ),
      status: $PickupItemsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      source: $PickupItemsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      mode: $PickupItemsTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}mode'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PickupItemsTable createAlias(String alias) {
    return $PickupItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PickupStatus, int, int> $converterstatus =
      const EnumIndexConverter<PickupStatus>(PickupStatus.values);
  static JsonTypeConverter2<PickupSource, int, int> $convertersource =
      const EnumIndexConverter<PickupSource>(PickupSource.values);
  static JsonTypeConverter2<AppMode, int, int> $convertermode =
      const EnumIndexConverter<AppMode>(AppMode.values);
}

class PickupItem extends DataClass implements Insertable<PickupItem> {
  final int id;
  final String code;
  final String? stationName;
  final DateTime? expireAt;
  final PickupStatus status;
  final PickupSource source;
  final String? note;
  final AppMode mode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PickupItem({
    required this.id,
    required this.code,
    this.stationName,
    this.expireAt,
    required this.status,
    required this.source,
    this.note,
    required this.mode,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || stationName != null) {
      map['station_name'] = Variable<String>(stationName);
    }
    if (!nullToAbsent || expireAt != null) {
      map['expire_at'] = Variable<DateTime>(expireAt);
    }
    {
      map['status'] = Variable<int>(
        $PickupItemsTable.$converterstatus.toSql(status),
      );
    }
    {
      map['source'] = Variable<int>(
        $PickupItemsTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['mode'] = Variable<int>($PickupItemsTable.$convertermode.toSql(mode));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PickupItemsCompanion toCompanion(bool nullToAbsent) {
    return PickupItemsCompanion(
      id: Value(id),
      code: Value(code),
      stationName: stationName == null && nullToAbsent
          ? const Value.absent()
          : Value(stationName),
      expireAt: expireAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expireAt),
      status: Value(status),
      source: Value(source),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      mode: Value(mode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PickupItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PickupItem(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      stationName: serializer.fromJson<String?>(json['stationName']),
      expireAt: serializer.fromJson<DateTime?>(json['expireAt']),
      status: $PickupItemsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      source: $PickupItemsTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
      note: serializer.fromJson<String?>(json['note']),
      mode: $PickupItemsTable.$convertermode.fromJson(
        serializer.fromJson<int>(json['mode']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'stationName': serializer.toJson<String?>(stationName),
      'expireAt': serializer.toJson<DateTime?>(expireAt),
      'status': serializer.toJson<int>(
        $PickupItemsTable.$converterstatus.toJson(status),
      ),
      'source': serializer.toJson<int>(
        $PickupItemsTable.$convertersource.toJson(source),
      ),
      'note': serializer.toJson<String?>(note),
      'mode': serializer.toJson<int>(
        $PickupItemsTable.$convertermode.toJson(mode),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PickupItem copyWith({
    int? id,
    String? code,
    Value<String?> stationName = const Value.absent(),
    Value<DateTime?> expireAt = const Value.absent(),
    PickupStatus? status,
    PickupSource? source,
    Value<String?> note = const Value.absent(),
    AppMode? mode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PickupItem(
    id: id ?? this.id,
    code: code ?? this.code,
    stationName: stationName.present ? stationName.value : this.stationName,
    expireAt: expireAt.present ? expireAt.value : this.expireAt,
    status: status ?? this.status,
    source: source ?? this.source,
    note: note.present ? note.value : this.note,
    mode: mode ?? this.mode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PickupItem copyWithCompanion(PickupItemsCompanion data) {
    return PickupItem(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      stationName: data.stationName.present
          ? data.stationName.value
          : this.stationName,
      expireAt: data.expireAt.present ? data.expireAt.value : this.expireAt,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      note: data.note.present ? data.note.value : this.note,
      mode: data.mode.present ? data.mode.value : this.mode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PickupItem(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('stationName: $stationName, ')
          ..write('expireAt: $expireAt, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('mode: $mode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    stationName,
    expireAt,
    status,
    source,
    note,
    mode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PickupItem &&
          other.id == this.id &&
          other.code == this.code &&
          other.stationName == this.stationName &&
          other.expireAt == this.expireAt &&
          other.status == this.status &&
          other.source == this.source &&
          other.note == this.note &&
          other.mode == this.mode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PickupItemsCompanion extends UpdateCompanion<PickupItem> {
  final Value<int> id;
  final Value<String> code;
  final Value<String?> stationName;
  final Value<DateTime?> expireAt;
  final Value<PickupStatus> status;
  final Value<PickupSource> source;
  final Value<String?> note;
  final Value<AppMode> mode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PickupItemsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.stationName = const Value.absent(),
    this.expireAt = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.mode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PickupItemsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    this.stationName = const Value.absent(),
    this.expireAt = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.mode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : code = Value(code);
  static Insertable<PickupItem> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? stationName,
    Expression<DateTime>? expireAt,
    Expression<int>? status,
    Expression<int>? source,
    Expression<String>? note,
    Expression<int>? mode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (stationName != null) 'station_name': stationName,
      if (expireAt != null) 'expire_at': expireAt,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (note != null) 'note': note,
      if (mode != null) 'mode': mode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PickupItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String?>? stationName,
    Value<DateTime?>? expireAt,
    Value<PickupStatus>? status,
    Value<PickupSource>? source,
    Value<String?>? note,
    Value<AppMode>? mode,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PickupItemsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      stationName: stationName ?? this.stationName,
      expireAt: expireAt ?? this.expireAt,
      status: status ?? this.status,
      source: source ?? this.source,
      note: note ?? this.note,
      mode: mode ?? this.mode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (stationName.present) {
      map['station_name'] = Variable<String>(stationName.value);
    }
    if (expireAt.present) {
      map['expire_at'] = Variable<DateTime>(expireAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $PickupItemsTable.$converterstatus.toSql(status.value),
      );
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $PickupItemsTable.$convertersource.toSql(source.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (mode.present) {
      map['mode'] = Variable<int>(
        $PickupItemsTable.$convertermode.toSql(mode.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PickupItemsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('stationName: $stationName, ')
          ..write('expireAt: $expireAt, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('mode: $mode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TemplateRulesTable extends TemplateRules
    with TableInfo<$TemplateRulesTable, TemplateRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplateRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sampleTextMeta = const VerificationMeta(
    'sampleText',
  );
  @override
  late final GeneratedColumn<String> sampleText = GeneratedColumn<String>(
    'sample_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rulePayloadMeta = const VerificationMeta(
    'rulePayload',
  );
  @override
  late final GeneratedColumn<String> rulePayload = GeneratedColumn<String>(
    'rule_payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppMode, int> mode =
      GeneratedColumn<int>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<AppMode>($TemplateRulesTable.$convertermode);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: Constant(DateTime(1970)),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    sampleText,
    rulePayload,
    isEnabled,
    mode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'template_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemplateRuleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('sample_text')) {
      context.handle(
        _sampleTextMeta,
        sampleText.isAcceptableOrUnknown(data['sample_text']!, _sampleTextMeta),
      );
    } else if (isInserting) {
      context.missing(_sampleTextMeta);
    }
    if (data.containsKey('rule_payload')) {
      context.handle(
        _rulePayloadMeta,
        rulePayload.isAcceptableOrUnknown(
          data['rule_payload']!,
          _rulePayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rulePayloadMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateRuleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      sampleText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sample_text'],
      )!,
      rulePayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_payload'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      mode: $TemplateRulesTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}mode'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TemplateRulesTable createAlias(String alias) {
    return $TemplateRulesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppMode, int, int> $convertermode =
      const EnumIndexConverter<AppMode>(AppMode.values);
}

class TemplateRuleRow extends DataClass implements Insertable<TemplateRuleRow> {
  final int id;
  final String? name;
  final String sampleText;
  final String rulePayload;
  final bool isEnabled;
  final AppMode mode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TemplateRuleRow({
    required this.id,
    this.name,
    required this.sampleText,
    required this.rulePayload,
    required this.isEnabled,
    required this.mode,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['sample_text'] = Variable<String>(sampleText);
    map['rule_payload'] = Variable<String>(rulePayload);
    map['is_enabled'] = Variable<bool>(isEnabled);
    {
      map['mode'] = Variable<int>(
        $TemplateRulesTable.$convertermode.toSql(mode),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TemplateRulesCompanion toCompanion(bool nullToAbsent) {
    return TemplateRulesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      sampleText: Value(sampleText),
      rulePayload: Value(rulePayload),
      isEnabled: Value(isEnabled),
      mode: Value(mode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TemplateRuleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateRuleRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      sampleText: serializer.fromJson<String>(json['sampleText']),
      rulePayload: serializer.fromJson<String>(json['rulePayload']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      mode: $TemplateRulesTable.$convertermode.fromJson(
        serializer.fromJson<int>(json['mode']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'sampleText': serializer.toJson<String>(sampleText),
      'rulePayload': serializer.toJson<String>(rulePayload),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'mode': serializer.toJson<int>(
        $TemplateRulesTable.$convertermode.toJson(mode),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TemplateRuleRow copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    String? sampleText,
    String? rulePayload,
    bool? isEnabled,
    AppMode? mode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TemplateRuleRow(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    sampleText: sampleText ?? this.sampleText,
    rulePayload: rulePayload ?? this.rulePayload,
    isEnabled: isEnabled ?? this.isEnabled,
    mode: mode ?? this.mode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TemplateRuleRow copyWithCompanion(TemplateRulesCompanion data) {
    return TemplateRuleRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sampleText: data.sampleText.present
          ? data.sampleText.value
          : this.sampleText,
      rulePayload: data.rulePayload.present
          ? data.rulePayload.value
          : this.rulePayload,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      mode: data.mode.present ? data.mode.value : this.mode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateRuleRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sampleText: $sampleText, ')
          ..write('rulePayload: $rulePayload, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('mode: $mode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    sampleText,
    rulePayload,
    isEnabled,
    mode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateRuleRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.sampleText == this.sampleText &&
          other.rulePayload == this.rulePayload &&
          other.isEnabled == this.isEnabled &&
          other.mode == this.mode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TemplateRulesCompanion extends UpdateCompanion<TemplateRuleRow> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String> sampleText;
  final Value<String> rulePayload;
  final Value<bool> isEnabled;
  final Value<AppMode> mode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TemplateRulesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sampleText = const Value.absent(),
    this.rulePayload = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.mode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TemplateRulesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    required String sampleText,
    required String rulePayload,
    this.isEnabled = const Value.absent(),
    this.mode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : sampleText = Value(sampleText),
       rulePayload = Value(rulePayload);
  static Insertable<TemplateRuleRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? sampleText,
    Expression<String>? rulePayload,
    Expression<bool>? isEnabled,
    Expression<int>? mode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sampleText != null) 'sample_text': sampleText,
      if (rulePayload != null) 'rule_payload': rulePayload,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (mode != null) 'mode': mode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TemplateRulesCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<String>? sampleText,
    Value<String>? rulePayload,
    Value<bool>? isEnabled,
    Value<AppMode>? mode,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TemplateRulesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sampleText: sampleText ?? this.sampleText,
      rulePayload: rulePayload ?? this.rulePayload,
      isEnabled: isEnabled ?? this.isEnabled,
      mode: mode ?? this.mode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sampleText.present) {
      map['sample_text'] = Variable<String>(sampleText.value);
    }
    if (rulePayload.present) {
      map['rule_payload'] = Variable<String>(rulePayload.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (mode.present) {
      map['mode'] = Variable<int>(
        $TemplateRulesTable.$convertermode.toSql(mode.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplateRulesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sampleText: $sampleText, ')
          ..write('rulePayload: $rulePayload, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('mode: $mode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReminderSettingsTable extends ReminderSettings
    with TableInfo<$ReminderSettingsTable, ReminderSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _remindBeforeMinutesMeta =
      const VerificationMeta('remindBeforeMinutes');
  @override
  late final GeneratedColumn<int> remindBeforeMinutes = GeneratedColumn<int>(
    'remind_before_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fixedTimeMinutesMeta = const VerificationMeta(
    'fixedTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> fixedTimeMinutes = GeneratedColumn<int>(
    'fixed_time_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quietHoursStartMinutesMeta =
      const VerificationMeta('quietHoursStartMinutes');
  @override
  late final GeneratedColumn<int> quietHoursStartMinutes = GeneratedColumn<int>(
    'quiet_hours_start_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quietHoursEndMinutesMeta =
      const VerificationMeta('quietHoursEndMinutes');
  @override
  late final GeneratedColumn<int> quietHoursEndMinutes = GeneratedColumn<int>(
    'quiet_hours_end_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppMode, int> mode =
      GeneratedColumn<int>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<AppMode>($ReminderSettingsTable.$convertermode);
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: Constant(DateTime(1970)),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    isEnabled,
    remindBeforeMinutes,
    fixedTimeMinutes,
    quietHoursStartMinutes,
    quietHoursEndMinutes,
    mode,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('remind_before_minutes')) {
      context.handle(
        _remindBeforeMinutesMeta,
        remindBeforeMinutes.isAcceptableOrUnknown(
          data['remind_before_minutes']!,
          _remindBeforeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('fixed_time_minutes')) {
      context.handle(
        _fixedTimeMinutesMeta,
        fixedTimeMinutes.isAcceptableOrUnknown(
          data['fixed_time_minutes']!,
          _fixedTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('quiet_hours_start_minutes')) {
      context.handle(
        _quietHoursStartMinutesMeta,
        quietHoursStartMinutes.isAcceptableOrUnknown(
          data['quiet_hours_start_minutes']!,
          _quietHoursStartMinutesMeta,
        ),
      );
    }
    if (data.containsKey('quiet_hours_end_minutes')) {
      context.handle(
        _quietHoursEndMinutesMeta,
        quietHoursEndMinutes.isAcceptableOrUnknown(
          data['quiet_hours_end_minutes']!,
          _quietHoursEndMinutesMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, mode};
  @override
  ReminderSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderSettingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      remindBeforeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remind_before_minutes'],
      ),
      fixedTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fixed_time_minutes'],
      ),
      quietHoursStartMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiet_hours_start_minutes'],
      ),
      quietHoursEndMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiet_hours_end_minutes'],
      ),
      mode: $ReminderSettingsTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}mode'],
        )!,
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReminderSettingsTable createAlias(String alias) {
    return $ReminderSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppMode, int, int> $convertermode =
      const EnumIndexConverter<AppMode>(AppMode.values);
}

class ReminderSettingRow extends DataClass
    implements Insertable<ReminderSettingRow> {
  final int id;
  final bool isEnabled;
  final int? remindBeforeMinutes;
  final int? fixedTimeMinutes;
  final int? quietHoursStartMinutes;
  final int? quietHoursEndMinutes;
  final AppMode mode;
  final DateTime updatedAt;
  const ReminderSettingRow({
    required this.id,
    required this.isEnabled,
    this.remindBeforeMinutes,
    this.fixedTimeMinutes,
    this.quietHoursStartMinutes,
    this.quietHoursEndMinutes,
    required this.mode,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['is_enabled'] = Variable<bool>(isEnabled);
    if (!nullToAbsent || remindBeforeMinutes != null) {
      map['remind_before_minutes'] = Variable<int>(remindBeforeMinutes);
    }
    if (!nullToAbsent || fixedTimeMinutes != null) {
      map['fixed_time_minutes'] = Variable<int>(fixedTimeMinutes);
    }
    if (!nullToAbsent || quietHoursStartMinutes != null) {
      map['quiet_hours_start_minutes'] = Variable<int>(quietHoursStartMinutes);
    }
    if (!nullToAbsent || quietHoursEndMinutes != null) {
      map['quiet_hours_end_minutes'] = Variable<int>(quietHoursEndMinutes);
    }
    {
      map['mode'] = Variable<int>(
        $ReminderSettingsTable.$convertermode.toSql(mode),
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReminderSettingsCompanion toCompanion(bool nullToAbsent) {
    return ReminderSettingsCompanion(
      id: Value(id),
      isEnabled: Value(isEnabled),
      remindBeforeMinutes: remindBeforeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(remindBeforeMinutes),
      fixedTimeMinutes: fixedTimeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(fixedTimeMinutes),
      quietHoursStartMinutes: quietHoursStartMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(quietHoursStartMinutes),
      quietHoursEndMinutes: quietHoursEndMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(quietHoursEndMinutes),
      mode: Value(mode),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReminderSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderSettingRow(
      id: serializer.fromJson<int>(json['id']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      remindBeforeMinutes: serializer.fromJson<int?>(
        json['remindBeforeMinutes'],
      ),
      fixedTimeMinutes: serializer.fromJson<int?>(json['fixedTimeMinutes']),
      quietHoursStartMinutes: serializer.fromJson<int?>(
        json['quietHoursStartMinutes'],
      ),
      quietHoursEndMinutes: serializer.fromJson<int?>(
        json['quietHoursEndMinutes'],
      ),
      mode: $ReminderSettingsTable.$convertermode.fromJson(
        serializer.fromJson<int>(json['mode']),
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'remindBeforeMinutes': serializer.toJson<int?>(remindBeforeMinutes),
      'fixedTimeMinutes': serializer.toJson<int?>(fixedTimeMinutes),
      'quietHoursStartMinutes': serializer.toJson<int?>(quietHoursStartMinutes),
      'quietHoursEndMinutes': serializer.toJson<int?>(quietHoursEndMinutes),
      'mode': serializer.toJson<int>(
        $ReminderSettingsTable.$convertermode.toJson(mode),
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReminderSettingRow copyWith({
    int? id,
    bool? isEnabled,
    Value<int?> remindBeforeMinutes = const Value.absent(),
    Value<int?> fixedTimeMinutes = const Value.absent(),
    Value<int?> quietHoursStartMinutes = const Value.absent(),
    Value<int?> quietHoursEndMinutes = const Value.absent(),
    AppMode? mode,
    DateTime? updatedAt,
  }) => ReminderSettingRow(
    id: id ?? this.id,
    isEnabled: isEnabled ?? this.isEnabled,
    remindBeforeMinutes: remindBeforeMinutes.present
        ? remindBeforeMinutes.value
        : this.remindBeforeMinutes,
    fixedTimeMinutes: fixedTimeMinutes.present
        ? fixedTimeMinutes.value
        : this.fixedTimeMinutes,
    quietHoursStartMinutes: quietHoursStartMinutes.present
        ? quietHoursStartMinutes.value
        : this.quietHoursStartMinutes,
    quietHoursEndMinutes: quietHoursEndMinutes.present
        ? quietHoursEndMinutes.value
        : this.quietHoursEndMinutes,
    mode: mode ?? this.mode,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReminderSettingRow copyWithCompanion(ReminderSettingsCompanion data) {
    return ReminderSettingRow(
      id: data.id.present ? data.id.value : this.id,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      remindBeforeMinutes: data.remindBeforeMinutes.present
          ? data.remindBeforeMinutes.value
          : this.remindBeforeMinutes,
      fixedTimeMinutes: data.fixedTimeMinutes.present
          ? data.fixedTimeMinutes.value
          : this.fixedTimeMinutes,
      quietHoursStartMinutes: data.quietHoursStartMinutes.present
          ? data.quietHoursStartMinutes.value
          : this.quietHoursStartMinutes,
      quietHoursEndMinutes: data.quietHoursEndMinutes.present
          ? data.quietHoursEndMinutes.value
          : this.quietHoursEndMinutes,
      mode: data.mode.present ? data.mode.value : this.mode,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSettingRow(')
          ..write('id: $id, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('remindBeforeMinutes: $remindBeforeMinutes, ')
          ..write('fixedTimeMinutes: $fixedTimeMinutes, ')
          ..write('quietHoursStartMinutes: $quietHoursStartMinutes, ')
          ..write('quietHoursEndMinutes: $quietHoursEndMinutes, ')
          ..write('mode: $mode, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    isEnabled,
    remindBeforeMinutes,
    fixedTimeMinutes,
    quietHoursStartMinutes,
    quietHoursEndMinutes,
    mode,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderSettingRow &&
          other.id == this.id &&
          other.isEnabled == this.isEnabled &&
          other.remindBeforeMinutes == this.remindBeforeMinutes &&
          other.fixedTimeMinutes == this.fixedTimeMinutes &&
          other.quietHoursStartMinutes == this.quietHoursStartMinutes &&
          other.quietHoursEndMinutes == this.quietHoursEndMinutes &&
          other.mode == this.mode &&
          other.updatedAt == this.updatedAt);
}

class ReminderSettingsCompanion extends UpdateCompanion<ReminderSettingRow> {
  final Value<int> id;
  final Value<bool> isEnabled;
  final Value<int?> remindBeforeMinutes;
  final Value<int?> fixedTimeMinutes;
  final Value<int?> quietHoursStartMinutes;
  final Value<int?> quietHoursEndMinutes;
  final Value<AppMode> mode;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReminderSettingsCompanion({
    this.id = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.remindBeforeMinutes = const Value.absent(),
    this.fixedTimeMinutes = const Value.absent(),
    this.quietHoursStartMinutes = const Value.absent(),
    this.quietHoursEndMinutes = const Value.absent(),
    this.mode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.remindBeforeMinutes = const Value.absent(),
    this.fixedTimeMinutes = const Value.absent(),
    this.quietHoursStartMinutes = const Value.absent(),
    this.quietHoursEndMinutes = const Value.absent(),
    this.mode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<ReminderSettingRow> custom({
    Expression<int>? id,
    Expression<bool>? isEnabled,
    Expression<int>? remindBeforeMinutes,
    Expression<int>? fixedTimeMinutes,
    Expression<int>? quietHoursStartMinutes,
    Expression<int>? quietHoursEndMinutes,
    Expression<int>? mode,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (remindBeforeMinutes != null)
        'remind_before_minutes': remindBeforeMinutes,
      if (fixedTimeMinutes != null) 'fixed_time_minutes': fixedTimeMinutes,
      if (quietHoursStartMinutes != null)
        'quiet_hours_start_minutes': quietHoursStartMinutes,
      if (quietHoursEndMinutes != null)
        'quiet_hours_end_minutes': quietHoursEndMinutes,
      if (mode != null) 'mode': mode,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? isEnabled,
    Value<int?>? remindBeforeMinutes,
    Value<int?>? fixedTimeMinutes,
    Value<int?>? quietHoursStartMinutes,
    Value<int?>? quietHoursEndMinutes,
    Value<AppMode>? mode,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReminderSettingsCompanion(
      id: id ?? this.id,
      isEnabled: isEnabled ?? this.isEnabled,
      remindBeforeMinutes: remindBeforeMinutes ?? this.remindBeforeMinutes,
      fixedTimeMinutes: fixedTimeMinutes ?? this.fixedTimeMinutes,
      quietHoursStartMinutes:
          quietHoursStartMinutes ?? this.quietHoursStartMinutes,
      quietHoursEndMinutes: quietHoursEndMinutes ?? this.quietHoursEndMinutes,
      mode: mode ?? this.mode,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (remindBeforeMinutes.present) {
      map['remind_before_minutes'] = Variable<int>(remindBeforeMinutes.value);
    }
    if (fixedTimeMinutes.present) {
      map['fixed_time_minutes'] = Variable<int>(fixedTimeMinutes.value);
    }
    if (quietHoursStartMinutes.present) {
      map['quiet_hours_start_minutes'] = Variable<int>(
        quietHoursStartMinutes.value,
      );
    }
    if (quietHoursEndMinutes.present) {
      map['quiet_hours_end_minutes'] = Variable<int>(
        quietHoursEndMinutes.value,
      );
    }
    if (mode.present) {
      map['mode'] = Variable<int>(
        $ReminderSettingsTable.$convertermode.toSql(mode.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSettingsCompanion(')
          ..write('id: $id, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('remindBeforeMinutes: $remindBeforeMinutes, ')
          ..write('fixedTimeMinutes: $fixedTimeMinutes, ')
          ..write('quietHoursStartMinutes: $quietHoursStartMinutes, ')
          ..write('quietHoursEndMinutes: $quietHoursEndMinutes, ')
          ..write('mode: $mode, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PickupItemsTable pickupItems = $PickupItemsTable(this);
  late final $TemplateRulesTable templateRules = $TemplateRulesTable(this);
  late final $ReminderSettingsTable reminderSettings = $ReminderSettingsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pickupItems,
    templateRules,
    reminderSettings,
  ];
}

typedef $$PickupItemsTableCreateCompanionBuilder =
    PickupItemsCompanion Function({
      Value<int> id,
      required String code,
      Value<String?> stationName,
      Value<DateTime?> expireAt,
      Value<PickupStatus> status,
      Value<PickupSource> source,
      Value<String?> note,
      Value<AppMode> mode,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PickupItemsTableUpdateCompanionBuilder =
    PickupItemsCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String?> stationName,
      Value<DateTime?> expireAt,
      Value<PickupStatus> status,
      Value<PickupSource> source,
      Value<String?> note,
      Value<AppMode> mode,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$PickupItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PickupItemsTable> {
  $$PickupItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expireAt => $composableBuilder(
    column: $table.expireAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PickupStatus, PickupStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<PickupSource, PickupSource, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppMode, AppMode, int> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PickupItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PickupItemsTable> {
  $$PickupItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expireAt => $composableBuilder(
    column: $table.expireAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PickupItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PickupItemsTable> {
  $$PickupItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get stationName => $composableBuilder(
    column: $table.stationName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expireAt =>
      $composableBuilder(column: $table.expireAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PickupStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PickupSource, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppMode, int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PickupItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PickupItemsTable,
          PickupItem,
          $$PickupItemsTableFilterComposer,
          $$PickupItemsTableOrderingComposer,
          $$PickupItemsTableAnnotationComposer,
          $$PickupItemsTableCreateCompanionBuilder,
          $$PickupItemsTableUpdateCompanionBuilder,
          (
            PickupItem,
            BaseReferences<_$AppDatabase, $PickupItemsTable, PickupItem>,
          ),
          PickupItem,
          PrefetchHooks Function()
        > {
  $$PickupItemsTableTableManager(_$AppDatabase db, $PickupItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PickupItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PickupItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PickupItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String?> stationName = const Value.absent(),
                Value<DateTime?> expireAt = const Value.absent(),
                Value<PickupStatus> status = const Value.absent(),
                Value<PickupSource> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<AppMode> mode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PickupItemsCompanion(
                id: id,
                code: code,
                stationName: stationName,
                expireAt: expireAt,
                status: status,
                source: source,
                note: note,
                mode: mode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                Value<String?> stationName = const Value.absent(),
                Value<DateTime?> expireAt = const Value.absent(),
                Value<PickupStatus> status = const Value.absent(),
                Value<PickupSource> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<AppMode> mode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PickupItemsCompanion.insert(
                id: id,
                code: code,
                stationName: stationName,
                expireAt: expireAt,
                status: status,
                source: source,
                note: note,
                mode: mode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PickupItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PickupItemsTable,
      PickupItem,
      $$PickupItemsTableFilterComposer,
      $$PickupItemsTableOrderingComposer,
      $$PickupItemsTableAnnotationComposer,
      $$PickupItemsTableCreateCompanionBuilder,
      $$PickupItemsTableUpdateCompanionBuilder,
      (
        PickupItem,
        BaseReferences<_$AppDatabase, $PickupItemsTable, PickupItem>,
      ),
      PickupItem,
      PrefetchHooks Function()
    >;
typedef $$TemplateRulesTableCreateCompanionBuilder =
    TemplateRulesCompanion Function({
      Value<int> id,
      Value<String?> name,
      required String sampleText,
      required String rulePayload,
      Value<bool> isEnabled,
      Value<AppMode> mode,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TemplateRulesTableUpdateCompanionBuilder =
    TemplateRulesCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String> sampleText,
      Value<String> rulePayload,
      Value<bool> isEnabled,
      Value<AppMode> mode,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$TemplateRulesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplateRulesTable> {
  $$TemplateRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sampleText => $composableBuilder(
    column: $table.sampleText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rulePayload => $composableBuilder(
    column: $table.rulePayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppMode, AppMode, int> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TemplateRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplateRulesTable> {
  $$TemplateRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sampleText => $composableBuilder(
    column: $table.sampleText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rulePayload => $composableBuilder(
    column: $table.rulePayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TemplateRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplateRulesTable> {
  $$TemplateRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sampleText => $composableBuilder(
    column: $table.sampleText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rulePayload => $composableBuilder(
    column: $table.rulePayload,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppMode, int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TemplateRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplateRulesTable,
          TemplateRuleRow,
          $$TemplateRulesTableFilterComposer,
          $$TemplateRulesTableOrderingComposer,
          $$TemplateRulesTableAnnotationComposer,
          $$TemplateRulesTableCreateCompanionBuilder,
          $$TemplateRulesTableUpdateCompanionBuilder,
          (
            TemplateRuleRow,
            BaseReferences<_$AppDatabase, $TemplateRulesTable, TemplateRuleRow>,
          ),
          TemplateRuleRow,
          PrefetchHooks Function()
        > {
  $$TemplateRulesTableTableManager(_$AppDatabase db, $TemplateRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplateRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplateRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplateRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> sampleText = const Value.absent(),
                Value<String> rulePayload = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<AppMode> mode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TemplateRulesCompanion(
                id: id,
                name: name,
                sampleText: sampleText,
                rulePayload: rulePayload,
                isEnabled: isEnabled,
                mode: mode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                required String sampleText,
                required String rulePayload,
                Value<bool> isEnabled = const Value.absent(),
                Value<AppMode> mode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TemplateRulesCompanion.insert(
                id: id,
                name: name,
                sampleText: sampleText,
                rulePayload: rulePayload,
                isEnabled: isEnabled,
                mode: mode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TemplateRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplateRulesTable,
      TemplateRuleRow,
      $$TemplateRulesTableFilterComposer,
      $$TemplateRulesTableOrderingComposer,
      $$TemplateRulesTableAnnotationComposer,
      $$TemplateRulesTableCreateCompanionBuilder,
      $$TemplateRulesTableUpdateCompanionBuilder,
      (
        TemplateRuleRow,
        BaseReferences<_$AppDatabase, $TemplateRulesTable, TemplateRuleRow>,
      ),
      TemplateRuleRow,
      PrefetchHooks Function()
    >;
typedef $$ReminderSettingsTableCreateCompanionBuilder =
    ReminderSettingsCompanion Function({
      Value<int> id,
      Value<bool> isEnabled,
      Value<int?> remindBeforeMinutes,
      Value<int?> fixedTimeMinutes,
      Value<int?> quietHoursStartMinutes,
      Value<int?> quietHoursEndMinutes,
      Value<AppMode> mode,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ReminderSettingsTableUpdateCompanionBuilder =
    ReminderSettingsCompanion Function({
      Value<int> id,
      Value<bool> isEnabled,
      Value<int?> remindBeforeMinutes,
      Value<int?> fixedTimeMinutes,
      Value<int?> quietHoursStartMinutes,
      Value<int?> quietHoursEndMinutes,
      Value<AppMode> mode,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ReminderSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remindBeforeMinutes => $composableBuilder(
    column: $table.remindBeforeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fixedTimeMinutes => $composableBuilder(
    column: $table.fixedTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppMode, AppMode, int> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReminderSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remindBeforeMinutes => $composableBuilder(
    column: $table.remindBeforeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fixedTimeMinutes => $composableBuilder(
    column: $table.fixedTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReminderSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<int> get remindBeforeMinutes => $composableBuilder(
    column: $table.remindBeforeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fixedTimeMinutes => $composableBuilder(
    column: $table.fixedTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AppMode, int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReminderSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderSettingsTable,
          ReminderSettingRow,
          $$ReminderSettingsTableFilterComposer,
          $$ReminderSettingsTableOrderingComposer,
          $$ReminderSettingsTableAnnotationComposer,
          $$ReminderSettingsTableCreateCompanionBuilder,
          $$ReminderSettingsTableUpdateCompanionBuilder,
          (
            ReminderSettingRow,
            BaseReferences<
              _$AppDatabase,
              $ReminderSettingsTable,
              ReminderSettingRow
            >,
          ),
          ReminderSettingRow,
          PrefetchHooks Function()
        > {
  $$ReminderSettingsTableTableManager(
    _$AppDatabase db,
    $ReminderSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int?> remindBeforeMinutes = const Value.absent(),
                Value<int?> fixedTimeMinutes = const Value.absent(),
                Value<int?> quietHoursStartMinutes = const Value.absent(),
                Value<int?> quietHoursEndMinutes = const Value.absent(),
                Value<AppMode> mode = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderSettingsCompanion(
                id: id,
                isEnabled: isEnabled,
                remindBeforeMinutes: remindBeforeMinutes,
                fixedTimeMinutes: fixedTimeMinutes,
                quietHoursStartMinutes: quietHoursStartMinutes,
                quietHoursEndMinutes: quietHoursEndMinutes,
                mode: mode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int?> remindBeforeMinutes = const Value.absent(),
                Value<int?> fixedTimeMinutes = const Value.absent(),
                Value<int?> quietHoursStartMinutes = const Value.absent(),
                Value<int?> quietHoursEndMinutes = const Value.absent(),
                Value<AppMode> mode = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderSettingsCompanion.insert(
                id: id,
                isEnabled: isEnabled,
                remindBeforeMinutes: remindBeforeMinutes,
                fixedTimeMinutes: fixedTimeMinutes,
                quietHoursStartMinutes: quietHoursStartMinutes,
                quietHoursEndMinutes: quietHoursEndMinutes,
                mode: mode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReminderSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderSettingsTable,
      ReminderSettingRow,
      $$ReminderSettingsTableFilterComposer,
      $$ReminderSettingsTableOrderingComposer,
      $$ReminderSettingsTableAnnotationComposer,
      $$ReminderSettingsTableCreateCompanionBuilder,
      $$ReminderSettingsTableUpdateCompanionBuilder,
      (
        ReminderSettingRow,
        BaseReferences<
          _$AppDatabase,
          $ReminderSettingsTable,
          ReminderSettingRow
        >,
      ),
      ReminderSettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PickupItemsTableTableManager get pickupItems =>
      $$PickupItemsTableTableManager(_db, _db.pickupItems);
  $$TemplateRulesTableTableManager get templateRules =>
      $$TemplateRulesTableTableManager(_db, _db.templateRules);
  $$ReminderSettingsTableTableManager get reminderSettings =>
      $$ReminderSettingsTableTableManager(_db, _db.reminderSettings);
}
