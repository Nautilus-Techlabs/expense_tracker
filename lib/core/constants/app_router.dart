import 'package:expense_tracker/features/auth/views/signin_screen.dart';
import 'package:expense_tracker/features/auth/views/signup_screen.dart';
import 'package:expense_tracker/features/auth/views/welcome_screen.dart';
import 'package:expense_tracker/features/personal_expenses/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/transaction.dart';
import '../../features/personal_expenses/views/add_account_screen.dart';
import '../../features/personal_expenses/views/bank_detail_transactions_screen.dart';
import '../../features/personal_expenses/views/circle_details_screen.dart';
import '../../features/personal_expenses/views/detailed_transaction.dart';
import '../../features/personal_expenses/views/feedback_screen.dart';
import '../../features/personal_expenses/views/main_screen.dart';
import '../../features/personal_expenses/views/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String verifyOtp = '/verify-otp';
  static const String transactions = '/transactions';
  static const String transactionDetail = '/transaction-detail';
  static const String bankTransactions = '/bank-transactions';
  static const String feedback = '/feedback';
  static const String circleDetails = '/circle-details';
  static const String profile = '/profile';
  static const String addAccount = '/add-account';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(path: signin, builder: (context, state) => const SignInScreen()),

      GoRoute(
        path: welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),

      GoRoute(path: signup, builder: (context, state) => const SignUpScreen()),
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
      GoRoute(
        path: circleDetails,
        builder: (context, state) {
          final circleName = state.extra as String? ?? 'Circle Details';
          return CircleDetailsScreen(circleName: circleName);
        },
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: addAccount,
        builder: (context, state) => const AddAccountScreen(),
      ),
    ],
  );
}
