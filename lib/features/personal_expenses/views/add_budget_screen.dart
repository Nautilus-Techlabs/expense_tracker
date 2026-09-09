import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';
import '../../../core/theme/app_colors_extension.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../services/connectivity_provider.dart';
import '../viewmodels/budget_notifier.dart';

class AddBudgetScreen extends ConsumerStatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  final _amountController = TextEditingController();
  final DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final isOnline = ref.read(connectivityStreamProvider).value ?? false;
    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are currently offline. Operations are disabled.'),
        ),
      );
      return;
    }

    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText) ?? 0.0;

    if (amountText.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid budget amount')),
      );
      return;
    }

    final success = await ref
        .read(budgetProvider.notifier)
        .createOrUpdateBudget(amount: amount, month: _selectedMonth);

    if (success && mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRouter.transactions);
      }
    } else if (mounted) {
      final error = ref.read(budgetProvider).errorMessage;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error ?? 'Failed to set budget')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgetState = ref.watch(budgetProvider);
    final bg = context.colors.background;
    final textPrimary = context.colors.textPrimary;
    final textSecondary = context.colors.textSecondary;
    final borderColor = context.colors.border;
    final cardBg = context.colors.card;

    final monthName = DateFormat('MMMM yyyy').format(_selectedMonth);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppTopBar(
        title: 'Set Monthly Budget',
        showBack: context.canPop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.track_changes_rounded,
                    size: 80.sp,
                    color: AppColors.primary,
                  ),
                  UIHelpers.verticalSpace(24),
                  Text(
                    'Budget for $monthName',
                    style: context.appTexts.displaySmall.copyWith(
                      fontSize: 22.sp,
                    ),
                  ),
                  UIHelpers.verticalSpace(8),
                  Text(
                    'Setting a budget helps you stay on track with your financial goals.',
                    textAlign: TextAlign.center,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            UIHelpers.verticalSpace(40),
            Text(
              'Budget Amount',
              style: context.appTexts.bodySmall.copyWith(
                color: textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            UIHelpers.verticalSpace(12),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 8.w),
                    child: Text(
                      '₹',
                      style: context.appTexts.displaySmall.copyWith(
                        color: textPrimary,
                        fontSize: 24.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: context.appTexts.displaySmall.copyWith(
                        color: textPrimary,
                        fontSize: 24.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: context.appTexts.displaySmall.copyWith(
                          color: textSecondary.withAlpha(80),
                          fontSize: 24.sp,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 20.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            UIHelpers.verticalSpace(48),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: budgetState.isLoading ? null : _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                ),
                child: budgetState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'SET BUDGET',
                        style: context.appTexts.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          letterSpacing: 0.8,
                        ),
                      ),
              ),
            ),
            UIHelpers.verticalSpace(16),
            Center(
              child: TextButton(
                onPressed: () => context.go(AppRouter.transactions),
                child: Text(
                  'Skip for now',
                  style: context.appTexts.bodyMedium.copyWith(
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
