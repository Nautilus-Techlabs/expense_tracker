import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';
import '../../../core/utils/ui_helpers.dart';
import '../viewmodels/account_notifier.dart';
import '../models/account_model.dart';

class AccountsSettingsScreen extends ConsumerWidget {
  const AccountsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Accounts',
          style: context.appTexts.displayMedium.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: accountState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : accountState.accounts.isEmpty
              ? Center(
                  child: Text(
                    'No accounts found.\nAdd one to get started.',
                    textAlign: TextAlign.center,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  itemCount: accountState.accounts.length,
                  separatorBuilder: (context, index) => UIHelpers.verticalSpace(16),
                  itemBuilder: (context, index) {
                    final account = accountState.accounts[index];
                    return _AccountListItem(account: account, isDark: isDark);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.addAccount),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Account',
          style: context.appTexts.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AccountListItem extends StatelessWidget {
  final AccountModel account;
  final bool isDark;

  const _AccountListItem({required this.account, required this.isDark});

  IconData _getIcon() {
    switch (account.type) {
      case AccountType.bank:
        return Icons.account_balance_rounded;
      case AccountType.creditCard:
        return Icons.credit_card_rounded;
      case AccountType.cash:
        return Icons.money_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIcon(), color: AppColors.primary, size: 24.sp),
          ),
          UIHelpers.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: context.appTexts.bodyMedium.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                UIHelpers.verticalSpace(4),
                Text(
                  account.type.name.toUpperCase(),
                  style: context.appTexts.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 10.sp,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${account.balance.toStringAsFixed(0)}',
            style: context.appTexts.displaySmall.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
