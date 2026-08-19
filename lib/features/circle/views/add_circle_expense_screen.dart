import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:expense_tracker/core/constants/args.dart';
import 'package:expense_tracker/core/theme/app_colors_extension.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/data/repositories/supabase_provider.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:expense_tracker/features/circle/models/circle_details_screen_model.dart';
import 'package:expense_tracker/features/circle/models/circle_transaction_payload.dart';
import 'package:expense_tracker/features/circle/viewmodels/add_circle_expense_form_notifier.dart';
import 'package:expense_tracker/features/circle/viewmodels/circle_all_transactions_notifier.dart';
import 'package:expense_tracker/features/circle/viewmodels/circle_details_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/account_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

enum SplitType { equal, percentage, fixed }

class AddCircleExpenseScreen extends ConsumerStatefulWidget {
  final AddCircleExpenseArgs args;

  const AddCircleExpenseScreen({super.key, required this.args});

  @override
  ConsumerState<AddCircleExpenseScreen> createState() =>
      _AddCircleExpenseScreenState();
}

class _AddCircleExpenseScreenState
    extends ConsumerState<AddCircleExpenseScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  // Controllers for per-member custom inputs (percentage or fixed amount)
  final Map<int, TextEditingController> _memberSplitControllers = {};

  @override
  void initState() {
    super.initState();
    for (final member in widget.args.members) {
      _memberSplitControllers[member.userId] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    for (final controller in _memberSplitControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<Member> _includedMembers(Set<int> includedMemberIds) {
    return widget.args.members
        .where((m) => includedMemberIds.contains(m.userId))
        .toList();
  }

  Future<void> _pickDate(BuildContext context, bool isDark) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: AppColors.primary,
                    onPrimary: Colors.white,
                    surface: AppColors.cardDark,
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: AppColors.primary,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  List<CircleSplitModel> _buildSplitsJson(
    double totalAmount,
    SplitType splitType,
    Set<int> includedMemberIds,
  ) {
    final activeMembers = _includedMembers(includedMemberIds);
    if (splitType == SplitType.equal) {
      // Equal split
      return activeMembers
          .map((m) => CircleSplitModel(userId: m.userId, splitType: 'equal'))
          .toList();
    } else if (splitType == SplitType.percentage) {
      // Percentage split
      final List<CircleSplitModel> splits = [];
      for (final m in activeMembers) {
        final pctStr = _memberSplitControllers[m.userId]?.text.trim() ?? '0';
        final pct = double.tryParse(pctStr) ?? 0.0;
        splits.add(
          CircleSplitModel(
            userId: m.userId,
            splitType: 'percentage',
            splitValue: pct,
          ),
        );
      }
      return splits;
    } else {
      // Fixed amount split
      final List<CircleSplitModel> splits = [];
      for (final m in activeMembers) {
        final amtStr = _memberSplitControllers[m.userId]?.text.trim() ?? '0';
        final amt = double.tryParse(amtStr) ?? 0.0;
        splits.add(
          CircleSplitModel(
            userId: m.userId,
            splitType: 'fixed',
            splitValue: amt,
          ),
        );
      }
      return splits;
    }
  }

  Future<void> _submit(
    AddCircleExpenseFormState formState,
    AddCircleExpenseFormNotifier formNotifier,
  ) async {
    final amountText = _amountController.text.trim();
    final totalAmount = double.tryParse(amountText);

    if (totalAmount == null || totalAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }

    if (formState.selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an account'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }

    if (formState.includedMemberIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one member to split with'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }

    final activeMembers = _includedMembers(formState.includedMemberIds);

    // Validation for split types
    if (formState.splitType == SplitType.percentage) {
      double totalPct = 0.0;
      for (final m in activeMembers) {
        final val =
            double.tryParse(
              _memberSplitControllers[m.userId]?.text.trim() ?? '0',
            ) ??
            0.0;
        totalPct += val;
      }
      if ((totalPct - 100.0).abs() > 0.01) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Percentages must add up to 100% (Currently ${totalPct.toStringAsFixed(1)}%)',
            ),
            backgroundColor: AppColors.expense,
          ),
        );
        return;
      }
    } else if (formState.splitType == SplitType.fixed) {
      double totalFixed = 0.0;
      for (final m in activeMembers) {
        final val =
            double.tryParse(
              _memberSplitControllers[m.userId]?.text.trim() ?? '0',
            ) ??
            0.0;
        totalFixed += val;
      }
      if ((totalFixed - totalAmount).abs() > 0.01) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Fixed amounts must add up to ₹$totalAmount (Currently ₹${totalFixed.toStringAsFixed(1)})',
            ),
            backgroundColor: AppColors.expense,
          ),
        );
        return;
      }
    }

    formNotifier.setSubmitting(true);

    final splitsPayload = _buildSplitsJson(
      totalAmount,
      formState.splitType,
      formState.includedMemberIds,
    );

    final result = await ref
        .read(supabaseHelperProvider)
        .createCircleTransaction(
          payload: CircleTransactionPayload(
            circleId: widget.args.circleId,
            accountId: formState.selectedAccountId!,
            categoryId: formState.selectedCategoryId!,
            type: 'expense',
            amount: totalAmount,
            txnDate: _selectedDate.toIso8601String().split('T').first,
            splits: splitsPayload,
          ),
        );

    formNotifier.setSubmitting(false);

    if (mounted) {
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: AppColors.expense,
            ),
          );
        },
        (txnId) {
          final currentUser = ref.read(authProvider).user;
          if (currentUser != null) {
            ref
                .read(circleDetailsProvider(widget.args.circleId).notifier)
                .fetchCircleDetails(currentUser.id);
            ref.invalidate(circleAllTransactionsProvider(widget.args.circleId));
          }
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Expense added successfully!'),
              backgroundColor: AppColors.income,
            ),
          );
        },
      );
    }
  }

  Widget _buildSplitTypeButton(
    String label,
    SplitType type,
    bool isDark,
    AddCircleExpenseFormState formState,
    AddCircleExpenseFormNotifier formNotifier,
  ) {
    final isSelected = formState.splitType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => formNotifier.updateSplitType(type),
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF333333) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: isSelected && !isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.appTexts.bodySmall.copyWith(
              color: isSelected
                  ? context.colors.textPrimary
                  : context.colors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accountsState = ref.watch(accountProvider);
    final accounts = accountsState.accounts;

    final categoriesState = ref.watch(categoryProvider);
    final categories = categoriesState.categories;

    final formState = ref.watch(
      addCircleExpenseFormStateProvider(widget.args.members),
    );
    final formNotifier = ref.read(
      addCircleExpenseFormStateProvider(widget.args.members).notifier,
    );

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: context.colors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add Circle Expense',
          style: context.appTexts.displayMedium.copyWith(
            color: context.colors.textPrimary,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelpers.verticalSpace(24),

                // Amount Input
                Text(
                  'Amount',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                UIHelpers.verticalSpace(8),
                TextField(
                  controller: _amountController,
                  scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 100,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: context.appTexts.displayMedium.copyWith(
                    color: context.colors.textPrimary,
                    fontSize: 28.sp,
                  ),
                  decoration: InputDecoration(
                    prefixText: '₹ ',
                    prefixStyle: context.appTexts.displayMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 28.sp,
                    ),
                    hintText: '0.00',
                    hintStyle: context.appTexts.displayMedium.copyWith(
                      color: context.colors.textSecondary.withValues(
                        alpha: 0.4,
                      ),
                      fontSize: 28.sp,
                    ),
                    filled: true,
                    fillColor: context.colors.card,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                UIHelpers.verticalSpace(16),

                // Note Input
                Text(
                  'Note / Description',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                UIHelpers.verticalSpace(8),
                TextField(
                  controller: _noteController,
                  scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 100,
                  ),
                  style: context.appTexts.bodyMedium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. Dinner at Fisherman\'s Wharf',
                    hintStyle: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textSecondary.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    filled: true,
                    fillColor: context.colors.card,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                UIHelpers.verticalSpace(16),

                // Date Picker
                Text(
                  'Date',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                UIHelpers.verticalSpace(8),
                GestureDetector(
                  onTap: () => _pickDate(context, isDark),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.card,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 20.sp,
                          color: AppColors.primary,
                        ),
                        UIHelpers.horizontalSpace(12),
                        Text(
                          DateFormat('dd MMM yyyy').format(_selectedDate),
                          style: context.appTexts.bodyMedium.copyWith(
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                UIHelpers.verticalSpace(16),

                // Paid By Dropdown
                Text(
                  'Paid By',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                UIHelpers.verticalSpace(8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: formState.paidByUserId,
                      isExpanded: true,
                      dropdownColor: context.colors.card,
                      style: context.appTexts.bodyMedium.copyWith(
                        color: context.colors.textPrimary,
                      ),
                      items: widget.args.members.map((m) {
                        return DropdownMenuItem<int>(
                          value: m.userId,
                          child: Text(m.fullName + (m.isSelf ? ' (You)' : '')),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) formNotifier.updatePaidByUserId(val);
                      },
                    ),
                  ),
                ),
                UIHelpers.verticalSpace(16),

                // Account & Category Row
                Row(
                  children: [
                    // Account Selector
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account',
                            style: context.appTexts.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                          UIHelpers.verticalSpace(8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            decoration: BoxDecoration(
                              color: context.colors.card,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: context.colors.border),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: formState.selectedAccountId,
                                isExpanded: true,
                                dropdownColor: context.colors.card,
                                hint: Text(
                                  'Account',
                                  style: context.appTexts.bodySmall.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                                style: context.appTexts.bodyMedium.copyWith(
                                  color: context.colors.textPrimary,
                                ),
                                items: accounts.map((acc) {
                                  return DropdownMenuItem<int>(
                                    value: acc.id,
                                    child: Text(
                                      acc.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) =>
                                    formNotifier.updateAccountId(val),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    UIHelpers.horizontalSpace(12),
                    // Category Selector
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category (Opt)',
                            style: context.appTexts.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                          UIHelpers.verticalSpace(8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            decoration: BoxDecoration(
                              color: context.colors.card,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: context.colors.border),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: formState.selectedCategoryId,
                                isExpanded: true,
                                dropdownColor: context.colors.card,
                                hint: Text(
                                  'Category',
                                  style: context.appTexts.bodySmall.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                                style: context.appTexts.bodyMedium.copyWith(
                                  color: context.colors.textPrimary,
                                ),
                                items: categories.map((cat) {
                                  return DropdownMenuItem<int>(
                                    value: cat.id,
                                    child: Text(
                                      cat.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) =>
                                    formNotifier.updateCategoryId(val),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                UIHelpers.verticalSpace(24),

                // Include Members Selection Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SPLIT WITH (${formState.includedMemberIds.length}/${widget.args.members.length})',
                      style: context.appTexts.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        formNotifier.setAllMembers(
                          widget.args.members,
                          formState.includedMemberIds.length !=
                              widget.args.members.length,
                        );
                      },
                      child: Text(
                        formState.includedMemberIds.length ==
                                widget.args.members.length
                            ? 'Deselect All'
                            : 'Select All',
                        style: context.appTexts.bodySmall.copyWith(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelpers.verticalSpace(8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Material(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(16.r),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: widget.args.members.map((m) {
                        final isIncluded = formState.includedMemberIds.contains(
                          m.userId,
                        );
                        return CheckboxListTile(
                          dense: true,
                          activeColor: AppColors.primary,
                          title: Text(
                            m.fullName + (m.isSelf ? ' (You)' : ''),
                            style: context.appTexts.bodyMedium.copyWith(
                              color: context.colors.textPrimary,
                              fontWeight: isIncluded
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          value: isIncluded,
                          onChanged: (checked) {
                            formNotifier.toggleMember(m.userId);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                UIHelpers.verticalSpace(24),

                // Split Options Segment
                Text(
                  'Split Option',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                UIHelpers.verticalSpace(8),
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cardDark
                        : const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Row(
                    children: [
                      _buildSplitTypeButton(
                        'Equal',
                        SplitType.equal,
                        isDark,
                        formState,
                        formNotifier,
                      ),
                      _buildSplitTypeButton(
                        'Percentage %',
                        SplitType.percentage,
                        isDark,
                        formState,
                        formNotifier,
                      ),
                      _buildSplitTypeButton(
                        'Fixed ₹',
                        SplitType.fixed,
                        isDark,
                        formState,
                        formNotifier,
                      ),
                    ],
                  ),
                ),
                UIHelpers.verticalSpace(16),

                // Member inputs for Percentage / Fixed Split
                if (formState.splitType != SplitType.equal) ...[
                  Text(
                    formState.splitType == SplitType.percentage
                        ? 'ENTER PERCENTAGES (Total: 100%)'
                        : 'ENTER FIXED AMOUNTS',
                    style: context.appTexts.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  UIHelpers.verticalSpace(12),
                  ..._includedMembers(formState.includedMemberIds).map((m) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              m.fullName + (m.isSelf ? ' (You)' : ''),
                              style: context.appTexts.bodyMedium.copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _memberSplitControllers[m.userId],
                              scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                    100,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              style: context.appTexts.bodyMedium.copyWith(
                                color: context.colors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                suffixText:
                                    formState.splitType == SplitType.percentage
                                    ? '%'
                                    : '₹',
                                suffixStyle: context.appTexts.bodySmall
                                    .copyWith(
                                      color: context.colors.textSecondary,
                                    ),
                                hintText: '0',
                                filled: true,
                                fillColor: context.colors.card,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: context.colors.border,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                    color: context.colors.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  UIHelpers.verticalSpace(16),
                ],

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: formState.isSubmitting
                        ? null
                        : () => _submit(formState, formNotifier),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      elevation: 0,
                    ),
                    child: formState.isSubmitting
                        ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Add Expense',
                            style: context.appTexts.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
