import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';

class BankAccountsScreen extends ConsumerWidget {
  const BankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);
    final controller = ref.read(transactionProvider.notifier);

    final banks = state.getAvailableBanks();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Header
            _buildHeader(context, state),

            // 2. Bank List
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.syncTransactions,
                color: Theme.of(context).colorScheme.primary,
                child: banks.isEmpty
                    ? _buildEmptyState(context, controller)
                    : _buildBankList(context, state, banks),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TransactionState state) {
    return Container(
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
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withAlpha(200),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withAlpha(60),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      UIHelpers.verticalSpace(4),
                      Text(
                        '₹${state.balance.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_rounded,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankList(
    BuildContext context,
    TransactionState state,
    List<String> banks,
  ) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
      physics: const BouncingScrollPhysics(),
      itemCount: banks.length,
      itemBuilder: (context, index) {
        final bankName = banks[index];
        final bankTransactions = state.allTransactions
            .where((t) => t.bankName == bankName)
            .toList();

        // Latest transaction to get balance
        final latestWithBalance =
            bankTransactions.where((t) => t.availableBalance != null).toList()
              ..sort((a, b) => b.date.compareTo(a.date));

        final currentBalance = latestWithBalance.isNotEmpty
            ? latestWithBalance.first.availableBalance
            : null;

        final lastTransaction = bankTransactions.isNotEmpty
            ? bankTransactions.reduce((a, b) => a.date.isAfter(b.date) ? a : b)
            : null;

        return _buildBankCard(
          context,
          bankName,
          currentBalance,
          lastTransaction,
        );
      },
    );
  }

  Widget _buildBankCard(
    BuildContext context,
    String bankName,
    double? balance,
    var lastTx,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push(AppRouter.bankTransactions, extra: bankName),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceElevatedDark : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppTheme.getBorderColor(context), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 30 : 10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    AppConstants.getBankLogo(bankName).isNotEmpty ? 8.w : 12.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.getBankLogo(bankName).isNotEmpty
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary.withAlpha(26),
                    shape: BoxShape.circle,
                    boxShadow: AppConstants.getBankLogo(bankName).isNotEmpty
                        ? [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: AppConstants.getBankLogo(bankName).isNotEmpty
                      ? SvgPicture.asset(
                          AppConstants.getBankLogo(bankName),
                          width: 24.sp,
                          height: 24.sp,
                          fit: BoxFit.contain,
                        )
                      : Text(
                          bankName.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                          ),
                        ),
                ),
                UIHelpers.horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bankName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      if (lastTx != null)
                        Text(
                          'Last: ${DateFormat('dd MMM').format(lastTx.date)}',
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
                        '₹${balance.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18.sp,
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    TransactionController controller,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_outlined,
            size: 64.sp,
            color: AppTheme.getNeutralColor(context).withAlpha(100),
          ),
          UIHelpers.verticalSpace(16),
          Text(
            'No Bank Accounts Detected',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.getNeutralColor(context),
            ),
          ),
          UIHelpers.verticalSpace(8),
          Text(
            'Sync your SMS to see your accounts',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.getNeutralColor(context).withAlpha(150),
            ),
          ),
          UIHelpers.verticalSpace(24),
          ElevatedButton(
            onPressed: controller.syncTransactions,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: const Text('Sync Now'),
          ),
        ],
      ),
    );
  }
}
