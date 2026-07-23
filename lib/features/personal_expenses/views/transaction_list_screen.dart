import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/transaction_model.dart';

import '../viewmodels/category_notifier.dart';
import '../viewmodels/transaction_filter_notifier.dart';
import '../viewmodels/filtered_transactions_provider.dart';
import '../widgets/transaction_card.dart';
import '../widgets/transaction_filter_sheet.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors_extension.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref
          .read(transactionFilterProvider.notifier)
          .setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _showFilterSheet() {
    final filterState = ref.read(transactionFilterProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionFilterSheet(
        initialCategoryId: filterState.selectedCategoryId,
        initialSpecificDate: filterState.selectedSpecificDate,
        onApply: (categoryId, specificDate) {
          ref.read(transactionFilterProvider.notifier).setFilters(
                categoryId: categoryId,
                specificDate: specificDate,
              );
        },
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filterState = ref.watch(transactionFilterProvider);

    final filteredData = ref.watch(filteredTransactionsProvider);
    final months = filteredData.availableMonths;
    final selectedMonthDate = filterState.selectedMonthDate ?? months.last;

    final filteredTransactions = filteredData.filteredTransactions;
    final totalGlobalCredit = filteredData.totalCredit;
    final totalGlobalDebit = filteredData.totalDebit;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 1. Header (Transactions + Icons)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transactions',
                      style: context.appTexts.displayMedium.copyWith(
                        color: context.colors.primary,
                        fontSize: 32.sp,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _showFilterSheet,
                          child: Icon(
                            Icons.filter_alt_outlined,
                            size: 28.sp,
                            color: filterState.selectedCategoryId != null ||
                                    filterState.selectedSpecificDate != null
                                ? AppColors.expense
                                : (context.colors.primary),
                          ),
                        ),
                        UIHelpers.horizontalSpace(16),
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(transactionFilterProvider.notifier)
                                .toggleSearchVisible();
                            if (filterState.isSearchVisible) {
                              // If it was visible and we're toggling it off, clear the controller
                              _searchController.clear();
                            }
                          },
                          child: Icon(
                            Icons.search_rounded,
                            size: 28.sp,
                            color: filterState.isSearchVisible
                                ? AppColors.expense
                                : (context.colors.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (filterState.isSearchVisible)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
                  child: TextField(
                    controller: _searchController,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search notes...',
                      hintStyle: context.appTexts.bodyMedium.copyWith(
                        color: (context.colors.textSecondary).withValues(alpha: 0.5),
                      ),
                      prefixIcon: Icon(Icons.search, color: context.colors.textSecondary),
                      filled: true,
                      fillColor: context.colors.card,
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),

            // 2. Month Selector
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    final monthDate = months[index];
                    final isSelected = monthDate.year == selectedMonthDate.year &&
                        monthDate.month == selectedMonthDate.month;
                    final monthString =
                        DateFormat('MMM yyyy').format(monthDate);

                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(transactionFilterProvider.notifier)
                            .setMonthDate(monthDate);
                        ref
                            .read(transactionFilterProvider.notifier)
                            .clearFilters(); // clear specific date when picking a month
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          monthString,
                          style: context.appTexts.bodyMedium.copyWith(
                            color: isSelected
                                ? Colors.white
                                : (context.colors.textSecondary),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 3. Summary Card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 24.w,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cardDark
                        : const Color(
                            0xFFF0F0E9,
                          ), // Slightly darker cream for contrast in light mode
                    borderRadius: BorderRadius.circular(16.r),
                    border: isDark
                        ? Border.all(color: AppColors.borderDark)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Income',
                              style: context.appTexts.bodyMedium.copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            UIHelpers.verticalSpace(4),
                            Row(
                              children: [
                                Text(
                                  '₹${totalGlobalCredit.toStringAsFixed(0)}',
                                  style: context.appTexts.amountIncome.copyWith(
                                    fontSize: 20.sp,
                                  ),
                                ),
                                UIHelpers.horizontalSpace(4),
                                Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 16.sp,
                                  color: AppColors.income,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1.w,
                        height: 40.h,
                        color: context.colors.border,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expense',
                                style: context.appTexts.bodyMedium.copyWith(
                                  color: context.colors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              UIHelpers.verticalSpace(4),
                              Row(
                                children: [
                                  Text(
                                    '₹${totalGlobalDebit.toStringAsFixed(0)}',
                                    style: context.appTexts.amountExpense
                                        .copyWith(fontSize: 20.sp),
                                  ),
                                  UIHelpers.horizontalSpace(4),
                                  Icon(
                                    Icons.arrow_downward_rounded,
                                    size: 16.sp,
                                    color: AppColors.expense,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 4. Transactions List
            if (filteredTransactions.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    "No transactions found.",
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ..._buildGroupedList(filteredTransactions, isDark),

            SliverPadding(padding: EdgeInsets.only(bottom: 100.h)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGroupedList(
    List<TransactionModel> transactions,
    bool isDark,
  ) {
    final List<Widget> slivers = [];
    String? lastDate;

    for (final t in transactions) {
      final dateStr = _formatDateHeader(t.txnDate);

      // If it's a new date, add a header
      if (dateStr != lastDate) {
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateStr,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  UIHelpers.verticalSpace(8),
                  Container(
                    height: 1.h,
                    color: context.colors.border,
                  ),
                ],
              ),
            ),
          ),
        );
        lastDate = dateStr;
      }

      // Add the transaction card
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: TransactionCard(
              key: ValueKey('list_${t.id}'),
              transaction: t,
              showDate: false,
              heroTag: 'hero_list_${t.id}',
            ),
          ),
        ),
      );
    }

    return slivers;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tDate = DateTime(date.year, date.month, date.day);

    if (tDate == today) {
      return "Today";
    } else if (tDate == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat('dd MMM').format(date);
    }
  }
}

