import 'package:expense_tracker/features/auth/views/signin_screen.dart';
import 'package:expense_tracker/features/auth/views/signup_screen.dart';
import 'package:expense_tracker/features/auth/views/welcome_screen.dart';
import 'package:expense_tracker/features/personal_expenses/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/personal_expenses/models/transaction_model.dart';
import '../../features/personal_expenses/views/accounts_settings_screen.dart';
import '../../features/personal_expenses/views/add_account_screen.dart';
import '../../features/personal_expenses/views/add_budget_screen.dart';
import '../../features/personal_expenses/views/categories_settings_screen.dart';
import '../../features/personal_expenses/views/category_breakdown_screen.dart';
import '../../features/personal_expenses/views/circle_details_screen.dart';
import '../../features/personal_expenses/views/detailed_transaction.dart';
import '../../features/personal_expenses/views/feedback_screen.dart';
import '../../features/personal_expenses/views/main_screen.dart';
import '../../features/personal_expenses/views/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String signIn = '/signin';
  static const String signup = '/signup';
  static const String verifyOtp = '/verify-otp';
  static const String transactions = '/transactions';
  static const String transactionDetail = '/transaction-detail';
  static const String bankTransactions = '/bank-transactions';
  static const String feedback = '/feedback';
  static const String circleDetails = '/circle-details';
  static const String profile = '/profile';
  static const String accountsSettings = '/accounts';
  static const String categoriesSettings = '/categories';
  static const String addAccount = '/add-account';
  static const String addBudget = '/add-budget';
  static const String categoryBreakdown = '/category-breakdown';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(path: signIn, builder: (context, state) => const SignInScreen()),

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
          if (extra is TransactionModel) {
            return DetailedTransactionScreen(transaction: extra);
          }
          if (extra is Map) {
            return DetailedTransactionScreen(
              transaction: extra['transaction'] as TransactionModel,
              heroTag: extra['heroTag'] as String?,
            );
          }
          return const Scaffold(
            body: Center(child: Text('Invalid transaction data')),
          );
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
        path: accountsSettings,
        builder: (context, state) => const AccountsSettingsScreen(),
      ),
      GoRoute(
        path: categoriesSettings,
        builder: (context, state) => const CategoriesSettingsScreen(),
      ),
      GoRoute(
        path: addAccount,
        builder: (context, state) => const AddAccountScreen(),
      ),
      GoRoute(
        path: addBudget,
        builder: (context, state) => const AddBudgetScreen(),
      ),
      GoRoute(
        path: categoryBreakdown,
        builder: (context, state) {
          final args = state.extra as Map<String, DateTime>;
          return CategoryBreakdownScreen(
            startDate: args['startDate']!,
            endDate: args['endDate']!,
          );
        },
      ),
    ],
  );
}
