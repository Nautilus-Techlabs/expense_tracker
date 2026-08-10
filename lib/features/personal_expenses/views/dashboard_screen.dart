import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/dashboard_stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors_extension.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';
import '../../../core/navigation_provider.dart';
import '../../../core/services/deep_link_service.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/repositories/supabase_provider.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import '../viewmodels/account_notifier.dart';
import '../viewmodels/budget_notifier.dart';
import '../viewmodels/transaction_notifier.dart';
import '../widgets/transaction_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _navigatedForInvite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // ── Firebase Cloud Messaging setup ──────────────────────────────────
      // Request permission first, then setup listeners & register the token.
      final fcm = ref.read(fcmServiceProvider);
      await fcm.requestNotificationPermission();
      await fcm.setupFirebaseMessaging();

      // ── Pending deep-link invite ─────────────────────────────────────────
      final pendingInvite = ref.read(deepLinkProvider).pendingCircleInvite;
      if (pendingInvite != null) {
        _checkPendingInvite(pendingInvite);
      }
    });
  }

  void _checkPendingInvite(int? circleId) {
    AppLogger.i(
      '_checkPendingInvite in Dashboard called with circleId: $circleId',
    );
    if (circleId == null || !mounted || _navigatedForInvite) return;

    _navigatedForInvite = true;
    context.push(AppRouter.joinCircle, extra: circleId).whenComplete(() {
      _navigatedForInvite = false;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      ref.read(transactionProvider.notifier).fetchTransactions(),
      ref.read(accountProvider.notifier).fetchAccounts(),
      ref.read(budgetProvider.notifier).fetchBudget(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for new deep links arriving while app is running
    ref.listen(deepLinkProvider, (previous, next) {
      final prevId = previous?.pendingCircleInvite;
      final nextId = next.pendingCircleInvite;
      if (nextId != null && nextId != prevId) {
        _checkPendingInvite(nextId);
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(transactionProvider);
    final budgetState = ref.watch(budgetProvider);
    final user = ref.watch(authProvider).user;
    final stats = ref.watch(dashboardStatsProvider);

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
      backgroundColor: context.colors.background,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: SafeArea(
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
                            color: AppColors.borderLight,
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
                  stats.globalBalance,
                  stats.totalGlobalCredit,
                  stats.totalGlobalDebit,
                  isDark,
                ),
                UIHelpers.verticalSpace(16),

                // 3. Budget Card
                _buildBudgetCard(
                  budgetAmount: budgetState.budget?.amount ?? 0.0,
                  currentSpend: stats.monthlySpending,
                  isDark: isDark,
                ),
                UIHelpers.verticalSpace(32),

                // 4. Recent Transactions Header
                Text(
                  'Recent Transactions',
                  style: context.appTexts.headingMedium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                UIHelpers.verticalSpace(16),

                // 5. Transactions List (Just take up to 3 for now)
                if (state.transactions.isEmpty)
                  Center(
                    child: Text(
                      "No transactions yet.",
                      style: context.appTexts.bodyMedium.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  )
                else
                  ...state.transactions
                      .take(3)
                      .map(
                        (tx) => TransactionCard(
                          transaction: tx,
                          showDate: false,
                          heroTag: 'dash_${tx.id}',
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
                            color: context.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        UIHelpers.horizontalSpace(4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16.sp,
                          color: context.colors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                UIHelpers.verticalSpace(16),

                // 7. Mini Stats (Top Spend / This Week)
                Row(
                  children: [
                    Expanded(
                      child: _buildMiniStatCard(
                        'Top spend',
                        stats.topSpendTx != null
                            ? '${stats.topSpendTx!.note ?? 'Expense'} • ₹${stats.topSpendTx!.amount.toStringAsFixed(0)}'
                            : 'No data',
                        isDark,
                      ),
                    ),
                    UIHelpers.horizontalSpace(16),
                    Expanded(
                      child: _buildMiniStatCard(
                        'This week',
                        '₹${stats.weeklySpending.toStringAsFixed(0)} spent',
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
        color: context.colors.card,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total balance', style: context.appTexts.bodyMedium),
          UIHelpers.verticalSpace(8),
          Text(
            '₹${balance.toStringAsFixed(0)}',
            style: context.appTexts.displayMedium,
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
              const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard({
    required double budgetAmount,
    required double currentSpend,
    required bool isDark,
  }) {
    final double progress = budgetAmount > 0
        ? (currentSpend / budgetAmount).clamp(0.0, 1.0)
        : 0.0;
    final String monthName = DateFormat('MMMM').format(DateTime.now());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$monthName budget', style: context.appTexts.headingMedium),
              Text(
                '₹${currentSpend.toStringAsFixed(0)} / ₹${budgetAmount.toStringAsFixed(0)}',
                style: context.appTexts.bodyMedium,
              ),
            ],
          ),
          UIHelpers.verticalSpace(12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: context.colors.border,
              color: progress > 0.9 ? AppColors.expense : AppColors.primary,
            ),
          ),
          if (budgetAmount == 0) ...[
            UIHelpers.verticalSpace(8),
            GestureDetector(
              onTap: () => context.push(AppRouter.addBudget),
              child: Text(
                'Set a budget to track spending',
                style: context.appTexts.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCirclesCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: context.colors.border),
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
              Container(height: 40.h, width: 1.w, color: context.colors.border),
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
                  color: context.colors.primary,
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
        border: Border.all(color: context.colors.border),
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
