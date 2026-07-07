import 'package:expense_tracker/features/personal_expenses/views/onboarding_screen.dart';
import 'package:expense_tracker/features/personal_expenses/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/transaction.dart';
import '../../features/personal_expenses/views/bank_detail_transactions_screen.dart';
import '../../features/personal_expenses/views/detailed_transaction.dart';
import '../../features/personal_expenses/views/feedback_screen.dart';
import '../../features/personal_expenses/views/main_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String transactions = '/transactions';
  static const String transactionDetail = '/transaction-detail';
  static const String bankTransactions = '/bank-transactions';
  static const String feedback = '/feedback';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: transactions,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: transactionDetail,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Transaction) {
            return DetailedTransactionScreen(transaction: extra);
          }
          if (extra is Map) {
            return DetailedTransactionScreen(
              transaction: extra['transaction'] as Transaction,
              heroTag: extra['heroTag'] as String?,
            );
          }
          // Fallback if extra is null or invalid
          return Scaffold(
            body: Center(child: Text('Invalid transaction data')),
          );
        },
      ),
      GoRoute(
        path: bankTransactions,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, String>) {
            return BankDetailTransactionsScreen(
              bankName: extra['bankName']!,
              accountNumber: extra['accountNumber']!,
            );
          }
          final bankName = extra as String;
          return BankDetailTransactionsScreen(bankName: bankName);
        },
      ),
      GoRoute(
        path: feedback,
        builder: (context, state) => const FeedbackScreen(),
      ),
    ],
  );
}
