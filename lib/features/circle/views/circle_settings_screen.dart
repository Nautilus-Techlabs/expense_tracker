import 'package:expense_tracker/core/constants/args.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:expense_tracker/features/circle/viewmodels/circle_details_notifier.dart';
import 'package:expense_tracker/features/circle/viewmodels/circle_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors_extension.dart';
import '../../../core/constants/app_constants.dart';

class CircleSettingsScreen extends ConsumerStatefulWidget {
  final CircleSettingsArgs args;

  const CircleSettingsScreen({super.key, required this.args});

  @override
  ConsumerState<CircleSettingsScreen> createState() =>
      _CircleSettingsScreenState();
}

class _CircleSettingsScreenState extends ConsumerState<CircleSettingsScreen> {
  Future<void> _leaveCircle(int userId) async {
    final success = await ref.read(circleProvider.notifier).leaveCircle(
          circleId: widget.args.circleId,
          currentUserId: userId,
        );

    if (mounted) {
      if (success) {
        context.pop(); // Settings
        context.pop(); // Details
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You left the circle.'),
            backgroundColor: AppColors.income,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        final error =
            ref.read(circleProvider).error ?? 'Failed to leave circle.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.expense,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _deleteCircle(int userId) async {
    final success = await ref.read(circleProvider.notifier).deleteCircle(
          circleId: widget.args.circleId,
          currentUserId: userId,
        );

    if (mounted) {
      if (success) {
        context.pop(); // Settings
        context.pop(); // Details
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Circle deleted successfully.'),
            backgroundColor: AppColors.income,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        final error =
            ref.read(circleProvider).error ?? 'Failed to delete circle.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.expense,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _removeMember(int targetUserId, int currentUserId) async {
    final success = await ref.read(circleProvider.notifier).removeCircleMember(
          circleId: widget.args.circleId,
          targetUserId: targetUserId,
          currentUserId: currentUserId,
        );

    if (mounted) {
      if (success) {
        // Refresh details screen data
        ref
            .read(circleDetailsProvider(widget.args.circleId).notifier)
            .fetchCircleDetails(currentUserId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Member removed.'),
            backgroundColor: AppColors.income,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        final error =
            ref.read(circleProvider).error ?? 'Failed to remove member.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.expense,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _transferOwnership(int newOwnerUserId, int currentUserId) async {
    final success =
        await ref.read(circleProvider.notifier).transferCircleOwnership(
              circleId: widget.args.circleId,
              newOwnerUserId: newOwnerUserId,
              currentUserId: currentUserId,
            );

    if (mounted) {
      if (success) {
        // Refresh the details screen
        ref
            .read(circleDetailsProvider(widget.args.circleId).notifier)
            .fetchCircleDetails(currentUserId);

        context.pop(); // Pop settings
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ownership transferred successfully.'),
            backgroundColor: AppColors.income,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        final error =
            ref.read(circleProvider).error ?? 'Failed to transfer ownership.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.expense,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider).user;
    final currentUserId = currentUser?.id ?? 0;

    final detailsState =
        ref.watch(circleDetailsProvider(widget.args.circleId));
    final screenData = detailsState.screenData;
    final members = screenData?.members ?? [];

    final isOwner = widget.args.ownerId == currentUserId ||
        members.any(
          (m) => m.userId == currentUserId && m.role.toLowerCase() == 'owner',
        );

    final circleType = screenData?.type ?? 'ongoing';

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20.sp,
            color: context.colors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: context.appTexts.heading.copyWith(
            color: context.colors.primary,
            fontSize: 24.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section: Circle Info ---
            Text(
              'CIRCLE DETAILS',
              style: context.appTexts.bodySmall.copyWith(
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            UIHelpers.verticalSpace(12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: context.colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.args.circleName,
                    style: context.appTexts.bodyLarge.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  UIHelpers.verticalSpace(4),
                  Text(
                    '${circleType.toUpperCase()} Circle',
                    style: context.appTexts.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            UIHelpers.verticalSpace(24),

            // --- Section: Members ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MEMBERS (${members.length})',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            UIHelpers.verticalSpace(12),

            if (members.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Text(
                  'No member information available.',
                  style: context.appTexts.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final isMemberOwner = member.role.toLowerCase() == 'owner';
                  final initials = member.fullName.isNotEmpty
                      ? member.fullName
                          .trim()
                          .split(' ')
                          .map((e) => e.isNotEmpty ? e[0] : '')
                          .take(2)
                          .join()
                          .toUpperCase()
                      : 'M';

                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: context.colors.card,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initials,
                            style: context.appTexts.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        UIHelpers.horizontalSpace(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.fullName +
                                    (member.isSelf ? ' (You)' : ''),
                                style: context.appTexts.bodyMedium.copyWith(
                                  color: context.colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              UIHelpers.verticalSpace(2),
                              Text(
                                member.role.toUpperCase(),
                                style: context.appTexts.bodySmall.copyWith(
                                  color: isMemberOwner
                                      ? AppColors.primary
                                      : context.colors.textSecondary,
                                  fontWeight: isMemberOwner
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isOwner && !isMemberOwner && !member.isSelf)
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.expense,
                            ),
                            onPressed: () =>
                                _removeMember(member.userId, currentUserId),
                          ),
                      ],
                    ),
                  );
                },
              ),
            UIHelpers.verticalSpace(32),

            // --- Section: Actions ---
            if (!isOwner)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _leaveCircle(currentUserId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.expense.withValues(alpha: 0.1),
                    foregroundColor: AppColors.expense,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.exit_to_app_rounded,
                        color: AppColors.expense,
                      ),
                      UIHelpers.horizontalSpace(8),
                      Text(
                        'Leave Circle',
                        style: context.appTexts.heading.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.expense,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isOwner) ...[
              // Transfer Ownership Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Filter non-owner members who can receive ownership
                    final transferCandidates = members
                        .where((m) =>
                            !m.isSelf &&
                            m.role.toLowerCase() != 'owner')
                        .toList();

                    if (transferCandidates.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'No other members to transfer ownership to.'),
                          backgroundColor: AppColors.expense,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        backgroundColor: context.colors.background,
                        title: Text(
                          'Transfer Ownership',
                          style: context.appTexts.heading.copyWith(
                            fontSize: 20.sp,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select the new owner. You will become a member after transferring.',
                              style: context.appTexts.bodySmall.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                            UIHelpers.verticalSpace(16),
                            ...transferCandidates.map((m) {
                              final initials = m.fullName.isNotEmpty
                                  ? m.fullName
                                      .trim()
                                      .split(' ')
                                      .map((e) =>
                                          e.isNotEmpty ? e[0] : '')
                                      .take(2)
                                      .join()
                                      .toUpperCase()
                                  : 'M';
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Material(
                                  color: context.colors.card,
                                  borderRadius:
                                      BorderRadius.circular(12.r),
                                  clipBehavior: Clip.antiAlias,
                                  child: ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(
                                            horizontal: 12.w),
                                    leading: Container(
                                      width: 36.w,
                                      height: 36.w,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        initials,
                                        style: context
                                            .appTexts.bodySmall
                                            .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      m.fullName,
                                      style: context
                                          .appTexts.bodyMedium
                                          .copyWith(
                                        color:
                                            context.colors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      m.role.toUpperCase(),
                                      style: context
                                          .appTexts.bodySmall
                                          .copyWith(
                                        color: context
                                            .colors.textSecondary,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14.sp,
                                      color:
                                          context.colors.textSecondary,
                                    ),
                                    onTap: () {
                                      Navigator.pop(
                                          dialogContext); // close picker
                                      // Confirm transfer
                                      showDialog(
                                        context: context,
                                        builder: (confirmCtx) =>
                                            AlertDialog(
                                          backgroundColor:
                                              context.colors.background,
                                          title: Text(
                                            'Confirm Transfer',
                                            style: context
                                                .appTexts.heading
                                                .copyWith(
                                              fontSize: 20.sp,
                                              color: context
                                                  .colors.textPrimary,
                                            ),
                                          ),
                                          content: Text(
                                            'Transfer ownership to ${m.fullName}? You will become a regular member.',
                                            style: context
                                                .appTexts.bodyMedium
                                                .copyWith(
                                              color: context
                                                  .colors.textSecondary,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      confirmCtx),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: context.colors
                                                      .textSecondary,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    confirmCtx);
                                                _transferOwnership(
                                                  m.userId,
                                                  currentUserId,
                                                );
                                              },
                                              child: const Text(
                                                'Transfer',
                                                style: TextStyle(
                                                    color: AppColors
                                                        .primary),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary.withValues(alpha: 0.1),
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.swap_horiz_rounded,
                        color: AppColors.primary,
                      ),
                      UIHelpers.horizontalSpace(8),
                      Text(
                        'Transfer Ownership',
                        style: context.appTexts.heading.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              UIHelpers.verticalSpace(12),
              // Delete Circle Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: context.colors.background,
                        title: Text(
                          'Delete Circle',
                          style: context.appTexts.heading.copyWith(
                            fontSize: 20.sp,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to delete this circle? This action cannot be undone and is blocked if any members have outstanding balances.',
                          style: context.appTexts.bodyMedium.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              _deleteCircle(currentUserId);
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: AppColors.expense),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.expense,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.white,
                      ),
                      UIHelpers.horizontalSpace(8),
                      Text(
                        'Delete Circle',
                        style: context.appTexts.heading.copyWith(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
