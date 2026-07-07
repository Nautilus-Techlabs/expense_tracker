import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../viewmodels/transaction_notifier.dart';
import '../viewmodels/transaction_state.dart';
import '../widgets/common/bank_logo_avatar.dart';

class BankAccountsScreen extends ConsumerWidget {
  const BankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);
    final controller = ref.read(transactionProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accounts = state.getUniqueAccounts();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.syncTransactions,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── Header ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                  child: Text(
                    'Accounts',
                    style: AppTexts.displayMedium.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                      fontSize: 32.sp,
                    ),
                  ),
                ),
              ),

              // ── Total Balance Card ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: AppTexts.bodyMedium.copyWith(
                            color: Colors.white.withAlpha(180),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '₹${state.globalBalance.toStringAsFixed(0)}',
                          style: AppTexts.displayLarge.copyWith(
                            color: Colors.white,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            _buildBalanceStat(
                              label: 'Income',
                              value: '₹${state.totalGlobalCredit.toStringAsFixed(0)}',
                              icon: Icons.arrow_upward_rounded,
                            ),
                            SizedBox(width: 24.w),
                            _buildBalanceStat(
                              label: 'Expenses',
                              value: '₹${state.totalGlobalDebit.toStringAsFixed(0)}',
                              icon: Icons.arrow_downward_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),

              // ── Section Label ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'YOUR ACCOUNTS',
                    style: AppTexts.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 12.h)),

              // ── Account List ──
              if (accounts.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.account_balance_outlined, size: 48.sp,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        SizedBox(height: 16.h),
                        Text(
                          'No bank accounts detected yet.\nSync your SMS to get started.',
                          style: AppTexts.bodyMedium.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final account = accounts[index];
                      final balance = state.getAccountBalance(account.bankName, account.accountNumber);

                      // Get last transaction date for this account
                      final accountTxs = state.allTransactions.where(
                        (t) => t.bankName == account.bankName && t.account == account.accountNumber,
                      ).toList();
                      final lastTx = accountTxs.isNotEmpty
                          ? accountTxs.reduce((a, b) => a.date.isAfter(b.date) ? a : b)
                          : null;

                      return _AccountCard(
                        account: account,
                        balance: balance,
                        lastTxDate: lastTx?.date,
                        isDark: isDark,
                      );
                    },
                    childCount: accounts.length,
                  ),
                ),

              SliverPadding(padding: EdgeInsets.only(bottom: 100.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceStat({required String label, required String value, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withAlpha(200), size: 16.sp),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTexts.bodySmall.copyWith(color: Colors.white.withAlpha(180))),
            Text(value, style: AppTexts.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }
}

class _AccountCard extends StatelessWidget {
  final BankAccount account;
  final double? balance;
  final DateTime? lastTxDate;
  final bool isDark;

  const _AccountCard({
    required this.account,
    required this.isDark,
    this.balance,
    this.lastTxDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppRouter.bankTransactions,
        extra: {
          'bankName': account.bankName,
          'accountNumber': account.accountNumber,
        },
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 12.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Row(
          children: [
            // Bank logo / avatar
            BankLogoAvatar(
              bankName: account.bankName,
              size: 24,
              fallbackColor: AppColors.primary,
            ),
            SizedBox(width: 16.w),

            // Bank name + last activity
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.displayName,
                    style: AppTexts.bodyLarge.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    lastTxDate != null
                        ? 'Last activity ${DateFormat('dd MMM').format(lastTxDate!)}'
                        : 'No transactions yet',
                    style: AppTexts.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),

            // Balance + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  balance != null ? '₹${balance!.toStringAsFixed(0)}' : '—',
                  style: AppTexts.bodyLarge.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Balance',
                  style: AppTexts.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right_rounded, size: 20.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ],
        ),
      ),
    );
  }
}
