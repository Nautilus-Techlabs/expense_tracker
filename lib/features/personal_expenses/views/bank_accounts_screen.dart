import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/ui_helpers.dart';
import '../viewmodels/transaction_notifier.dart';
import '../viewmodels/transaction_state.dart';
import '../widgets/common/bank_logo_avatar.dart';
import '../widgets/common/app_gradient_balance_card.dart';
import '../widgets/empty_state_view.dart';

class BankAccountsScreen extends ConsumerWidget {
  const BankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);
    final controller = ref.read(transactionProvider.notifier);
    final accounts = state.getUniqueAccounts();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header with total balance card
            _buildHeader(context, state),

            // Bank account list
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.syncTransactions,
                color: Theme.of(context).colorScheme.primary,
                child: accounts.isEmpty
                    ? EmptyStateView(
                        icon: Icons.account_balance_outlined,
                        title: 'No Bank Accounts Detected',
                        message: 'Sync your SMS to see your accounts',
                        actionLabel: 'Sync Now',
                        onRetry: controller.syncTransactions,
                      )
                    : _buildBankList(context, state, accounts),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TransactionState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accounts',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).textTheme.titleLarge?.color,
              letterSpacing: -1,
            ),
          ),
          UIHelpers.verticalSpace(16),
          AppGradientBalanceCard(
            balance: state.globalBalance,
            trailing: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_rounded,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankList(
    BuildContext context,
    TransactionState state,
    List<BankAccount> accounts,
  ) {
    // Pre-group transactions by account key for O(1) per card lookup
    final txByAccount = <String, List<dynamic>>{};
    for (final t in state.allTransactions) {
      final key = '${t.bankName}|${t.account}';
      txByAccount.putIfAbsent(key, () => []).add(t);
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
      physics: const BouncingScrollPhysics(),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        final key = '${account.bankName}|${account.accountNumber}';
        final bankTransactions = txByAccount[key] ?? [];

        final currentBalance = state.getAccountBalance(
          account.bankName,
          account.accountNumber,
        );

        final lastTransaction = bankTransactions.isNotEmpty
            ? bankTransactions.reduce(
                (a, b) =>
                    (a.date as DateTime).isAfter(b.date as DateTime) ? a : b,
              )
            : null;

        return _BankAccountCard(
          account: account,
          balance: currentBalance,
          lastTransaction: lastTransaction,
        );
      },
    );
  }
}

class _BankAccountCard extends StatelessWidget {
  final BankAccount account;
  final double? balance;
  final dynamic lastTransaction;

  const _BankAccountCard({
    required this.account,
    this.balance,
    this.lastTransaction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push(
        AppRouter.bankTransactions,
        extra: {
          'bankName': account.bankName,
          'accountNumber': account.accountNumber,
        },
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceElevatedDark : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppTheme.getBorderColor(context), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            BankLogoAvatar(
              bankName: account.bankName,
              size: 24,
              fallbackColor: colorScheme.primary,
            ),
            UIHelpers.horizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.displayName,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                    ),
                  ),
                  if (lastTransaction != null)
                    Text(
                      'Last: ${DateFormat('dd MMM').format(lastTransaction.date as DateTime)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.getNeutralColor(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            if (balance != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${balance!.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppTheme.getNeutralColor(context),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
