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
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  TextColumn get senderId => text().nullable()();
}

@DataClassName('CategoryEntry')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get icon => text().withDefault(const Constant('category'))();
  IntColumn get color => integer().nullable()();
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

@DriftDatabase(tables: [Transactions, SmsLogs, OpeningBalances, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(categories);
            await m.addColumn(transactions, transactions.categoryId);

            // Seed default categories
            final defaultCategories = [
              (name: 'Housing', icon: 'home', color: 0xFF2196F3), // Blue
              (name: 'Transportation', icon: 'directions_car', color: 0xFFFF9800), // Orange
              (name: 'Food & Dining', icon: 'restaurant', color: 0xFFF44336), // Red
              (name: 'Utilities', icon: 'bolt', color: 0xFFFFEB3B), // Yellow
              (name: 'Healthcare', icon: 'medical_services', color: 0xFF4CAF50), // Green
              (name: 'Insurance', icon: 'verified_user', color: 0xFF009688), // Teal
              (name: 'Savings & Investments', icon: 'trending_up', color: 0xFF8BC34A), // Light Green
              (name: 'Debt Payments', icon: 'payments', color: 0xFF9C27B0), // Purple
              (name: 'Shopping', icon: 'shopping_bag', color: 0xFFE91E63), // Pink
              (name: 'Entertainment', icon: 'movie', color: 0xFF3F51B5), // Indigo
              (name: 'Personal Care', icon: 'face', color: 0xFFFF5722), // Deep Orange
              (name: 'Education', icon: 'school', color: 0xFF795548), // Brown
              (name: 'Travel', icon: 'flight', color: 0xFF00BCD4), // Cyan
              (name: 'Family & Kids', icon: 'child_care', color: 0xFFFF4081), // Pink Accent
              (name: 'Miscellaneous', icon: 'more_horiz', color: 0xFF9E9E9E), // Grey
            ];

            for (final cat in defaultCategories) {
              await into(categories).insert(
                CategoriesCompanion.insert(
                  name: cat.name,
                  icon: Value(cat.icon),
                  color: Value(cat.color),
                ),
              );
            }
          }
          if (from < 3) {
            await m.addColumn(transactions, transactions.senderId);
          }
        },
      );

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
    return into(openingBalances).insert(
      companion,
      onConflict: DoUpdate(
        (old) => companion,
        target: [openingBalances.bankName, openingBalances.accountNumber],
      ),
    );
  }

  Future<void> updateTransaction(TransactionsCompanion companion) {
    return (update(
      transactions,
    )..where((t) => t.rawSms.equals(companion.rawSms.value!))).write(companion);
  }

  Future<void> deleteSmsLogByBody(String body) {
    return (delete(smsLogs)..where((l) => l.body.equals(body))).go();
  }

  // Category Helpers
  Future<List<CategoryEntry>> getAllCategories() => select(categories).get();

  Future<int> addCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  Future<void> deleteCategory(int id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();
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
