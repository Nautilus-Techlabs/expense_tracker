import 'package:expense_tracker/core/cache/cache_manager.dart';
import 'package:expense_tracker/core/services/deep_link_service.dart';
import 'package:expense_tracker/core/widgets/app_top_bar.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:expense_tracker/features/circle/viewmodels/circle_notifier.dart';
import 'package:expense_tracker/features/circle/viewmodels/join_circle_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/account_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_router.dart';
import '../../../../core/constants/args.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/utils/ui_helpers.dart';

class JoinCircleScreen extends ConsumerStatefulWidget {
  final int circleId;

  const JoinCircleScreen({super.key, required this.circleId});

  @override
  ConsumerState<JoinCircleScreen> createState() => _JoinCircleScreenState();
}

class _JoinCircleScreenState extends ConsumerState<JoinCircleScreen> {
  // Local form state — kept as setState (ephemeral, scoped to this screen)
  bool _includeSettlements = false;
  int? _selectedAccountId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;

    final user = ref.read(authProvider).user;
    if (user == null) {
      context.pop();
      return;
    }

    // Clear the pending invite immediately so it doesn't re-trigger.
    ref.read(deepLinkProvider.notifier).clearPendingInvite();

    await ref.read(joinCircleProvider.notifier).loadCircleInfo(widget.circleId);
  }

  Future<void> _join() async {
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

    ref.read(joinCircleProvider.notifier).setJoining();

    await ref
        .read(circleProvider.notifier)
        .joinCircle(
          circleId: widget.circleId,
          includeSettlementsInPersonalLedger: _includeSettlements,
          settlementAccountId: _selectedAccountId,
        );

    if (!mounted) return;

    final circleState = ref.read(circleProvider);

    if (circleState.error != null) {
      ref.read(joinCircleProvider.notifier).setReady();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(circleState.error!),
          backgroundColor: AppColors.expense,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final joinState = ref.read(joinCircleProvider);
    final circleName = joinState.circleName;
    final circleId = widget.circleId;

    ref.read(cacheManagerProvider).saveProcessedInvite(widget.circleId);

    context.pop();
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

  void _decline() {
    ref.read(cacheManagerProvider).saveProcessedInvite(widget.circleId);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final joinState = ref.watch(joinCircleProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppTopBar(
        title: 'Join Circle',
        onBack: _decline,
      ),
      body: joinState.isLoadingInfo
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : joinState.hasFailed
          ? _buildErrorState(context)
          : SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: _buildContent(context, joinState),
            ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          Text(
            "Couldn't load this invite. Please try again.",
            textAlign: TextAlign.center,
            style: context.appTexts.bodyMedium.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          UIHelpers.verticalSpace(16),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: _init,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, JoinCircleState joinState) {
    final accounts = ref.watch(accountProvider).accounts;
    final joining = joinState.isJoining;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You have been invited to join:',
          style: context.appTexts.bodyMedium.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        UIHelpers.verticalSpace(16),
        // --- Circle info card ---
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
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
                      joinState.circleName,
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
                    joinState.ownerName,
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
            onChanged: joining
                ? null
                : (val) {
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
                items: accounts
                    .map(
                      (acc) => DropdownMenuItem<int>(
                        value: acc.id,
                        child: Text(acc.name),
                      ),
                    )
                    .toList(),
                onChanged: joining
                    ? null
                    : (val) => setState(() => _selectedAccountId = val),
              ),
            ),
          ),
        ],

        UIHelpers.verticalSpace(24),

        // --- Actions ---
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: joining ? null : _decline,
                child: Text(
                  'Decline',
                  style: TextStyle(color: context.colors.textSecondary),
                ),
              ),
            ),
            UIHelpers.horizontalSpace(12),
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: joining ? null : _join,
                child: joining
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Join Circle'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
