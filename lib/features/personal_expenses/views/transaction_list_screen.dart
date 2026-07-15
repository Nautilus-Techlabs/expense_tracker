import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/transaction_model.dart';
import '../viewmodels/transaction_notifier.dart';
import '../viewmodels/category_notifier.dart';
import '../widgets/transaction_card.dart';
import 'package:go_router/go_router.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  DateTime? _selectedMonthDate;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;
  DateTime? _selectedSpecificDate;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DateTime> _generateMonths(List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      final now = DateTime.now();
      return [DateTime(now.year, now.month, 1)];
    }
    
    DateTime oldest = transactions.first.txnDate;
    for (var t in transactions) {
      if (t.txnDate.isBefore(oldest)) {
        oldest = t.txnDate;
      }
    }
    
    final now = DateTime.now();
    List<DateTime> months = [];
    
    DateTime current = DateTime(oldest.year, oldest.month, 1);
    final end = DateTime(now.year, now.month, 1);
    
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      months.add(current);
      current = DateTime(current.year, current.month + 1, 1);
    }
    
    return months;
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(
        initialCategoryId: _selectedCategoryId,
        initialSpecificDate: _selectedSpecificDate,
        onApply: (categoryId, specificDate) {
          setState(() {
            _selectedCategoryId = categoryId;
            _selectedSpecificDate = specificDate;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<DateTime> months = _generateMonths(state.transactions);
    _selectedMonthDate ??= months.last;

    final String search = _searchController.text.trim().toLowerCase();

    final filteredTransactions = state.transactions.where((t) {
      if (_selectedSpecificDate == null) {
        if (t.txnDate.year != _selectedMonthDate!.year || t.txnDate.month != _selectedMonthDate!.month) {
          return false;
        }
      } else {
        if (t.txnDate.year != _selectedSpecificDate!.year || 
            t.txnDate.month != _selectedSpecificDate!.month ||
            t.txnDate.day != _selectedSpecificDate!.day) {
          return false;
        }
      }

      if (_selectedCategoryId != null && t.categoryId != _selectedCategoryId) {
        return false;
      }

      if (search.isNotEmpty) {
        if (t.note == null || !t.note!.toLowerCase().contains(search)) {
          return false;
        }
      }

      return true;
    }).toList();

    final totalGlobalCredit = filteredTransactions
        .where((t) => t.type == 'income')
        .fold<double>(0, (sum, t) => sum + t.amount);

    final totalGlobalDebit = filteredTransactions
        .where((t) => t.type == 'expense' || t.type == 'withdrawal')
        .fold<double>(0, (sum, t) => sum + t.amount);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
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
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.primary,
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
                            color: _selectedCategoryId != null || _selectedSpecificDate != null
                                ? AppColors.expense
                                : (isDark ? AppColors.textPrimaryDark : AppColors.primary),
                          ),
                        ),
                        UIHelpers.horizontalSpace(16),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSearchVisible = !_isSearchVisible;
                              if (!_isSearchVisible) {
                                _searchController.clear();
                              }
                            });
                          },
                          child: Icon(
                            Icons.search_rounded,
                            size: 28.sp,
                            color: _isSearchVisible
                                ? AppColors.expense
                                : (isDark ? AppColors.textPrimaryDark : AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (_isSearchVisible)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
                  child: TextField(
                    controller: _searchController,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search notes...',
                      hintStyle: context.appTexts.bodyMedium.copyWith(
                        color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withValues(alpha: 0.5),
                      ),
                      prefixIcon: Icon(Icons.search, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      filled: true,
                      fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
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
                    final isSelected = monthDate.year == _selectedMonthDate!.year && monthDate.month == _selectedMonthDate!.month;
                    final monthString = DateFormat('MMM yyyy').format(monthDate);
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMonthDate = monthDate;
                          _selectedSpecificDate = null; // clear specific date when picking a month
                        });
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
                                : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
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
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
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
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
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
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
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
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
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
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  UIHelpers.verticalSpace(8),
                  Container(
                    height: 1.h,
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
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

class _FilterBottomSheet extends ConsumerStatefulWidget {
  final int? initialCategoryId;
  final DateTime? initialSpecificDate;
  final Function(int? categoryId, DateTime? specificDate) onApply;

  const _FilterBottomSheet({
    this.initialCategoryId,
    this.initialSpecificDate,
    required this.onApply,
  });

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  int? _selectedCategoryId;
  DateTime? _selectedSpecificDate;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
    _selectedSpecificDate = widget.initialSpecificDate;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedSpecificDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedSpecificDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryState = ref.watch(categoryProvider);
    
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grabber
          Center(
            child: Container(
              width: 48.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          UIHelpers.verticalSpace(24),
          
          Text(
            'Filters',
            style: context.appTexts.displayMedium.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontSize: 24.sp,
            ),
          ),
          UIHelpers.verticalSpace(24),

          // Date Filter
          Text(
            'Specific Date',
            style: context.appTexts.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          UIHelpers.verticalSpace(12),
          InkWell(
            onTap: _pickDate,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedSpecificDate != null 
                        ? DateFormat('MMM dd, yyyy').format(_selectedSpecificDate!) 
                        : 'Select Date',
                    style: context.appTexts.bodyMedium.copyWith(
                      color: _selectedSpecificDate != null
                          ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                          : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    ),
                  ),
                  Icon(Icons.calendar_today_rounded, size: 20.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ],
              ),
            ),
          ),
          UIHelpers.verticalSpace(24),

          // Category Filter
          Text(
            'Category',
            style: context.appTexts.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          UIHelpers.verticalSpace(12),
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: categoryState.categories.map((cat) {
              final isSelected = _selectedCategoryId == cat.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryId = isSelected ? null : cat.id;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                  ),
                  child: Text(
                    cat.name,
                    style: context.appTexts.bodySmall.copyWith(
                      color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          UIHelpers.verticalSpace(40),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategoryId = null;
                      _selectedSpecificDate = null;
                    });
                    widget.onApply(null, null);
                    context.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
                  ),
                  child: Text(
                    'Clear All',
                    style: context.appTexts.bodyMedium.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              UIHelpers.horizontalSpace(16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_selectedCategoryId, _selectedSpecificDate);
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Apply',
                    style: context.appTexts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
