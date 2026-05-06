import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/transaction.dart';

part 'app_database.g.dart';

@DataClassName('TransactionEntry')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get type => textEnum<TransactionType>()();
  TextColumn get merchant => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get method => textEnum<PaymentMethod>()();
  TextColumn get account => text().nullable()();
  RealColumn get availableBalance => real().nullable()();
  TextColumn get rawSms => text().nullable().unique()();
  TextColumn get bankName => text()();
  TextColumn get templateName => text().nullable()();
  BoolColumn get isVerified => boolean().withDefault(const Constant(true))();
  BoolColumn get isSample => boolean().withDefault(const Constant(false))();
  TextColumn get description => text().nullable()();
  TextColumn get source =>
      textEnum<TransactionSource>().withDefault(const Constant('sms'))();
}

@DataClassName('SmsLogEntry')
class SmsLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get sender => text()();
  TextColumn get body => text()();
}

@DataClassName('OpeningBalanceEntry')
class OpeningBalances extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bankName => text()();
  TextColumn get accountNumber => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {bankName, accountNumber},
  ];
}

@DriftDatabase(tables: [Transactions, SmsLogs, OpeningBalances])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy();

  // Helpers
  Future<List<TransactionEntry>> getAllTransactions() =>
      select(transactions).get();

  Future<void> insertTransactions(List<TransactionsCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(transactions, entries, mode: InsertMode.insertOrIgnore);
    });
  }

  Future<void> insertSmsLogs(List<SmsLogsCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(smsLogs, entries, mode: InsertMode.insertOrReplace);
    });
  }

  Future<List<SmsLogEntry>> getAllSmsLogs() => select(smsLogs).get();

  Future<List<OpeningBalanceEntry>> getAllOpeningBalances() =>
      select(openingBalances).get();

  Future<void> setOpeningBalance(OpeningBalancesCompanion companion) {
    return into(openingBalances).insertOnConflictUpdate(companion);
  }

  Future<void> updateTransaction(TransactionsCompanion companion) {
    return (update(
      transactions,
    )..where((t) => t.rawSms.equals(companion.rawSms.value!))).write(companion);
  }

  Future<void> deleteSmsLogByBody(String body) {
    return (delete(smsLogs)..where((l) => l.body.equals(body))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
