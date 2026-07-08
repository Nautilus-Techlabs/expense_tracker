
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/entities/category.dart';
import '../viewmodels/transaction_notifier.dart';
import '../widgets/transaction_card.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  int _selectedMonthIndex = 5; // Default to 'Jun' for this mockup

  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);
    final controller = ref.read(transactionProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // For mockup purposes, we'll use a hardcoded list to demonstrate the UI
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final twoDaysAgo = today.subtract(const Duration(days: 2));

    final transactions = [
      Transaction(
        id: 1,
        amount: 450,
        type: TransactionType.debit,
        date: today,
        method: PaymentMethod.upi,
        merchant: 'Swiggy',
        bankName: 'HDFC Bank',
        category: const Category(id: 1, name: 'Food & Dining', icon: 'food'),
        isVerified: true,
      ),
      Transaction(
        id: 2,
        amount: 45000,
        type: TransactionType.credit,
        date: yesterday,
        method: PaymentMethod.neft,
        merchant: 'Salary',
        bankName: 'SBI Account',
        category: const Category(id: 2, name: 'Income', icon: 'salary'),
        isVerified: true,
      ),
      Transaction(
        id: 3,
        amount: 12000,
        type: TransactionType.debit,
        date: twoDaysAgo,
        method: PaymentMethod.upi,
        merchant: 'Rent',
        bankName: 'HDFC Bank',
        category: const Category(id: 3, name: 'Housing', icon: 'home'),
        isVerified: true,
      ),
      Transaction(
        id: 4,
        amount: 299,
        type: TransactionType.debit,
        date: twoDaysAgo,
        method: PaymentMethod.upi,
        merchant: 'Jio',
        bankName: 'Paytm Wallet',
        category: const Category(id: 4, name: 'Utilities', icon: 'phone'),
        isVerified: true,
      ),
      Transaction(
        id: 5,
        amount: 380,
        type: TransactionType.debit,
        date: twoDaysAgo,
        method: PaymentMethod.upi,
        merchant: 'Zomato',
        bankName: 'ICICI Bank',
        category: const Category(id: 1, name: 'Food & Dining', icon: 'food'),
        isVerified: true,
      ),
      Transaction(
        id: 6,
        amount: 8000,
        type: TransactionType.credit,
        date: twoDaysAgo,
        method: PaymentMethod.neft,
        merchant: 'Freelance',
        bankName: 'SBI Account',
        category: const Category(id: 2, name: 'Income', icon: 'salary'),
        isVerified: true,
      ),
    ];

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.syncTransactions,
          color: AppColors.primary,
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
                          Icon(
                            Icons.filter_alt_outlined,
                            size: 28.sp,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.primary,
                          ),
                          UIHelpers.horizontalSpace(16),
                          Icon(
                            Icons.search_rounded,
                            size: 28.sp,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.primary,
                          ),
                        ],
                      ),
                    ],
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
                    itemCount: _months.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedMonthIndex;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedMonthIndex = index),
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
                            _months[index],
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
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
                                    '₹${state.totalGlobalCredit.toStringAsFixed(0)}',
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
                                      '₹${state.totalGlobalDebit.toStringAsFixed(0)}',
                                      style: context.appTexts.amountExpense.copyWith(
                                        fontSize: 20.sp,
                                      ),
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
              if (transactions.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      "No transactions for this month.",
                      style: context.appTexts.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                )
              else
                ..._buildGroupedList(transactions, isDark),

              SliverPadding(padding: EdgeInsets.only(bottom: 100.h)),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGroupedList(List<Transaction> transactions, bool isDark) {
    final List<Widget> slivers = [];
    String? lastDate;

    for (final t in transactions) {
      final dateStr = _formatDateHeader(t.date);

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
              key: ValueKey('list_${t.id ?? t.rawSms}'),
              transaction: t,
              showDate: false,
              heroTag: 'hero_list_${t.id ?? t.rawSms}',
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
