import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/transaction_list_screen.dart';
import '../../presentation/screens/detailed_transaction.dart';
import '../../domain/entities/transaction.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String transactions = '/transactions';
  static const String transactionDetail = '/transaction-detail';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: transactions,
        builder: (context, state) => const TransactionListScreen(),
      ),
      GoRoute(
        path: transactionDetail,
        builder: (context, state) {
          final transaction = state.extra as Transaction;
          return DetailedTransactionScreen(transaction: transaction);
        },
      ),
    ],
  );
}
