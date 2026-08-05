import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../viewmodels/circle_details_notifier.dart';

void showSettleUpBottomSheet(
  BuildContext context,
  int circleId,
  int currentUserId,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        SettleUpBottomSheet(circleId: circleId, currentUserId: currentUserId),
  );
}

class SettleUpBottomSheet extends ConsumerWidget {
  final int circleId;
  final int currentUserId;

  const SettleUpBottomSheet({
    super.key,
    required this.circleId,
    required this.currentUserId,
  });

  void _showSettlementDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic member,
  ) {
    final absAmount = member.relationshipAmount.abs().toString();
    final amountController = TextEditingController(text: absAmount);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: context.colors.background,
        title: Text(
          'Settle up with ${member.fullName}',
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
              member.status == 'owes_you'
                  ? 'How much did they pay you?'
                  : 'How much did you pay them?',
              style: context.appTexts.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            UIHelpers.verticalSpace(16),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: context.appTexts.bodyMedium.copyWith(
                color: context.colors.textPrimary,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textPrimary,
                ),
                filled: true,
                fillColor: context.colors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: context.colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: context.colors.border),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              final amountStr = amountController.text.trim();
              final amount = double.tryParse(amountStr) ?? 0.0;
              if (amount <= 0) return;

              Navigator.pop(dialogCtx); // close dialog
              Navigator.pop(context); // close bottom sheet

              // Use the backend status as the source of truth.
              final paidByUserId = member.status == 'owes_you'
                  ? member.userId
                  : currentUserId;

              final paidToUserId = member.status == 'owes_you'
                  ? currentUserId
                  : member.userId;

              final error = await ref
                  .read(circleDetailsProvider(circleId).notifier)
                  .recordSettlement(
                    paidByUserId: paidByUserId,
                    paidToUserId: paidToUserId,
                    amount: amount,
                    currentUserId: currentUserId,
                  );

              if (context.mounted) {
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: AppColors.expense,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settlement recorded.'),
                      backgroundColor: AppColors.income,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsState = ref.watch(circleDetailsProvider(circleId));
    final members = detailsState.screenData?.members ?? [];

    // Filter to members who have a non-zero balance and are not self
    final settlableMembers = members
        .where((m) => !m.isSelf && m.relationshipAmount != 0)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        24.w,
        20.h,
        24.w,
        MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ),
          UIHelpers.verticalSpace(24),
          Text(
            'Settle Up',
            style: context.appTexts.heading.copyWith(
              fontSize: 22.sp,
              color: context.colors.primary,
            ),
          ),
          UIHelpers.verticalSpace(4),
          Text(
            'Select a member to settle your balances with',
            style: context.appTexts.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          UIHelpers.verticalSpace(24),
          if (settlableMembers.isEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Text(
                'No pending balances to settle.',
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: settlableMembers.length,
              itemBuilder: (context, index) {
                final member = settlableMembers[index];

                final initials = member.fullName.isNotEmpty
                    ? member.fullName
                          .trim()
                          .split(' ')
                          .map((e) => e.isNotEmpty ? e[0] : '')
                          .take(2)
                          .join()
                          .toUpperCase()
                    : 'M';

                final bool isOwed = member.status == 'owes_you';
                final String balanceText = isOwed
                    ? 'Owes ₹${member.relationshipAmount.abs()}'
                    : 'You owe ₹${member.relationshipAmount.abs()}';

                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Material(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(20.r),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      leading: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: isOwed ? AppColors.income : AppColors.expense,
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
                      title: Text(
                        member.fullName,
                        style: context.appTexts.bodyMedium.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        balanceText,
                        style: context.appTexts.bodySmall.copyWith(
                          color: isOwed ? AppColors.income : AppColors.expense,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: context.colors.textSecondary,
                      ),
                      onTap: () => _showSettlementDialog(context, ref, member),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
