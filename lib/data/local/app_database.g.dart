// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TransactionType>($TransactionsTable.$convertertype);
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMethod, String> method =
      GeneratedColumn<String>(
        'method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PaymentMethod>($TransactionsTable.$convertermethod);
  static const VerificationMeta _accountMeta = const VerificationMeta(
    'account',
  );
  @override
  late final GeneratedColumn<String> account = GeneratedColumn<String>(
    'account',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _availableBalanceMeta = const VerificationMeta(
    'availableBalance',
  );
  @override
  late final GeneratedColumn<double> availableBalance = GeneratedColumn<double>(
    'available_balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawSmsMeta = const VerificationMeta('rawSms');
  @override
  late final GeneratedColumn<String> rawSms = GeneratedColumn<String>(
    'raw_sms',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateNameMeta = const VerificationMeta(
    'templateName',
  );
  @override
  late final GeneratedColumn<String> templateName = GeneratedColumn<String>(
    'template_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isSampleMeta = const VerificationMeta(
    'isSample',
  );
  @override
  late final GeneratedColumn<bool> isSample = GeneratedColumn<bool>(
    'is_sample',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_sample" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    type,
    merchant,
    date,
    method,
    account,
    availableBalance,
    rawSms,
    bankName,
    templateName,
    isVerified,
    isSample,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('account')) {
      context.handle(
        _accountMeta,
        account.isAcceptableOrUnknown(data['account']!, _accountMeta),
      );
    }
    if (data.containsKey('available_balance')) {
      context.handle(
        _availableBalanceMeta,
        availableBalance.isAcceptableOrUnknown(
          data['available_balance']!,
          _availableBalanceMeta,
        ),
      );
    }
    if (data.containsKey('raw_sms')) {
      context.handle(
        _rawSmsMeta,
        rawSms.isAcceptableOrUnknown(data['raw_sms']!, _rawSmsMeta),
      );
    } else if (isInserting) {
      context.missing(_rawSmsMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('template_name')) {
      context.handle(
        _templateNameMeta,
        templateName.isAcceptableOrUnknown(
          data['template_name']!,
          _templateNameMeta,
        ),
      );
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
      );
    }
    if (data.containsKey('is_sample')) {
      context.handle(
        _isSampleMeta,
        isSample.isAcceptableOrUnknown(data['is_sample']!, _isSampleMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      method: $TransactionsTable.$convertermethod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}method'],
        )!,
      ),
      account: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account'],
      ),
      availableBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}available_balance'],
      ),
      rawSms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_sms'],
      )!,
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      )!,
      templateName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_name'],
      ),
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_verified'],
      )!,
      isSample: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_sample'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<PaymentMethod, String, String> $convertermethod =
      const EnumNameConverter<PaymentMethod>(PaymentMethod.values);
}

class TransactionEntry extends DataClass
    implements Insertable<TransactionEntry> {
  final int id;
  final double amount;
  final TransactionType type;
  final String? merchant;
  final DateTime date;
  final PaymentMethod method;
  final String? account;
  final double? availableBalance;
  final String rawSms;
  final String bankName;
  final String? templateName;
  final bool isVerified;
  final bool isSample;
  final String? description;
  const TransactionEntry({
    required this.id,
    required this.amount,
    required this.type,
    this.merchant,
    required this.date,
    required this.method,
    this.account,
    this.availableBalance,
    required this.rawSms,
    required this.bankName,
    this.templateName,
    required this.isVerified,
    required this.isSample,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    map['date'] = Variable<DateTime>(date);
    {
      map['method'] = Variable<String>(
        $TransactionsTable.$convertermethod.toSql(method),
      );
    }
    if (!nullToAbsent || account != null) {
      map['account'] = Variable<String>(account);
    }
    if (!nullToAbsent || availableBalance != null) {
      map['available_balance'] = Variable<double>(availableBalance);
    }
    map['raw_sms'] = Variable<String>(rawSms);
    map['bank_name'] = Variable<String>(bankName);
    if (!nullToAbsent || templateName != null) {
      map['template_name'] = Variable<String>(templateName);
    }
    map['is_verified'] = Variable<bool>(isVerified);
    map['is_sample'] = Variable<bool>(isSample);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      type: Value(type),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      date: Value(date),
      method: Value(method),
      account: account == null && nullToAbsent
          ? const Value.absent()
          : Value(account),
      availableBalance: availableBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(availableBalance),
      rawSms: Value(rawSms),
      bankName: Value(bankName),
      templateName: templateName == null && nullToAbsent
          ? const Value.absent()
          : Value(templateName),
      isVerified: Value(isVerified),
      isSample: Value(isSample),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory TransactionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionEntry(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      merchant: serializer.fromJson<String?>(json['merchant']),
      date: serializer.fromJson<DateTime>(json['date']),
      method: $TransactionsTable.$convertermethod.fromJson(
        serializer.fromJson<String>(json['method']),
      ),
      account: serializer.fromJson<String?>(json['account']),
      availableBalance: serializer.fromJson<double?>(json['availableBalance']),
      rawSms: serializer.fromJson<String>(json['rawSms']),
      bankName: serializer.fromJson<String>(json['bankName']),
      templateName: serializer.fromJson<String?>(json['templateName']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      isSample: serializer.fromJson<bool>(json['isSample']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'merchant': serializer.toJson<String?>(merchant),
      'date': serializer.toJson<DateTime>(date),
      'method': serializer.toJson<String>(
        $TransactionsTable.$convertermethod.toJson(method),
      ),
      'account': serializer.toJson<String?>(account),
      'availableBalance': serializer.toJson<double?>(availableBalance),
      'rawSms': serializer.toJson<String>(rawSms),
      'bankName': serializer.toJson<String>(bankName),
      'templateName': serializer.toJson<String?>(templateName),
      'isVerified': serializer.toJson<bool>(isVerified),
      'isSample': serializer.toJson<bool>(isSample),
      'description': serializer.toJson<String?>(description),
    };
  }

  TransactionEntry copyWith({
    int? id,
    double? amount,
    TransactionType? type,
    Value<String?> merchant = const Value.absent(),
    DateTime? date,
    PaymentMethod? method,
    Value<String?> account = const Value.absent(),
    Value<double?> availableBalance = const Value.absent(),
    String? rawSms,
    String? bankName,
    Value<String?> templateName = const Value.absent(),
    bool? isVerified,
    bool? isSample,
    Value<String?> description = const Value.absent(),
  }) => TransactionEntry(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    merchant: merchant.present ? merchant.value : this.merchant,
    date: date ?? this.date,
    method: method ?? this.method,
    account: account.present ? account.value : this.account,
    availableBalance: availableBalance.present
        ? availableBalance.value
        : this.availableBalance,
    rawSms: rawSms ?? this.rawSms,
    bankName: bankName ?? this.bankName,
    templateName: templateName.present ? templateName.value : this.templateName,
    isVerified: isVerified ?? this.isVerified,
    isSample: isSample ?? this.isSample,
    description: description.present ? description.value : this.description,
  );
  TransactionEntry copyWithCompanion(TransactionsCompanion data) {
    return TransactionEntry(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      date: data.date.present ? data.date.value : this.date,
      method: data.method.present ? data.method.value : this.method,
      account: data.account.present ? data.account.value : this.account,
      availableBalance: data.availableBalance.present
          ? data.availableBalance.value
          : this.availableBalance,
      rawSms: data.rawSms.present ? data.rawSms.value : this.rawSms,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      templateName: data.templateName.present
          ? data.templateName.value
          : this.templateName,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      isSample: data.isSample.present ? data.isSample.value : this.isSample,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionEntry(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('merchant: $merchant, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('account: $account, ')
          ..write('availableBalance: $availableBalance, ')
          ..write('rawSms: $rawSms, ')
          ..write('bankName: $bankName, ')
          ..write('templateName: $templateName, ')
          ..write('isVerified: $isVerified, ')
          ..write('isSample: $isSample, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    type,
    merchant,
    date,
    method,
    account,
    availableBalance,
    rawSms,
    bankName,
    templateName,
    isVerified,
    isSample,
    description,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionEntry &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.merchant == this.merchant &&
          other.date == this.date &&
          other.method == this.method &&
          other.account == this.account &&
          other.availableBalance == this.availableBalance &&
          other.rawSms == this.rawSms &&
          other.bankName == this.bankName &&
          other.templateName == this.templateName &&
          other.isVerified == this.isVerified &&
          other.isSample == this.isSample &&
          other.description == this.description);
}

class TransactionsCompanion extends UpdateCompanion<TransactionEntry> {
  final Value<int> id;
  final Value<double> amount;
  final Value<TransactionType> type;
  final Value<String?> merchant;
  final Value<DateTime> date;
  final Value<PaymentMethod> method;
  final Value<String?> account;
  final Value<double?> availableBalance;
  final Value<String> rawSms;
  final Value<String> bankName;
  final Value<String?> templateName;
  final Value<bool> isVerified;
  final Value<bool> isSample;
  final Value<String?> description;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.merchant = const Value.absent(),
    this.date = const Value.absent(),
    this.method = const Value.absent(),
    this.account = const Value.absent(),
    this.availableBalance = const Value.absent(),
    this.rawSms = const Value.absent(),
    this.bankName = const Value.absent(),
    this.templateName = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isSample = const Value.absent(),
    this.description = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required TransactionType type,
    this.merchant = const Value.absent(),
    required DateTime date,
    required PaymentMethod method,
    this.account = const Value.absent(),
    this.availableBalance = const Value.absent(),
    required String rawSms,
    required String bankName,
    this.templateName = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isSample = const Value.absent(),
    this.description = const Value.absent(),
  }) : amount = Value(amount),
       type = Value(type),
       date = Value(date),
       method = Value(method),
       rawSms = Value(rawSms),
       bankName = Value(bankName);
  static Insertable<TransactionEntry> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? merchant,
    Expression<DateTime>? date,
    Expression<String>? method,
    Expression<String>? account,
    Expression<double>? availableBalance,
    Expression<String>? rawSms,
    Expression<String>? bankName,
    Expression<String>? templateName,
    Expression<bool>? isVerified,
    Expression<bool>? isSample,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (merchant != null) 'merchant': merchant,
      if (date != null) 'date': date,
      if (method != null) 'method': method,
      if (account != null) 'account': account,
      if (availableBalance != null) 'available_balance': availableBalance,
      if (rawSms != null) 'raw_sms': rawSms,
      if (bankName != null) 'bank_name': bankName,
      if (templateName != null) 'template_name': templateName,
      if (isVerified != null) 'is_verified': isVerified,
      if (isSample != null) 'is_sample': isSample,
      if (description != null) 'description': description,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<double>? amount,
    Value<TransactionType>? type,
    Value<String?>? merchant,
    Value<DateTime>? date,
    Value<PaymentMethod>? method,
    Value<String?>? account,
    Value<double?>? availableBalance,
    Value<String>? rawSms,
    Value<String>? bankName,
    Value<String?>? templateName,
    Value<bool>? isVerified,
    Value<bool>? isSample,
    Value<String?>? description,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      merchant: merchant ?? this.merchant,
      date: date ?? this.date,
      method: method ?? this.method,
      account: account ?? this.account,
      availableBalance: availableBalance ?? this.availableBalance,
      rawSms: rawSms ?? this.rawSms,
      bankName: bankName ?? this.bankName,
      templateName: templateName ?? this.templateName,
      isVerified: isVerified ?? this.isVerified,
      isSample: isSample ?? this.isSample,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(
        $TransactionsTable.$convertermethod.toSql(method.value),
      );
    }
    if (account.present) {
      map['account'] = Variable<String>(account.value);
    }
    if (availableBalance.present) {
      map['available_balance'] = Variable<double>(availableBalance.value);
    }
    if (rawSms.present) {
      map['raw_sms'] = Variable<String>(rawSms.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (templateName.present) {
      map['template_name'] = Variable<String>(templateName.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (isSample.present) {
      map['is_sample'] = Variable<bool>(isSample.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('merchant: $merchant, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('account: $account, ')
          ..write('availableBalance: $availableBalance, ')
          ..write('rawSms: $rawSms, ')
          ..write('bankName: $bankName, ')
          ..write('templateName: $templateName, ')
          ..write('isVerified: $isVerified, ')
          ..write('isSample: $isSample, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $SmsLogsTable extends SmsLogs with TableInfo<$SmsLogsTable, SmsLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmsLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, timestamp, sender, body];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sms_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmsLogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmsLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsLogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
    );
  }

  @override
  $SmsLogsTable createAlias(String alias) {
    return $SmsLogsTable(attachedDatabase, alias);
  }
}

class SmsLogEntry extends DataClass implements Insertable<SmsLogEntry> {
  final int id;
  final DateTime timestamp;
  final String sender;
  final String body;
  const SmsLogEntry({
    required this.id,
    required this.timestamp,
    required this.sender,
    required this.body,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['sender'] = Variable<String>(sender);
    map['body'] = Variable<String>(body);
    return map;
  }

  SmsLogsCompanion toCompanion(bool nullToAbsent) {
    return SmsLogsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      sender: Value(sender),
      body: Value(body),
    );
  }

  factory SmsLogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsLogEntry(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      sender: serializer.fromJson<String>(json['sender']),
      body: serializer.fromJson<String>(json['body']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'sender': serializer.toJson<String>(sender),
      'body': serializer.toJson<String>(body),
    };
  }

  SmsLogEntry copyWith({
    int? id,
    DateTime? timestamp,
    String? sender,
    String? body,
  }) => SmsLogEntry(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    sender: sender ?? this.sender,
    body: body ?? this.body,
  );
  SmsLogEntry copyWithCompanion(SmsLogsCompanion data) {
    return SmsLogEntry(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      sender: data.sender.present ? data.sender.value : this.sender,
      body: data.body.present ? data.body.value : this.body,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmsLogEntry(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('sender: $sender, ')
          ..write('body: $body')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, sender, body);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsLogEntry &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.sender == this.sender &&
          other.body == this.body);
}

class SmsLogsCompanion extends UpdateCompanion<SmsLogEntry> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<String> sender;
  final Value<String> body;
  const SmsLogsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.sender = const Value.absent(),
    this.body = const Value.absent(),
  });
  SmsLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required String sender,
    required String body,
  }) : timestamp = Value(timestamp),
       sender = Value(sender),
       body = Value(body);
  static Insertable<SmsLogEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? sender,
    Expression<String>? body,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (sender != null) 'sender': sender,
      if (body != null) 'body': body,
    });
  }

  SmsLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<String>? sender,
    Value<String>? body,
  }) {
    return SmsLogsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      sender: sender ?? this.sender,
      body: body ?? this.body,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmsLogsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('sender: $sender, ')
          ..write('body: $body')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $SmsLogsTable smsLogs = $SmsLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [transactions, smsLogs];
}

typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required double amount,
      required TransactionType type,
      Value<String?> merchant,
      required DateTime date,
      required PaymentMethod method,
      Value<String?> account,
      Value<double?> availableBalance,
      required String rawSms,
      required String bankName,
      Value<String?> templateName,
      Value<bool> isVerified,
      Value<bool> isSample,
      Value<String?> description,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<double> amount,
      Value<TransactionType> type,
      Value<String?> merchant,
      Value<DateTime> date,
      Value<PaymentMethod> method,
      Value<String?> account,
      Value<double?> availableBalance,
      Value<String> rawSms,
      Value<String> bankName,
      Value<String?> templateName,
      Value<bool> isVerified,
      Value<bool> isSample,
      Value<String?> description,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
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

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMethod, PaymentMethod, String>
  get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get account => $composableBuilder(
    column: $table.account,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get availableBalance => $composableBuilder(
    column: $table.availableBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawSms => $composableBuilder(
    column: $table.rawSms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSample => $composableBuilder(
    column: $table.isSample,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
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

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get account => $composableBuilder(
    column: $table.account,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get availableBalance => $composableBuilder(
    column: $table.availableBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawSms => $composableBuilder(
    column: $table.rawSms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSample => $composableBuilder(
    column: $table.isSample,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentMethod, String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get account =>
      $composableBuilder(column: $table.account, builder: (column) => column);

  GeneratedColumn<double> get availableBalance => $composableBuilder(
    column: $table.availableBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawSms =>
      $composableBuilder(column: $table.rawSms, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get templateName => $composableBuilder(
    column: $table.templateName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSample =>
      $composableBuilder(column: $table.isSample, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionEntry,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            TransactionEntry,
            BaseReferences<_$AppDatabase, $TransactionsTable, TransactionEntry>,
          ),
          TransactionEntry,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<TransactionType> type = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<PaymentMethod> method = const Value.absent(),
                Value<String?> account = const Value.absent(),
                Value<double?> availableBalance = const Value.absent(),
                Value<String> rawSms = const Value.absent(),
                Value<String> bankName = const Value.absent(),
                Value<String?> templateName = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<bool> isSample = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                amount: amount,
                type: type,
                merchant: merchant,
                date: date,
                method: method,
                account: account,
                availableBalance: availableBalance,
                rawSms: rawSms,
                bankName: bankName,
                templateName: templateName,
                isVerified: isVerified,
                isSample: isSample,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double amount,
                required TransactionType type,
                Value<String?> merchant = const Value.absent(),
                required DateTime date,
                required PaymentMethod method,
                Value<String?> account = const Value.absent(),
                Value<double?> availableBalance = const Value.absent(),
                required String rawSms,
                required String bankName,
                Value<String?> templateName = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<bool> isSample = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                amount: amount,
                type: type,
                merchant: merchant,
                date: date,
                method: method,
                account: account,
                availableBalance: availableBalance,
                rawSms: rawSms,
                bankName: bankName,
                templateName: templateName,
                isVerified: isVerified,
                isSample: isSample,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionEntry,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        TransactionEntry,
        BaseReferences<_$AppDatabase, $TransactionsTable, TransactionEntry>,
      ),
      TransactionEntry,
      PrefetchHooks Function()
    >;
typedef $$SmsLogsTableCreateCompanionBuilder =
    SmsLogsCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required String sender,
      required String body,
    });
typedef $$SmsLogsTableUpdateCompanionBuilder =
    SmsLogsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<String> sender,
      Value<String> body,
    });

class $$SmsLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SmsLogsTable> {
  $$SmsLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SmsLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SmsLogsTable> {
  $$SmsLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SmsLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmsLogsTable> {
  $$SmsLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);
}

class $$SmsLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmsLogsTable,
          SmsLogEntry,
          $$SmsLogsTableFilterComposer,
          $$SmsLogsTableOrderingComposer,
          $$SmsLogsTableAnnotationComposer,
          $$SmsLogsTableCreateCompanionBuilder,
          $$SmsLogsTableUpdateCompanionBuilder,
          (
            SmsLogEntry,
            BaseReferences<_$AppDatabase, $SmsLogsTable, SmsLogEntry>,
          ),
          SmsLogEntry,
          PrefetchHooks Function()
        > {
  $$SmsLogsTableTableManager(_$AppDatabase db, $SmsLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmsLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmsLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmsLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<String> body = const Value.absent(),
              }) => SmsLogsCompanion(
                id: id,
                timestamp: timestamp,
                sender: sender,
                body: body,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required String sender,
                required String body,
              }) => SmsLogsCompanion.insert(
                id: id,
                timestamp: timestamp,
                sender: sender,
                body: body,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SmsLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmsLogsTable,
      SmsLogEntry,
      $$SmsLogsTableFilterComposer,
      $$SmsLogsTableOrderingComposer,
      $$SmsLogsTableAnnotationComposer,
      $$SmsLogsTableCreateCompanionBuilder,
      $$SmsLogsTableUpdateCompanionBuilder,
      (SmsLogEntry, BaseReferences<_$AppDatabase, $SmsLogsTable, SmsLogEntry>),
      SmsLogEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$SmsLogsTableTableManager get smsLogs =>
      $$SmsLogsTableTableManager(_db, _db.smsLogs);
}
