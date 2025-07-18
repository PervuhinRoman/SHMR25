// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_database.dart';

// ignore_for_file: type=lint
class $TransactionResponseDBTable extends TransactionResponseDB
    with TableInfo<$TransactionResponseDBTable, TransactionResponseDBData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionResponseDBTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'REFERENCES account_brief_db(id)',
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'REFERENCES category_db(id)',
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    categoryId,
    amount,
    transactionDate,
    comment,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_response_d_b';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionResponseDBData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionResponseDBData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionResponseDBData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      accountId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}account_id'],
          )!,
      categoryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}category_id'],
          )!,
      amount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}amount'],
          )!,
      transactionDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}transaction_date'],
          )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $TransactionResponseDBTable createAlias(String alias) {
    return $TransactionResponseDBTable(attachedDatabase, alias);
  }
}

class TransactionResponseDBData extends DataClass
    implements Insertable<TransactionResponseDBData> {
  final int id;
  final int accountId;
  final int categoryId;
  final String amount;
  final DateTime transactionDate;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TransactionResponseDBData({
    required this.id,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.transactionDate,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['category_id'] = Variable<int>(categoryId);
    map['amount'] = Variable<String>(amount);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionResponseDBCompanion toCompanion(bool nullToAbsent) {
    return TransactionResponseDBCompanion(
      id: Value(id),
      accountId: Value(accountId),
      categoryId: Value(categoryId),
      amount: Value(amount),
      transactionDate: Value(transactionDate),
      comment:
          comment == null && nullToAbsent
              ? const Value.absent()
              : Value(comment),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TransactionResponseDBData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionResponseDBData(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      amount: serializer.fromJson<String>(json['amount']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      comment: serializer.fromJson<String?>(json['comment']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'categoryId': serializer.toJson<int>(categoryId),
      'amount': serializer.toJson<String>(amount),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'comment': serializer.toJson<String?>(comment),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TransactionResponseDBData copyWith({
    int? id,
    int? accountId,
    int? categoryId,
    String? amount,
    DateTime? transactionDate,
    Value<String?> comment = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TransactionResponseDBData(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    categoryId: categoryId ?? this.categoryId,
    amount: amount ?? this.amount,
    transactionDate: transactionDate ?? this.transactionDate,
    comment: comment.present ? comment.value : this.comment,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TransactionResponseDBData copyWithCompanion(
    TransactionResponseDBCompanion data,
  ) {
    return TransactionResponseDBData(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      amount: data.amount.present ? data.amount.value : this.amount,
      transactionDate:
          data.transactionDate.present
              ? data.transactionDate.value
              : this.transactionDate,
      comment: data.comment.present ? data.comment.value : this.comment,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionResponseDBData(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    categoryId,
    amount,
    transactionDate,
    comment,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionResponseDBData &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.amount == this.amount &&
          other.transactionDate == this.transactionDate &&
          other.comment == this.comment &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionResponseDBCompanion
    extends UpdateCompanion<TransactionResponseDBData> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int> categoryId;
  final Value<String> amount;
  final Value<DateTime> transactionDate;
  final Value<String?> comment;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TransactionResponseDBCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amount = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransactionResponseDBCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required int categoryId,
    required String amount,
    required DateTime transactionDate,
    this.comment = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : accountId = Value(accountId),
       categoryId = Value(categoryId),
       amount = Value(amount),
       transactionDate = Value(transactionDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TransactionResponseDBData> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? categoryId,
    Expression<String>? amount,
    Expression<DateTime>? transactionDate,
    Expression<String>? comment,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (amount != null) 'amount': amount,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransactionResponseDBCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<int>? categoryId,
    Value<String>? amount,
    Value<DateTime>? transactionDate,
    Value<String?>? comment,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TransactionResponseDBCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      comment: comment ?? this.comment,
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
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
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
    return (StringBuffer('TransactionResponseDBCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AccountBriefDBTable extends AccountBriefDB
    with TableInfo<$AccountBriefDBTable, AccountBriefDBData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountBriefDBTable(this.attachedDatabase, [this._alias]);
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<String> balance = GeneratedColumn<String>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, balance, currency];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_brief_d_b';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountBriefDBData> instance, {
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
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountBriefDBData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountBriefDBData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      balance:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}balance'],
          )!,
      currency:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}currency'],
          )!,
    );
  }

  @override
  $AccountBriefDBTable createAlias(String alias) {
    return $AccountBriefDBTable(attachedDatabase, alias);
  }
}

class AccountBriefDBData extends DataClass
    implements Insertable<AccountBriefDBData> {
  final int id;
  final String name;
  final String balance;
  final String currency;
  const AccountBriefDBData({
    required this.id,
    required this.name,
    required this.balance,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['balance'] = Variable<String>(balance);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  AccountBriefDBCompanion toCompanion(bool nullToAbsent) {
    return AccountBriefDBCompanion(
      id: Value(id),
      name: Value(name),
      balance: Value(balance),
      currency: Value(currency),
    );
  }

  factory AccountBriefDBData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountBriefDBData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      balance: serializer.fromJson<String>(json['balance']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'balance': serializer.toJson<String>(balance),
      'currency': serializer.toJson<String>(currency),
    };
  }

  AccountBriefDBData copyWith({
    int? id,
    String? name,
    String? balance,
    String? currency,
  }) => AccountBriefDBData(
    id: id ?? this.id,
    name: name ?? this.name,
    balance: balance ?? this.balance,
    currency: currency ?? this.currency,
  );
  AccountBriefDBData copyWithCompanion(AccountBriefDBCompanion data) {
    return AccountBriefDBData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      balance: data.balance.present ? data.balance.value : this.balance,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountBriefDBData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, balance, currency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountBriefDBData &&
          other.id == this.id &&
          other.name == this.name &&
          other.balance == this.balance &&
          other.currency == this.currency);
}

class AccountBriefDBCompanion extends UpdateCompanion<AccountBriefDBData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> balance;
  final Value<String> currency;
  const AccountBriefDBCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
  });
  AccountBriefDBCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String balance,
    required String currency,
  }) : name = Value(name),
       balance = Value(balance),
       currency = Value(currency);
  static Insertable<AccountBriefDBData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? balance,
    Expression<String>? currency,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (balance != null) 'balance': balance,
      if (currency != null) 'currency': currency,
    });
  }

  AccountBriefDBCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? balance,
    Value<String>? currency,
  }) {
    return AccountBriefDBCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
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
    if (balance.present) {
      map['balance'] = Variable<String>(balance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountBriefDBCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }
}

class $CategoryDBTable extends CategoryDB
    with TableInfo<$CategoryDBTable, CategoryDBData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryDBTable(this.attachedDatabase, [this._alias]);
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isIncomeMeta = const VerificationMeta(
    'isIncome',
  );
  @override
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
    'is_income',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_income" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, emoji, isIncome];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_d_b';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryDBData> instance, {
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
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('is_income')) {
      context.handle(
        _isIncomeMeta,
        isIncome.isAcceptableOrUnknown(data['is_income']!, _isIncomeMeta),
      );
    } else if (isInserting) {
      context.missing(_isIncomeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryDBData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryDBData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      emoji:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}emoji'],
          )!,
      isIncome:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_income'],
          )!,
    );
  }

  @override
  $CategoryDBTable createAlias(String alias) {
    return $CategoryDBTable(attachedDatabase, alias);
  }
}

class CategoryDBData extends DataClass implements Insertable<CategoryDBData> {
  final int id;
  final String name;
  final String emoji;
  final bool isIncome;
  const CategoryDBData({
    required this.id,
    required this.name,
    required this.emoji,
    required this.isIncome,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['emoji'] = Variable<String>(emoji);
    map['is_income'] = Variable<bool>(isIncome);
    return map;
  }

  CategoryDBCompanion toCompanion(bool nullToAbsent) {
    return CategoryDBCompanion(
      id: Value(id),
      name: Value(name),
      emoji: Value(emoji),
      isIncome: Value(isIncome),
    );
  }

  factory CategoryDBData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryDBData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      emoji: serializer.fromJson<String>(json['emoji']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'emoji': serializer.toJson<String>(emoji),
      'isIncome': serializer.toJson<bool>(isIncome),
    };
  }

  CategoryDBData copyWith({
    int? id,
    String? name,
    String? emoji,
    bool? isIncome,
  }) => CategoryDBData(
    id: id ?? this.id,
    name: name ?? this.name,
    emoji: emoji ?? this.emoji,
    isIncome: isIncome ?? this.isIncome,
  );
  CategoryDBData copyWithCompanion(CategoryDBCompanion data) {
    return CategoryDBData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      isIncome: data.isIncome.present ? data.isIncome.value : this.isIncome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryDBData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('isIncome: $isIncome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, emoji, isIncome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryDBData &&
          other.id == this.id &&
          other.name == this.name &&
          other.emoji == this.emoji &&
          other.isIncome == this.isIncome);
}

class CategoryDBCompanion extends UpdateCompanion<CategoryDBData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> emoji;
  final Value<bool> isIncome;
  const CategoryDBCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.emoji = const Value.absent(),
    this.isIncome = const Value.absent(),
  });
  CategoryDBCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String emoji,
    required bool isIncome,
  }) : name = Value(name),
       emoji = Value(emoji),
       isIncome = Value(isIncome);
  static Insertable<CategoryDBData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? emoji,
    Expression<bool>? isIncome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (emoji != null) 'emoji': emoji,
      if (isIncome != null) 'is_income': isIncome,
    });
  }

  CategoryDBCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? emoji,
    Value<bool>? isIncome,
  }) {
    return CategoryDBCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      isIncome: isIncome ?? this.isIncome,
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
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryDBCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('isIncome: $isIncome')
          ..write(')'))
        .toString();
  }
}

class $TransactionDiffDBTable extends TransactionDiffDB
    with TableInfo<$TransactionDiffDBTable, TransactionDiffDBData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionDiffDBTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionJsonMeta = const VerificationMeta(
    'transactionJson',
  );
  @override
  late final GeneratedColumn<String> transactionJson = GeneratedColumn<String>(
    'transaction_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operation,
    transactionJson,
    timestamp,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_diff_d_b';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionDiffDBData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('transaction_json')) {
      context.handle(
        _transactionJsonMeta,
        transactionJson.isAcceptableOrUnknown(
          data['transaction_json']!,
          _transactionJsonMeta,
        ),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionDiffDBData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionDiffDBData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      operation:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}operation'],
          )!,
      transactionJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_json'],
      ),
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      syncStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sync_status'],
          )!,
    );
  }

  @override
  $TransactionDiffDBTable createAlias(String alias) {
    return $TransactionDiffDBTable(attachedDatabase, alias);
  }
}

class TransactionDiffDBData extends DataClass
    implements Insertable<TransactionDiffDBData> {
  final int id;
  final String operation;
  final String? transactionJson;
  final DateTime timestamp;
  final String syncStatus;
  const TransactionDiffDBData({
    required this.id,
    required this.operation,
    this.transactionJson,
    required this.timestamp,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || transactionJson != null) {
      map['transaction_json'] = Variable<String>(transactionJson);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  TransactionDiffDBCompanion toCompanion(bool nullToAbsent) {
    return TransactionDiffDBCompanion(
      id: Value(id),
      operation: Value(operation),
      transactionJson:
          transactionJson == null && nullToAbsent
              ? const Value.absent()
              : Value(transactionJson),
      timestamp: Value(timestamp),
      syncStatus: Value(syncStatus),
    );
  }

  factory TransactionDiffDBData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionDiffDBData(
      id: serializer.fromJson<int>(json['id']),
      operation: serializer.fromJson<String>(json['operation']),
      transactionJson: serializer.fromJson<String?>(json['transactionJson']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operation': serializer.toJson<String>(operation),
      'transactionJson': serializer.toJson<String?>(transactionJson),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  TransactionDiffDBData copyWith({
    int? id,
    String? operation,
    Value<String?> transactionJson = const Value.absent(),
    DateTime? timestamp,
    String? syncStatus,
  }) => TransactionDiffDBData(
    id: id ?? this.id,
    operation: operation ?? this.operation,
    transactionJson:
        transactionJson.present ? transactionJson.value : this.transactionJson,
    timestamp: timestamp ?? this.timestamp,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  TransactionDiffDBData copyWithCompanion(TransactionDiffDBCompanion data) {
    return TransactionDiffDBData(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      transactionJson:
          data.transactionJson.present
              ? data.transactionJson.value
              : this.transactionJson,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionDiffDBData(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('transactionJson: $transactionJson, ')
          ..write('timestamp: $timestamp, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, operation, transactionJson, timestamp, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionDiffDBData &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.transactionJson == this.transactionJson &&
          other.timestamp == this.timestamp &&
          other.syncStatus == this.syncStatus);
}

class TransactionDiffDBCompanion
    extends UpdateCompanion<TransactionDiffDBData> {
  final Value<int> id;
  final Value<String> operation;
  final Value<String?> transactionJson;
  final Value<DateTime> timestamp;
  final Value<String> syncStatus;
  const TransactionDiffDBCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.transactionJson = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.syncStatus = const Value.absent(),
  });
  TransactionDiffDBCompanion.insert({
    this.id = const Value.absent(),
    required String operation,
    this.transactionJson = const Value.absent(),
    required DateTime timestamp,
    this.syncStatus = const Value.absent(),
  }) : operation = Value(operation),
       timestamp = Value(timestamp);
  static Insertable<TransactionDiffDBData> custom({
    Expression<int>? id,
    Expression<String>? operation,
    Expression<String>? transactionJson,
    Expression<DateTime>? timestamp,
    Expression<String>? syncStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (transactionJson != null) 'transaction_json': transactionJson,
      if (timestamp != null) 'timestamp': timestamp,
      if (syncStatus != null) 'sync_status': syncStatus,
    });
  }

  TransactionDiffDBCompanion copyWith({
    Value<int>? id,
    Value<String>? operation,
    Value<String?>? transactionJson,
    Value<DateTime>? timestamp,
    Value<String>? syncStatus,
  }) {
    return TransactionDiffDBCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      transactionJson: transactionJson ?? this.transactionJson,
      timestamp: timestamp ?? this.timestamp,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (transactionJson.present) {
      map['transaction_json'] = Variable<String>(transactionJson.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionDiffDBCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('transactionJson: $transactionJson, ')
          ..write('timestamp: $timestamp, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionResponseDBTable transactionResponseDB =
      $TransactionResponseDBTable(this);
  late final $AccountBriefDBTable accountBriefDB = $AccountBriefDBTable(this);
  late final $CategoryDBTable categoryDB = $CategoryDBTable(this);
  late final $TransactionDiffDBTable transactionDiffDB =
      $TransactionDiffDBTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    transactionResponseDB,
    accountBriefDB,
    categoryDB,
    transactionDiffDB,
  ];
}

typedef $$TransactionResponseDBTableCreateCompanionBuilder =
    TransactionResponseDBCompanion Function({
      Value<int> id,
      required int accountId,
      required int categoryId,
      required String amount,
      required DateTime transactionDate,
      Value<String?> comment,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$TransactionResponseDBTableUpdateCompanionBuilder =
    TransactionResponseDBCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<int> categoryId,
      Value<String> amount,
      Value<DateTime> transactionDate,
      Value<String?> comment,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$TransactionResponseDBTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionResponseDBTable> {
  $$TransactionResponseDBTableFilterComposer({
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

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
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

class $$TransactionResponseDBTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionResponseDBTable> {
  $$TransactionResponseDBTableOrderingComposer({
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

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
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

class $$TransactionResponseDBTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionResponseDBTable> {
  $$TransactionResponseDBTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionResponseDBTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionResponseDBTable,
          TransactionResponseDBData,
          $$TransactionResponseDBTableFilterComposer,
          $$TransactionResponseDBTableOrderingComposer,
          $$TransactionResponseDBTableAnnotationComposer,
          $$TransactionResponseDBTableCreateCompanionBuilder,
          $$TransactionResponseDBTableUpdateCompanionBuilder,
          (
            TransactionResponseDBData,
            BaseReferences<
              _$AppDatabase,
              $TransactionResponseDBTable,
              TransactionResponseDBData
            >,
          ),
          TransactionResponseDBData,
          PrefetchHooks Function()
        > {
  $$TransactionResponseDBTableTableManager(
    _$AppDatabase db,
    $TransactionResponseDBTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TransactionResponseDBTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TransactionResponseDBTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TransactionResponseDBTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String> amount = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionResponseDBCompanion(
                id: id,
                accountId: accountId,
                categoryId: categoryId,
                amount: amount,
                transactionDate: transactionDate,
                comment: comment,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required int categoryId,
                required String amount,
                required DateTime transactionDate,
                Value<String?> comment = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => TransactionResponseDBCompanion.insert(
                id: id,
                accountId: accountId,
                categoryId: categoryId,
                amount: amount,
                transactionDate: transactionDate,
                comment: comment,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionResponseDBTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionResponseDBTable,
      TransactionResponseDBData,
      $$TransactionResponseDBTableFilterComposer,
      $$TransactionResponseDBTableOrderingComposer,
      $$TransactionResponseDBTableAnnotationComposer,
      $$TransactionResponseDBTableCreateCompanionBuilder,
      $$TransactionResponseDBTableUpdateCompanionBuilder,
      (
        TransactionResponseDBData,
        BaseReferences<
          _$AppDatabase,
          $TransactionResponseDBTable,
          TransactionResponseDBData
        >,
      ),
      TransactionResponseDBData,
      PrefetchHooks Function()
    >;
typedef $$AccountBriefDBTableCreateCompanionBuilder =
    AccountBriefDBCompanion Function({
      Value<int> id,
      required String name,
      required String balance,
      required String currency,
    });
typedef $$AccountBriefDBTableUpdateCompanionBuilder =
    AccountBriefDBCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> balance,
      Value<String> currency,
    });

class $$AccountBriefDBTableFilterComposer
    extends Composer<_$AppDatabase, $AccountBriefDBTable> {
  $$AccountBriefDBTableFilterComposer({
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

  ColumnFilters<String> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountBriefDBTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountBriefDBTable> {
  $$AccountBriefDBTableOrderingComposer({
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

  ColumnOrderings<String> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountBriefDBTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountBriefDBTable> {
  $$AccountBriefDBTableAnnotationComposer({
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

  GeneratedColumn<String> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);
}

class $$AccountBriefDBTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountBriefDBTable,
          AccountBriefDBData,
          $$AccountBriefDBTableFilterComposer,
          $$AccountBriefDBTableOrderingComposer,
          $$AccountBriefDBTableAnnotationComposer,
          $$AccountBriefDBTableCreateCompanionBuilder,
          $$AccountBriefDBTableUpdateCompanionBuilder,
          (
            AccountBriefDBData,
            BaseReferences<
              _$AppDatabase,
              $AccountBriefDBTable,
              AccountBriefDBData
            >,
          ),
          AccountBriefDBData,
          PrefetchHooks Function()
        > {
  $$AccountBriefDBTableTableManager(
    _$AppDatabase db,
    $AccountBriefDBTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AccountBriefDBTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$AccountBriefDBTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AccountBriefDBTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> balance = const Value.absent(),
                Value<String> currency = const Value.absent(),
              }) => AccountBriefDBCompanion(
                id: id,
                name: name,
                balance: balance,
                currency: currency,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String balance,
                required String currency,
              }) => AccountBriefDBCompanion.insert(
                id: id,
                name: name,
                balance: balance,
                currency: currency,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountBriefDBTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountBriefDBTable,
      AccountBriefDBData,
      $$AccountBriefDBTableFilterComposer,
      $$AccountBriefDBTableOrderingComposer,
      $$AccountBriefDBTableAnnotationComposer,
      $$AccountBriefDBTableCreateCompanionBuilder,
      $$AccountBriefDBTableUpdateCompanionBuilder,
      (
        AccountBriefDBData,
        BaseReferences<_$AppDatabase, $AccountBriefDBTable, AccountBriefDBData>,
      ),
      AccountBriefDBData,
      PrefetchHooks Function()
    >;
typedef $$CategoryDBTableCreateCompanionBuilder =
    CategoryDBCompanion Function({
      Value<int> id,
      required String name,
      required String emoji,
      required bool isIncome,
    });
typedef $$CategoryDBTableUpdateCompanionBuilder =
    CategoryDBCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> emoji,
      Value<bool> isIncome,
    });

class $$CategoryDBTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryDBTable> {
  $$CategoryDBTableFilterComposer({
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

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoryDBTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryDBTable> {
  $$CategoryDBTableOrderingComposer({
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

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoryDBTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryDBTable> {
  $$CategoryDBTableAnnotationComposer({
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

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<bool> get isIncome =>
      $composableBuilder(column: $table.isIncome, builder: (column) => column);
}

class $$CategoryDBTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryDBTable,
          CategoryDBData,
          $$CategoryDBTableFilterComposer,
          $$CategoryDBTableOrderingComposer,
          $$CategoryDBTableAnnotationComposer,
          $$CategoryDBTableCreateCompanionBuilder,
          $$CategoryDBTableUpdateCompanionBuilder,
          (
            CategoryDBData,
            BaseReferences<_$AppDatabase, $CategoryDBTable, CategoryDBData>,
          ),
          CategoryDBData,
          PrefetchHooks Function()
        > {
  $$CategoryDBTableTableManager(_$AppDatabase db, $CategoryDBTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CategoryDBTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CategoryDBTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CategoryDBTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<bool> isIncome = const Value.absent(),
              }) => CategoryDBCompanion(
                id: id,
                name: name,
                emoji: emoji,
                isIncome: isIncome,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String emoji,
                required bool isIncome,
              }) => CategoryDBCompanion.insert(
                id: id,
                name: name,
                emoji: emoji,
                isIncome: isIncome,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoryDBTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryDBTable,
      CategoryDBData,
      $$CategoryDBTableFilterComposer,
      $$CategoryDBTableOrderingComposer,
      $$CategoryDBTableAnnotationComposer,
      $$CategoryDBTableCreateCompanionBuilder,
      $$CategoryDBTableUpdateCompanionBuilder,
      (
        CategoryDBData,
        BaseReferences<_$AppDatabase, $CategoryDBTable, CategoryDBData>,
      ),
      CategoryDBData,
      PrefetchHooks Function()
    >;
typedef $$TransactionDiffDBTableCreateCompanionBuilder =
    TransactionDiffDBCompanion Function({
      Value<int> id,
      required String operation,
      Value<String?> transactionJson,
      required DateTime timestamp,
      Value<String> syncStatus,
    });
typedef $$TransactionDiffDBTableUpdateCompanionBuilder =
    TransactionDiffDBCompanion Function({
      Value<int> id,
      Value<String> operation,
      Value<String?> transactionJson,
      Value<DateTime> timestamp,
      Value<String> syncStatus,
    });

class $$TransactionDiffDBTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionDiffDBTable> {
  $$TransactionDiffDBTableFilterComposer({
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

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionJson => $composableBuilder(
    column: $table.transactionJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionDiffDBTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionDiffDBTable> {
  $$TransactionDiffDBTableOrderingComposer({
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

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionJson => $composableBuilder(
    column: $table.transactionJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionDiffDBTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionDiffDBTable> {
  $$TransactionDiffDBTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get transactionJson => $composableBuilder(
    column: $table.transactionJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$TransactionDiffDBTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionDiffDBTable,
          TransactionDiffDBData,
          $$TransactionDiffDBTableFilterComposer,
          $$TransactionDiffDBTableOrderingComposer,
          $$TransactionDiffDBTableAnnotationComposer,
          $$TransactionDiffDBTableCreateCompanionBuilder,
          $$TransactionDiffDBTableUpdateCompanionBuilder,
          (
            TransactionDiffDBData,
            BaseReferences<
              _$AppDatabase,
              $TransactionDiffDBTable,
              TransactionDiffDBData
            >,
          ),
          TransactionDiffDBData,
          PrefetchHooks Function()
        > {
  $$TransactionDiffDBTableTableManager(
    _$AppDatabase db,
    $TransactionDiffDBTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TransactionDiffDBTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TransactionDiffDBTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TransactionDiffDBTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String?> transactionJson = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
              }) => TransactionDiffDBCompanion(
                id: id,
                operation: operation,
                transactionJson: transactionJson,
                timestamp: timestamp,
                syncStatus: syncStatus,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String operation,
                Value<String?> transactionJson = const Value.absent(),
                required DateTime timestamp,
                Value<String> syncStatus = const Value.absent(),
              }) => TransactionDiffDBCompanion.insert(
                id: id,
                operation: operation,
                transactionJson: transactionJson,
                timestamp: timestamp,
                syncStatus: syncStatus,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionDiffDBTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionDiffDBTable,
      TransactionDiffDBData,
      $$TransactionDiffDBTableFilterComposer,
      $$TransactionDiffDBTableOrderingComposer,
      $$TransactionDiffDBTableAnnotationComposer,
      $$TransactionDiffDBTableCreateCompanionBuilder,
      $$TransactionDiffDBTableUpdateCompanionBuilder,
      (
        TransactionDiffDBData,
        BaseReferences<
          _$AppDatabase,
          $TransactionDiffDBTable,
          TransactionDiffDBData
        >,
      ),
      TransactionDiffDBData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionResponseDBTableTableManager get transactionResponseDB =>
      $$TransactionResponseDBTableTableManager(_db, _db.transactionResponseDB);
  $$AccountBriefDBTableTableManager get accountBriefDB =>
      $$AccountBriefDBTableTableManager(_db, _db.accountBriefDB);
  $$CategoryDBTableTableManager get categoryDB =>
      $$CategoryDBTableTableManager(_db, _db.categoryDB);
  $$TransactionDiffDBTableTableManager get transactionDiffDB =>
      $$TransactionDiffDBTableTableManager(_db, _db.transactionDiffDB);
}
