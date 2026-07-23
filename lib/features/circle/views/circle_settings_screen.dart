import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import '../../../../core/theme/app_colors_extension.dart';

class CircleSettingsScreen extends StatefulWidget {
  final String circleName;

  const CircleSettingsScreen({
    super.key,
    required this.circleName,
  });

  @override
  State<CircleSettingsScreen> createState() => _CircleSettingsScreenState();
}

class _CircleSettingsScreenState extends State<CircleSettingsScreen> {
  // Mock data for UI representation
  bool isOwner = true; // Toggle to test both owner and member view
  List<Map<String, dynamic>> members = [
    {'name': 'Rajesh Kumar', 'initials': 'RK', 'role': 'Owner', 'color': AppColors.primary},
    {'name': 'Amit Khanna', 'initials': 'AK', 'role': 'Member', 'color': const Color(0xFF7B3B1D)},
    {'name': 'Priya Sharma', 'initials': 'PS', 'role': 'Member', 'color': const Color(0xFF7C3AED)},
  ];

  void _removeMember(int index) {
    setState(() {
      members.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Member removed'),
        backgroundColor: AppColors.expense,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addMockMember() {
    setState(() {
      members.add({
        'name': 'New Member ${members.length + 1}',
        'initials': 'NM',
        'role': 'Member',
        'color': Colors.teal,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Member added (Mock)'),
        backgroundColor: AppColors.income,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            // --- Owner Mode Toggle (For Testing UI) ---
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: context.colors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Simulate Owner View',
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch.adaptive(
                    value: isOwner,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        isOwner = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            UIHelpers.verticalSpace(24),

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
                    widget.circleName,
                    style: context.appTexts.bodyLarge.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  UIHelpers.verticalSpace(4),
                  Text(
                    'Ongoing Circle • Split Enabled',
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
                if (isOwner)
                  GestureDetector(
                    onTap: _addMockMember,
                    child: Text(
                      '+ Add Member',
                      style: context.appTexts.bodySmall.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            UIHelpers.verticalSpace(12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final isCurrentMemberOwner = member['role'] == 'Owner';
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
                      UIHelpers.horizontalSpace(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member['name'],
                              style: context.appTexts.bodyMedium.copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            UIHelpers.verticalSpace(2),
                            Text(
                              member['role'],
                              style: context.appTexts.bodySmall.copyWith(
                                color: isCurrentMemberOwner
                                    ? AppColors.primary
                                    : context.colors.textSecondary,
                                fontWeight: isCurrentMemberOwner
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isOwner && !isCurrentMemberOwner)
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.expense,
                          ),
                          onPressed: () => _removeMember(index),
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
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Leaving circle... (Mock)'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
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
                      const Icon(Icons.exit_to_app_rounded, color: AppColors.expense),
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
                          'Are you sure you want to delete this circle? This action cannot be undone.',
                          style: context.appTexts.bodyMedium.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: context.colors.textSecondary),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Dialog
                              context.pop(); // Settings
                              context.pop(); // Details
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Circle deleted (Mock)'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
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
                      const Icon(Icons.delete_forever_rounded, color: Colors.white),
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
