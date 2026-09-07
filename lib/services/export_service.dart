import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../features/personal_expenses/models/account_model.dart';
import '../features/personal_expenses/models/category_model.dart';
import '../features/personal_expenses/models/transaction_model.dart';

class ExportService {
  /// Generates a CSV file from transactions + account summary and triggers
  /// the native OS share sheet.
  static Future<void> exportToCsv({
    required BuildContext context,
    required List<TransactionModel> transactions,
    required List<AccountModel> accounts,
    required List<CategoryModel> categories,
  }) async {
    // Build lookup maps for O(1) name resolution
    final accountMap = {for (final a in accounts) a.id: a};
    final categoryMap = {for (final c in categories) c.id: c};

    final buffer = StringBuffer();

    // ── Section 1: Header ──
    buffer.writeln('TRANSACTIONS EXPORT');
    buffer.writeln(
      'Generated on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}',
    );
    buffer.writeln();

    // ── Section 2: Transactions Table ──
    buffer.writeln('--- TRANSACTIONS ---');
    buffer.writeln('Date,Type,Category,Account,Note,Amount (Rs)');

    for (final txn in transactions) {
      final date = DateFormat('dd-MM-yyyy').format(txn.txnDate);
      final type = txn.type;
      final category =
          txn.categoryId != null
              ? (categoryMap[txn.categoryId]?.name ?? 'Unknown')
              : 'Uncategorized';
      final account = accountMap[txn.accountId]?.name ?? 'Unknown';
      final note = _escapeCsv(txn.note ?? '-');
      final amount = txn.amount.toStringAsFixed(2);

      buffer.writeln('$date,$type,$category,$account,$note,$amount');
    }

    buffer.writeln();

    // ── Section 3: Account Summary Table ──
    buffer.writeln('--- ACCOUNT SUMMARY ---');
    buffer.writeln('Account,Type,Balance (Rs),Total In (Rs),Total Out (Rs),Net (Rs)');

    double grandTotalBalance = 0;
    double grandTotalIn = 0;
    double grandTotalOut = 0;

    for (final account in accounts) {
      final accountTxns = transactions.where((t) => t.accountId == account.id);

      final totalIn = accountTxns
          .where((t) => t.type == 'income')
          .fold(0.0, (sum, t) => sum + t.amount);

      final totalOut = accountTxns
          .where((t) => t.type == 'expense' || t.type == 'withdrawal')
          .fold(0.0, (sum, t) => sum + t.amount);

      final net = totalIn - totalOut;

      grandTotalBalance += account.balance;
      grandTotalIn += totalIn;
      grandTotalOut += totalOut;

      final accountType = account.type == AccountType.bank
          ? 'Bank'
          : account.type == AccountType.cash
          ? 'Cash'
          : 'Credit Card';

      buffer.writeln(
        '${_escapeCsv(account.name)},'
        '$accountType,'
        '${account.balance.toStringAsFixed(2)},'
        '${totalIn.toStringAsFixed(2)},'
        '${totalOut.toStringAsFixed(2)},'
        '${net.toStringAsFixed(2)}',
      );
    }

    // Grand total row
    buffer.writeln();
    buffer.writeln(
      'TOTAL,,'
      '${grandTotalBalance.toStringAsFixed(2)},'
      '${grandTotalIn.toStringAsFixed(2)},'
      '${grandTotalOut.toStringAsFixed(2)},'
      '${(grandTotalIn - grandTotalOut).toStringAsFixed(2)}',
    );

    // ── Write to temp file ──
    final directory = await getTemporaryDirectory();
    final fileName =
        'transactions_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(buffer.toString());

    // ── Share via native sheet ──
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'text/csv')],
        subject: 'Expense Tracker Export - $fileName',
      ),
    );
  }

  /// Wraps a CSV field in quotes if it contains a comma, quote, or newline.
  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
