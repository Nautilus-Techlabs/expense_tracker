import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';
import '../../../core/utils/ui_helpers.dart';
import '../models/account_model.dart';
import '../viewmodels/account_notifier.dart';

class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({super.key});

  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  AccountType _selectedType = AccountType.bank;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _onSave() async {
    final name = _nameController.text.trim();
    final balanceText = _balanceController.text.trim();
    final balance = double.tryParse(balanceText) ?? 0.0;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an account name')),
      );
      return;
    }

    if (balanceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter current balance')),
      );
      return;
    }

    final success = await ref
        .read(accountProvider.notifier)
        .createAccount(name: name, type: _selectedType, balance: balance);

    if (success && mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRouter.addBudget);
      }
    } else if (mounted) {
      final error = ref.read(accountProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Failed to create account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'Add Account',
          style: context.appTexts.heading.copyWith(fontSize: 20.sp),
        ),
        leading: context.canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, size: 20.sp),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Type',
              style: context.appTexts.bodySmall.copyWith(
                color: textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            UIHelpers.verticalSpace(12),
            Row(
              children: [
                _TypeChip(
                  label: 'Bank',
                  icon: Icons.account_balance_rounded,
                  isSelected: _selectedType == AccountType.bank,
                  onTap: () => setState(() => _selectedType = AccountType.bank),
                  isDark: isDark,
                ),
                UIHelpers.horizontalSpace(12),
                _TypeChip(
                  label: 'Cash',
                  icon: Icons.payments_rounded,
                  isSelected: _selectedType == AccountType.cash,
                  onTap: () => setState(() => _selectedType = AccountType.cash),
                  isDark: isDark,
                ),
                /*
                UIHelpers.horizontalSpace(12),
                _TypeChip(
                  label: 'Credit Card',
                  icon: Icons.credit_card_rounded,
                  isSelected: _selectedType == AccountType.creditCard,
                  onTap: () => setState(() => _selectedType = AccountType.creditCard),
                  isDark: isDark,
                ),
                */
              ],
            ),
            UIHelpers.verticalSpace(32),
            Text(
              'Account Name',
              style: context.appTexts.bodySmall.copyWith(
                color: textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            UIHelpers.verticalSpace(8),
            _InputField(
              controller: _nameController,
              hint: 'e.g. HDFC Salary, Wallet',
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
            ),
            UIHelpers.verticalSpace(24),
            Text(
              'Current Balance',
              style: context.appTexts.bodySmall.copyWith(
                color: textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            UIHelpers.verticalSpace(8),
            _InputField(
              controller: _balanceController,
              hint: '0.00',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              prefix: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 8.w),
                child: Text(
                  '₹',
                  style: context.appTexts.bodyLarge.copyWith(
                    color: textPrimary,
                  ),
                ),
              ),
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
            ),
            UIHelpers.verticalSpace(48),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: accountState.isLoading ? null : _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                ),
                child: accountState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'CREATE ACCOUNT',
                        style: context.appTexts.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          letterSpacing: 0.8,
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

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final inactiveColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withAlpha(20) : inactiveColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? activeColor : borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? activeColor
                    : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
                size: 24.sp,
              ),
              UIHelpers.verticalSpace(8),
              Text(
                label,
                style: context.appTexts.bodySmall.copyWith(
                  color: isSelected
                      ? activeColor
                      : (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final Widget? prefix;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;

  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.prefix,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          if (prefix != null) prefix!,
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: context.appTexts.bodyMedium.copyWith(color: textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: context.appTexts.bodyMedium.copyWith(
                  color: textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
