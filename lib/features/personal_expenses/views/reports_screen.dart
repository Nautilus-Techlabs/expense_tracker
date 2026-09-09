import 'dart:math' as math;

import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:expense_tracker/data/repositories/supabase_provider.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/report_filter_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/report_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../core/constants/app_router.dart';
import '../models/reports_model.dart' as model;

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchEarliestTransactionDate();
      _fetchData();
    });
  }

  Future<void> _fetchEarliestTransactionDate() async {
    final user = ref.read(authProvider).user;
    if (user != null) {
      final result = await ref
          .read(supabaseHelperProvider)
          .getEarliestTransactionDate(user.id);
      result.fold(
        (failure) {
          if (mounted) {
            ref.read(reportFilterProvider.notifier).setEarliestDate(null);
          }
        },
        (date) {
          if (mounted) {
            ref.read(reportFilterProvider.notifier).setEarliestDate(date);
          }
        },
      );
    } else {
      if (mounted) {
        ref.read(reportFilterProvider.notifier).setEarliestDate(null);
      }
    }
  }

  void _fetchData() {
    final filterState = ref.read(reportFilterProvider);
    ref
        .read(reportProvider.notifier)
        .fetchReports(
          startDate: filterState.startDate,
          endDate: filterState.endDate,
        );
  }

  void _previousMonth() {
    final filterState = ref.read(reportFilterProvider);
    final previousMonthStart = DateTime(
      filterState.startDate.year,
      filterState.startDate.month - 1,
      1,
    );

    final earliestTxnDate = filterState.earliestTxnDate;
    final loadingEarliestDate = filterState.isLoadingEarliestDate;

    if (earliestTxnDate != null) {
      final earliestMonthStart = DateTime(
        earliestTxnDate.year,
        earliestTxnDate.month,
        1,
      );
      if (previousMonthStart.isBefore(earliestMonthStart)) {
        return;
      }
    } else if (!loadingEarliestDate) {
      return;
    }

    ref.read(reportFilterProvider.notifier).previousMonth();
    _fetchData();
  }

  void _nextMonth() {
    final filterState = ref.read(reportFilterProvider);
    final now = DateTime.now();
    if (filterState.startDate.year == now.year &&
        filterState.startDate.month == now.month) {
      return;
    }

    ref.read(reportFilterProvider.notifier).nextMonth();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reportState = ref.watch(reportProvider);
    final report = reportState.report;
    final filterState = ref.watch(reportFilterProvider);
    final earliestTxnDate = filterState.earliestTxnDate;
    final loadingEarliestDate = filterState.isLoadingEarliestDate;

    final reportMatchesFilter = report != null &&
        DateTime.parse(report.startDate).month == filterState.startDate.month &&
        DateTime.parse(report.startDate).year == filterState.startDate.year;

    bool canGoPrevious = true;
    if (loadingEarliestDate) {
      canGoPrevious = false;
    } else if (earliestTxnDate == null) {
      canGoPrevious = false;
    } else {
      final previousMonthStart = DateTime(
        filterState.startDate.year,
        filterState.startDate.month - 1,
        1,
      );
      final earliestMonthStart = DateTime(
        earliestTxnDate.year,
        earliestTxnDate.month,
        1,
      );
      if (previousMonthStart.isBefore(earliestMonthStart)) {
        canGoPrevious = false;
      }
    }

    final now = DateTime.now();
    final canGoNext = !(filterState.startDate.year == now.year &&
        filterState.startDate.month == now.month);

    final monthYear = DateFormat('MMM yyyy').format(filterState.startDate);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _fetchData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reports',
                        style: context.appTexts.displayMedium.copyWith(
                          color: context.colors.primary,
                          fontSize: 32.sp,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.cardDark
                              : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: canGoPrevious && !reportState.isLoading
                                  ? _previousMonth
                                  : null,
                              child: Opacity(
                                opacity: canGoPrevious && !reportState.isLoading
                                    ? 1.0
                                    : 0.4,
                                child: Icon(
                                  Icons.chevron_left_rounded,
                                  size: 20.sp,
                                  color: context.colors.textSecondary,
                                ),
                              ),
                            ),
                            UIHelpers.horizontalSpace(8),
                            Text(
                              monthYear,
                              style: context.appTexts.bodyMedium.copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            UIHelpers.horizontalSpace(8),
                            GestureDetector(
                              onTap: canGoNext && !reportState.isLoading
                                  ? _nextMonth
                                  : null,
                              child: Opacity(
                                opacity: canGoNext && !reportState.isLoading
                                    ? 1.0
                                    : 0.4,
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20.sp,
                                  color: context.colors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (reportState.isLoading && !reportMatchesFilter)
                  SizedBox(
                    height: 400.h,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (reportState.errorMessage != null &&
                    !reportMatchesFilter)
                  SizedBox(
                    height: 400.h,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(reportState.errorMessage!),
                          UIHelpers.verticalSpace(16),
                          ElevatedButton(
                            onPressed: _fetchData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (reportMatchesFilter) ...[
                  // ── Top Stats ──
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatItem(
                          title: 'INCOME',
                          amount: '₹${report.summary.income}',
                          color: AppColors.income,
                          isDark: isDark,
                        ),
                        _StatItem(
                          title: 'EXPENSE',
                          amount: '₹${report.summary.expense}',
                          color: AppColors.expense,
                          isDark: isDark,
                        ),
                        _StatItem(
                          title: 'NET',
                          amount:
                              '${report.summary.net >= 0 ? '+' : ''}₹${report.summary.net}',
                          color: report.summary.net >= 0
                              ? AppColors.income
                              : AppColors.expense,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                  UIHelpers.verticalSpace(32),

                  // ── Monthly Trend Card ──
                  _MonthlyTrendCard(trend: report.trend, isDark: isDark),
                  UIHelpers.verticalSpace(16),

                  // ── Spending Breakdown Card ──
                  _SpendingBreakdownCard(
                    breakdown: report.spendingBreakdown,
                    isDark: isDark,
                    startDate: filterState.startDate,
                    endDate: filterState.endDate,
                  ),
                  UIHelpers.verticalSpace(16),

                  // ── By Account Card ──
                  _ByAccountCard(
                    summary: report.accountSummary,
                    isDark: isDark,
                  ),
                ] else
                  SizedBox(
                    height: 400.h,
                    child: const Center(
                      child: Text('No data available for this period'),
                    ),
                  ),

                UIHelpers.verticalSpace(120), // Bottom padding for nav bar
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final bool isDark;

  const _StatItem({
    required this.title,
    required this.amount,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: context.appTexts.bodySmall.copyWith(
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        UIHelpers.verticalSpace(8),
        Text(
          amount,
          style: context.appTexts.displayMedium.copyWith(
            color: color,
            fontSize: 22.sp,
          ),
        ),
      ],
    );
  }
}

class _MonthlyTrendCard extends StatelessWidget {
  final model.Trend trend;
  final bool isDark;
  const _MonthlyTrendCard({required this.trend, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Find max value for scaling
    int maxVal = 1;
    for (var p in trend.points) {
      maxVal = math.max(maxVal, math.max(p.income, p.expense));
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MONTHLY TREND',
            style: context.appTexts.bodySmall.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          UIHelpers.verticalSpace(32),
          SizedBox(
            height: 170.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: trend.points.map((p) {
                return _BarGroup(
                  label: p.label,
                  incomePercent: p.income / maxVal,
                  expensePercent: p.expense / maxVal,
                  isDark: isDark,
                  isCurrentMonth:
                      p.label == DateFormat('MMM').format(DateTime.now()),
                );
              }).toList(),
            ),
          ),
          UIHelpers.verticalSpace(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(
                color: AppColors.income,
                label: 'Income',
                isDark: isDark,
              ),
              UIHelpers.horizontalSpace(24),
              _LegendItem(
                color: AppColors.expense,
                label: 'Expense',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarGroup extends StatelessWidget {
  final String label;
  final double incomePercent;
  final double expensePercent;
  final bool isDark;
  final bool isCurrentMonth;

  const _BarGroup({
    required this.label,
    required this.incomePercent,
    required this.expensePercent,
    required this.isDark,
    this.isCurrentMonth = false,
  });

  @override
  Widget build(BuildContext context) {
    final incomeColor = isCurrentMonth
        ? AppColors.income
        : AppColors.income.withAlpha(isDark ? 100 : 80);
    final expenseColor = isCurrentMonth
        ? AppColors.expense
        : AppColors.expense.withAlpha(isDark ? 100 : 80);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 8.w,
              height: 120.h * incomePercent,
              color: incomeColor,
            ),
            UIHelpers.horizontalSpace(4),
            Container(
              width: 8.w,
              height: 120.h * expensePercent,
              color: expenseColor,
            ),
          ],
        ),
        UIHelpers.verticalSpace(12),
        Text(
          label,
          style: context.appTexts.bodySmall.copyWith(
            color: isCurrentMonth
                ? (context.colors.textPrimary)
                : (context.colors.textSecondary),
            fontWeight: isCurrentMonth ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDark;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        UIHelpers.horizontalSpace(6),
        Text(
          label,
          style: context.appTexts.bodySmall.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SpendingBreakdownCard extends StatelessWidget {
  final model.SpendingBreakdown breakdown;
  final bool isDark;
  final DateTime startDate;
  final DateTime endDate;
  const _SpendingBreakdownCard({
    required this.breakdown,
    required this.isDark,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SPENDING BREAKDOWN',
            style: context.appTexts.bodySmall.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          UIHelpers.verticalSpace(32),

          // Donut Chart
          Center(
            child: SizedBox(
              width: 160.w,
              height: 160.w,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(160.w, 160.w),
                    painter: _DonutChartPainter(
                      segments: breakdown.categories.map((c) {
                        // Parse color string to Color object
                        Color color = Colors.grey;
                        try {
                          color = Color(
                            int.parse(c.color.replaceFirst('#', '0xFF')),
                          );
                        } catch (e) {
                          debugPrint('Error parsing color: $e');
                        }
                        return _Segment(
                          value: c.percentage.toDouble(),
                          color: color,
                        );
                      }).toList(),
                      strokeWidth: 16.w,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '₹${breakdown.totalSpent}',
                          style: context.appTexts.displayMedium.copyWith(
                            color: context.colors.primary,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          'spent',
                          style: context.appTexts.bodySmall.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          UIHelpers.verticalSpace(32),

          // List Items
          ...breakdown.categories.map((c) {
            Color color = Colors.grey;
            try {
              color = Color(int.parse(c.color.replaceFirst('#', '0xFF')));
            } catch (e) {
              debugPrint('Error parsing color: $e');
            }
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _BreakdownItem(
                color: color,
                label: c.name,
                amount: '₹${c.amount}',
                percentage: '${c.percentage}%',
                isDark: isDark,
              ),
            );
          }),

          UIHelpers.verticalSpace(8),
          Center(
            child: InkWell(
              onTap: () {
                context.push(
                  AppRouter.categoryBreakdown,
                  extra: {'startDate': startDate, 'endDate': endDate},
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View all categories',
                    style: context.appTexts.bodySmall.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w700,
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
        ],
      ),
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  final Color color;
  final String label;
  final String amount;
  final String percentage;
  final bool isDark;

  const _BreakdownItem({
    required this.color,
    required this.label,
    required this.amount,
    required this.percentage,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        UIHelpers.horizontalSpace(12),
        Text(
          label,
          style: context.appTexts.bodyMedium.copyWith(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          '$amount ($percentage)',
          style: context.appTexts.bodyMedium.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ByAccountCard extends StatelessWidget {
  final model.AccountSummary summary;
  final bool isDark;
  const _ByAccountCard({required this.summary, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BY ACCOUNT',
            style: context.appTexts.bodySmall.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          UIHelpers.verticalSpace(24),

          // Header Row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Account Name',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Inflow',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Outflow',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Net',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          UIHelpers.verticalSpace(16),

          // List Items
          ...summary.accounts.map((acc) {
            return Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: _AccountRow(
                icon: acc.type == 'bank'
                    ? Icons.account_balance_rounded
                    : Icons.payments_rounded,
                name: acc.name,
                inflow: '₹${acc.income}',
                outflow: '₹${acc.expense}',
                net: '₹${acc.net}',
                isDark: isDark,
                isNegativeNet: acc.net < 0,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final String name;
  final String inflow;
  final String outflow;
  final String net;
  final bool isDark;
  final bool isNegativeNet;

  const _AccountRow({
    required this.icon,
    required this.name,
    required this.inflow,
    required this.outflow,
    required this.net,
    required this.isDark,
    this.isNegativeNet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFF5F5F0),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  size: 16.sp,
                  color: context.colors.textPrimary,
                ),
              ),
              UIHelpers.horizontalSpace(8),
              Expanded(
                child: Text(
                  name,
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            inflow,
            style: context.appTexts.bodySmall.copyWith(color: AppColors.income),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            outflow,
            style: context.appTexts.bodySmall.copyWith(
              color: AppColors.expense,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            net,
            style: context.appTexts.bodyMedium.copyWith(
              color: isNegativeNet
                  ? AppColors.expense
                  : (context.colors.textPrimary),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _Segment {
  final double value;
  final Color color;
  _Segment({required this.value, required this.color});
}

class _DonutChartPainter extends CustomPainter {
  final List<_Segment> segments;
  final double strokeWidth;

  _DonutChartPainter({required this.segments, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    double startAngle = -math.pi / 2;

    for (var segment in segments) {
      final sweepAngle = (segment.value / 100) * 2 * math.pi;
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle + 0.02;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
