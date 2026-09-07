import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/features/personal_expenses/models/transaction_model.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/account_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/transaction_notifier.dart';

class DashboardStats {
  final double globalBalance;
  final double totalGlobalCredit;
  final double totalGlobalDebit;
  final double monthlySpending;
  final double weeklySpending;
  final TransactionModel? topSpendTx;

  const DashboardStats({
    required this.globalBalance,
    required this.totalGlobalCredit,
    required this.totalGlobalDebit,
    required this.monthlySpending,
    required this.weeklySpending,
    this.topSpendTx,
  });
}

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final accountState = ref.watch(accountProvider);
  final transactionState = ref.watch(transactionProvider);
  final transactions = transactionState.transactions;

  final globalBalance = accountState.accounts.fold<double>(
    0,
    (sum, account) => sum + account.balance,
  );

  final totalGlobalCredit = transactions
      .where((t) => t.type == 'income')
      .fold<double>(0, (sum, t) => sum + t.amount);

  final totalGlobalDebit = transactions
      .where((t) => t.type == 'expense' || t.type == 'withdrawal')
      .fold<double>(0, (sum, t) => sum + t.amount);

  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final monthlySpending = transactions
      .where(
        (t) =>
            (t.type == 'expense' || t.type == 'withdrawal') &&
            t.txnDate.isAfter(
              startOfMonth.subtract(const Duration(seconds: 1)),
            ),
      )
      .fold<double>(0, (sum, t) => sum + t.amount);

  final todayMidnight = DateTime(now.year, now.month, now.day);
  final startOfWeek = todayMidnight.subtract(Duration(days: todayMidnight.weekday - 1));
  final weeklySpending = transactions
      .where(
        (t) =>
            (t.type == 'expense' || t.type == 'withdrawal') &&
            t.txnDate.isAfter(startOfWeek.subtract(const Duration(seconds: 1))),
      )
      .fold<double>(0, (sum, t) => sum + t.amount);

  final topSpendTx = transactions
      .where((t) => t.type == 'expense' || t.type == 'withdrawal')
      .fold<TransactionModel?>(null, (prev, t) {
        if (prev == null || t.amount > prev.amount) return t;
        return prev;
      });

  return DashboardStats(
    globalBalance: globalBalance,
    totalGlobalCredit: totalGlobalCredit,
    totalGlobalDebit: totalGlobalDebit,
    monthlySpending: monthlySpending,
    weeklySpending: weeklySpending,
    topSpendTx: topSpendTx,
  );
});
