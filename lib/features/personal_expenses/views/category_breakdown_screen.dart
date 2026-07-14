import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../core/utils/ui_helpers.dart';
import '../viewmodels/report_notifier.dart';

class CategoryBreakdownScreen extends ConsumerStatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const CategoryBreakdownScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  ConsumerState<CategoryBreakdownScreen> createState() =>
      _CategoryBreakdownScreenState();
}

class _CategoryBreakdownScreenState
    extends ConsumerState<CategoryBreakdownScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetchData());
  }

  void _fetchData() {
    ref
        .read(reportProvider.notifier)
        .fetchSpendingBreakdown(
          startDate: widget.startDate,
          endDate: widget.endDate,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reportState = ref.watch(reportProvider);
    final breakdown = reportState.breakdown;

    final monthYear = DateFormat('MMM yyyy').format(widget.startDate);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Spending Breakdown', style: context.appTexts.heading),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, size: 20.sp),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchData(),
        child: reportState.isLoading && breakdown == null
            ? const Center(child: CircularProgressIndicator())
            : breakdown == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No data available'),
                    UIHelpers.verticalSpace(16),
                    ElevatedButton(
                      onPressed: _fetchData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories for $monthYear',
                      style: context.appTexts.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UIHelpers.verticalSpace(24),

                    // Summary Card
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL SPENT',
                                style: context.appTexts.label,
                              ),
                              UIHelpers.verticalSpace(8),
                              Text(
                                '₹${breakdown.totalSpent}',
                                style: context.appTexts.displayMedium.copyWith(
                                  color: AppColors.expense,
                                  fontSize: 24.sp,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.pie_chart_rounded,
                            size: 40.sp,
                            color: AppColors.primary.withAlpha(100),
                          ),
                        ],
                      ),
                    ),

                    UIHelpers.verticalSpace(32),

                    // List of categories
                    ...breakdown.categories.map((c) {
                      Color color = Colors.grey;
                      try {
                        color = Color(
                          int.parse(c.color.replaceFirst('#', '0xFF')),
                        );
                      } catch (e) {
                        debugPrint('Error parsing color: $e');
                      }

                      return _CategoryListItem(
                        name: c.name,
                        amount: c.amount,
                        percentage: c.percentage,
                        color: color,
                        icon: c.icon,
                        isDark: isDark,
                      );
                    }),
                  ],
                ),
              ),
      ),
    );
  }
}

class _CategoryListItem extends StatelessWidget {
  final String name;
  final int amount;
  final double percentage;
  final Color color;
  final String icon;
  final bool isDark;

  const _CategoryListItem({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: color.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(_getIconData(icon), color: color, size: 20.sp),
                ),
              ),
              UIHelpers.horizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.appTexts.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UIHelpers.verticalSpace(4),
                    Text(
                      '${percentage.toStringAsFixed(2)} % of total spending',
                      style: context.appTexts.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹$amount',
                style: context.appTexts.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          UIHelpers.verticalSpace(12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 6.h,
              backgroundColor: isDark
                  ? AppColors.borderDark
                  : AppColors.borderLight,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    // This is a simple mapper, ideally use a utility
    switch (iconName.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_bus_rounded;
      case 'health':
        return Icons.medical_services_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
