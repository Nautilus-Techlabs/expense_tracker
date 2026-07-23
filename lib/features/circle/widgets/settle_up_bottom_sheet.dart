import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/theme/app_colors_extension.dart';

void showSettleUpBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const SettleUpBottomSheet(),
  );
}

class SettleUpBottomSheet extends StatelessWidget {
  const SettleUpBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> members = [
      {'name': 'Amit Khanna', 'initials': 'AK', 'balance': 'Owes ₹1,200', 'color': const Color(0xFF7B3B1D), 'isOwed': false},
      {'name': 'Priya Sharma', 'initials': 'PS', 'balance': 'Settled', 'color': const Color(0xFF7C3AED), 'isOwed': false},
      {'name': 'Rajesh Kumar', 'initials': 'RK', 'balance': 'Is Owed ₹3,600', 'color': AppColors.primary, 'isOwed': true},
    ];

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
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, MediaQuery.of(context).viewInsets.bottom + 24.h),
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    leading: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: member['color'],
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        member['initials'],
                        style: context.appTexts.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      member['name'],
                      style: context.appTexts.bodyMedium.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      member['balance'],
                      style: context.appTexts.bodySmall.copyWith(
                        color: member['balance'] == 'Settled'
                            ? AppColors.income
                            : member['isOwed']
                                ? AppColors.primary
                                : AppColors.expense,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: context.colors.textSecondary,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Settling up with ${member['name']}... (Mock)'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
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
