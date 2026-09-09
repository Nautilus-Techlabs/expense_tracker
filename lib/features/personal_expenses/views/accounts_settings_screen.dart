import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_top_bar.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';
import '../../../core/utils/ui_helpers.dart';
import '../viewmodels/account_notifier.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../widgets/account_list_item.dart';

class AccountsSettingsScreen extends ConsumerWidget {
  const AccountsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppTopBar(title: 'Accounts'),
      body: accountState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : accountState.accounts.isEmpty
          ? Center(
              child: Text(
                'No accounts found.\nAdd one to get started.',
                textAlign: TextAlign.center,
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
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
                return AccountListItem(account: account);
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
