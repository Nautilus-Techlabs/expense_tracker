import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';
import '../../../core/navigation_provider.dart';
import '../viewmodels/transaction_notifier.dart';
import '../widgets/transaction_card.dart';
import '../../auth/viewmodels/auth_notifier.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);
    final controller = ref.read(transactionProvider.notifier);
    final user = ref.watch(authProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String initials = '??';
    if (user != null && user.fullName.isNotEmpty) {
      final parts = user.fullName.trim().split(' ');
      if (parts.length > 1) {
        initials = (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
      } else if (parts[0].isNotEmpty) {
        initials = parts[0][0].toUpperCase();
      }
    }

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.syncTransactions,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Greeting + Avatar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: context.appTexts.bodyMedium,
                        ),
                        Text(
                          user?.fullName.split(' ').first ?? 'User',
                          style: context.appTexts.displaySmall,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.push(AppRouter.profile),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors
                                .borderLight, // Using light border for both as per design
                            width: 1,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 24.r,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            initials,
                            style: context.appTexts.bodyLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelpers.verticalSpace(32),

                // 2. Total Balance Card
                _buildTotalBalanceCard(
                  state.globalBalance,
                  state.totalGlobalCredit,
                  state.totalGlobalDebit,
                  isDark,
                ),
                UIHelpers.verticalSpace(16),

                // 3. Budget Card
                _buildBudgetCard(isDark),
                UIHelpers.verticalSpace(32),

                // 4. Today's Transactions Header
                Text(
                  'Today',
                  style: context.appTexts.headingMedium.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                UIHelpers.verticalSpace(16),

                // 5. Transactions List (Just take up to 3 for now)
                if (state.allTransactions.isEmpty)
                  Center(
                    child: Text(
                      "No transactions yet.",
                      style: context.appTexts.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  )
                else
                  ...state.latestTransactions
                      .take(3)
                      .map(
                        (tx) => TransactionCard(
                          transaction: tx,
                          showDate: false,
                          heroTag: 'dash_${tx.id ?? tx.rawSms}',
                        ),
                      ),

                UIHelpers.verticalSpace(8),

                // 6. See all transactions
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ref.read(navigationIndexProvider.notifier).state = 1;
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'See all transactions',
                          style: context.appTexts.bodyMedium.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        UIHelpers.horizontalSpace(4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16.sp,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                UIHelpers.verticalSpace(16),

                // 7. Circles / Owed Card
                _buildCirclesCard(isDark),
                UIHelpers.verticalSpace(16),

                // 8. Mini Stats (Top Spend / This Week)
                Row(
                  children: [
                    Expanded(
                      child: _buildMiniStatCard(
                        'Top spend',
                        'Rent • ₹12,000',
                        isDark,
                      ),
                    ),
                    UIHelpers.horizontalSpace(16),
                    Expanded(
                      child: _buildMiniStatCard(
                        'This week',
                        '₹4,200 spent',
                        isDark,
                      ),
                    ),
                  ],
                ),

                UIHelpers.verticalSpace(100), // Bottom padding for FAB and Nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBalanceCard(
    double balance,
    double income,
    double expense,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total balance', style: context.appTexts.bodyMedium),
                  UIHelpers.verticalSpace(8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '₹${balance.toStringAsFixed(0)}',
                        style: context.appTexts.displayMedium,
                      ),
                      UIHelpers.horizontalSpace(8),
                      Icon(
                        Icons.visibility_outlined,
                        size: 20.sp,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ],
                  ),
                ],
              ),
              // Circular Progress Indicator (Static for now)
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60.w,
                    height: 60.w,
                    child: CircularProgressIndicator(
                      value: 0.8,
                      strokeWidth: 6.w,
                      backgroundColor: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                      color: AppColors.primary,
                    ),
                  ),
                  Text('80%', style: context.appTexts.bodySmall),
                ],
              ),
            ],
          ),
          UIHelpers.verticalSpace(32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Income', style: context.appTexts.bodyMedium),
                  UIHelpers.verticalSpace(4),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,
                        size: 16.sp,
                        color: AppColors.income,
                      ),
                      UIHelpers.horizontalSpace(4),
                      Text(
                        '₹${income.toStringAsFixed(0)}',
                        style: context.appTexts.amountIncome,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expense', style: context.appTexts.bodyMedium),
                  UIHelpers.verticalSpace(4),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_downward_rounded,
                        size: 16.sp,
                        color: AppColors.expense,
                      ),
                      UIHelpers.horizontalSpace(4),
                      Text(
                        '₹${expense.toStringAsFixed(0)}',
                        style: context.appTexts.amountExpense,
                      ),
                    ],
                  ),
                ],
              ),
              UIHelpers.horizontalSpace(24), // Spacer to push left
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('June budget', style: context.appTexts.headingMedium),
              Text('₹32,000 / ₹40,000', style: context.appTexts.bodyMedium),
            ],
          ),
          UIHelpers.verticalSpace(12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: 0.8,
              minHeight: 8.h,
              backgroundColor: isDark
                  ? AppColors.borderDark
                  : AppColors.borderLight,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCirclesCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('You are owed', style: context.appTexts.bodyMedium),
                  UIHelpers.verticalSpace(4),
                  Text(
                    '₹2,400',
                    style: context.appTexts.amountIncome.copyWith(
                      fontSize: 20.sp,
                    ), // Slightly smaller than Large
                  ),
                ],
              ),
              Container(
                height: 40.h,
                width: 1.w,
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('You owe', style: context.appTexts.bodyMedium),
                  UIHelpers.verticalSpace(4),
                  Text(
                    '₹800',
                    style: context.appTexts.amountExpense.copyWith(
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
              UIHelpers.horizontalSpace(24),
            ],
          ),
          UIHelpers.verticalSpace(24),
          GestureDetector(
            onTap: () {
              ref.read(navigationIndexProvider.notifier).state =
                  2; // Go to circles
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View circles',
                  style: context.appTexts.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                UIHelpers.horizontalSpace(4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(String title, String subtitle, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.appTexts.bodyMedium),
          UIHelpers.verticalSpace(12),
          Text(
            subtitle,
            style: context.appTexts.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
