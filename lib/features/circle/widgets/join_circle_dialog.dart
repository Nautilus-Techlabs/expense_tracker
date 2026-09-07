import 'package:expense_tracker/core/services/deep_link_service.dart';
import 'package:expense_tracker/data/repositories/supabase_provider.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:expense_tracker/features/circle/viewmodels/circle_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/account_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_router.dart';
import '../../../../core/constants/args.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/ui_helpers.dart';

Future<void> showJoinCircleDialog({
  required BuildContext context,
  required WidgetRef ref,
  required int circleId,
}) async {
  final user = ref.read(authProvider).user;
  if (user == null) return;

  // Clear the pending invite immediately so it doesn't re-trigger
  ref.read(deepLinkProvider.notifier).clearPendingInvite();

  // --- Step 1: Show loading dialog while fetching circle info ---
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    ),
  );

  Map<String, String>? inviteInfo;
  try {
    final result = await ref
        .read(supabaseHelperProvider)
        .getCircleInviteInfo(circleId);
    result.fold(
      (failure) =>
          AppLogger.e('Failed to fetch circle info: ${failure.message}'),
      (info) => inviteInfo = info,
    );
  } catch (e) {
    AppLogger.e('Exception fetching circle info: $e');
  }

  if (!context.mounted) return;
  Navigator.pop(context); // Dismiss loading

  if (!context.mounted) return;

  final circleName = inviteInfo?['circleName'] ?? 'a circle';
  final ownerName = inviteInfo?['ownerName'] ?? 'someone';

  // --- Step 2: Show confirmation dialog with ledger options ---
  final result = await showDialog<({bool includeSettlements, int? accountId})>(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) =>
        _JoinCircleDialogContent(circleName: circleName, ownerName: ownerName),
  );

  if (result == null || !context.mounted) return;

  // --- Step 3: Show loading while calling addCircleMember ---
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    ),
  );

  await ref
      .read(circleProvider.notifier)
      .addCircleMember(
        circleId: circleId,
        targetUserId: user.id,
        includeSettlementsInPersonalLedger: result.includeSettlements,
        settlementAccountId: result.accountId,
      );

  if (!context.mounted) return;
  Navigator.pop(context); // Dismiss loading

  final circleState = ref.read(circleProvider);

  if (circleState.error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(circleState.error!),
        backgroundColor: AppColors.expense,
        behavior: SnackBarBehavior.floating,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You joined "$circleName"!'),
        backgroundColor: AppColors.income,
        behavior: SnackBarBehavior.floating,
      ),
    );

    context.push(
      AppRouter.circleDetails,
      extra: CircleDetailsArgs(circleId: circleId, circleName: circleName),
    );
  }
}

// ---------------------------------------------------------------------------
// Stateful dialog content — holds the toggle + account dropdown state
// ---------------------------------------------------------------------------

class _JoinCircleDialogContent extends ConsumerStatefulWidget {
  final String circleName;
  final String ownerName;

  const _JoinCircleDialogContent({
    required this.circleName,
    required this.ownerName,
  });

  @override
  ConsumerState<_JoinCircleDialogContent> createState() =>
      _JoinCircleDialogContentState();
}

class _JoinCircleDialogContentState
    extends ConsumerState<_JoinCircleDialogContent> {
  bool _includeSettlements = false;
  int? _selectedAccountId;

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountProvider).accounts;

    return AlertDialog(
      backgroundColor: context.colors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      contentPadding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      title: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.group_add_rounded,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
          UIHelpers.horizontalSpace(12),
          Expanded(
            child: Text(
              'Circle Invite',
              style: context.appTexts.heading.copyWith(
                fontSize: 20.sp,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelpers.verticalSpace(16),

            // --- Circle info card ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.groups_2_rounded,
                        color: AppColors.primary,
                        size: 18.sp,
                      ),
                      UIHelpers.horizontalSpace(8),
                      Expanded(
                        child: Text(
                          widget.circleName,
                          style: context.appTexts.heading.copyWith(
                            fontSize: 17.sp,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  UIHelpers.verticalSpace(8),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 16.sp,
                        color: context.colors.textSecondary,
                      ),
                      UIHelpers.horizontalSpace(6),
                      Text(
                        'Created by ',
                        style: context.appTexts.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      Text(
                        widget.ownerName,
                        style: context.appTexts.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            UIHelpers.verticalSpace(16),

            // --- Personal ledger toggle ---
            Container(
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: context.colors.border),
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 4.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                title: Text(
                  'Include settlements in personal ledger',
                  style: context.appTexts.bodyMedium.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Reflect circle settlements in your personal account balance',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                value: _includeSettlements,
                activeThumbColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _includeSettlements = val;
                    if (!val) _selectedAccountId = null;
                  });
                },
              ),
            ),

            // --- Settlement account dropdown (conditional) ---
            if (_includeSettlements) ...[
              UIHelpers.verticalSpace(12),
              Text(
                'SETTLEMENT ACCOUNT',
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
                    value: _selectedAccountId,
                    isExpanded: true,
                    dropdownColor: context.colors.card,
                    hint: Text(
                      'Select account',
                      style: context.appTexts.bodyMedium.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                    items: accounts.map((acc) {
                      return DropdownMenuItem<int>(
                        value: acc.id,
                        child: Text(acc.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _selectedAccountId = val);
                    },
                  ),
                ),
              ),
            ],

            UIHelpers.verticalSpace(8),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(
            'Decline',
            style: TextStyle(color: context.colors.textSecondary),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: () {
            if (_includeSettlements && _selectedAccountId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select a settlement account.'),
                  backgroundColor: AppColors.expense,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            Navigator.pop(context, (
              includeSettlements: _includeSettlements,
              accountId: _selectedAccountId,
            ));
          },
          child: const Text('Join Circle'),
        ),
      ],
    );
  }
}
