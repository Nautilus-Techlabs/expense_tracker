import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';

// ─── Data Models (local, until a real backend is wired up) ────────────────────

enum CircleType { oneTime, ongoing }

class CircleMember {
  final String initials;
  final Color color;
  const CircleMember({required this.initials, required this.color});
}

class CircleData {
  final String name;
  final CircleType type;
  final List<CircleMember> members;
  final double totalAmount;
  final double? pending; // for one-time circles
  final double? yourShare; // for ongoing circles
  final double? youOwe; // for ongoing circles where user owes
  final String lastActivity;
  final double settlementProgress; // 0.0 – 1.0 (for one-time circles)

  const CircleData({
    required this.name,
    required this.type,
    required this.members,
    required this.totalAmount,
    this.pending,
    this.yourShare,
    this.youOwe,
    required this.lastActivity,
    this.settlementProgress = 0,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class CirclesScreen extends StatelessWidget {
  const CirclesScreen({super.key});

  // Mock data matching the design screenshots
  static const _circles = [
    CircleData(
      name: 'Goa Trip',
      type: CircleType.oneTime,
      members: [
        CircleMember(initials: 'RK', color: AppColors.primary),
        CircleMember(initials: 'AM', color: AppColors.expense),
        CircleMember(initials: 'PR', color: Color(0xFF7C3AED)),
      ],
      totalAmount: 3600,
      pending: 1200,
      lastActivity: '',
      settlementProgress: 0.5,
    ),
    CircleData(
      name: 'Flat Expenses',
      type: CircleType.ongoing,
      members: [
        CircleMember(initials: 'RK', color: AppColors.primary),
        CircleMember(initials: 'AM', color: AppColors.expense),
        CircleMember(initials: 'PR', color: Color(0xFF7C3AED)),
        CircleMember(initials: 'SJ', color: Color(0xFFB45309)),
      ],
      totalAmount: 8400,
      yourShare: 2100,
      lastActivity: '2 days ago',
      settlementProgress: 0,
    ),
    CircleData(
      name: 'Family',
      type: CircleType.ongoing,
      members: [
        CircleMember(initials: 'RK', color: AppColors.primary),
        CircleMember(initials: 'AM', color: AppColors.expense),
        CircleMember(initials: 'PR', color: Color(0xFF7C3AED)),
        CircleMember(initials: 'SJ', color: Color(0xFFB45309)),
        CircleMember(initials: 'KL', color: Color(0xFF0891B2)),
      ],
      totalAmount: 12000,
      youOwe: 800,
      lastActivity: 'Today',
      settlementProgress: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // ── Header ──────────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Circles',
                            style: AppTexts.displayMedium.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.primary,
                              fontSize: 32.sp,
                            ),
                          ),
                          _AddButton(isDark: isDark),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // ── Owed / Owe Summary ───────────────────────────────
                    _SummaryBanner(isDark: isDark),
                    SizedBox(height: 24.h),

                    // ── Circle Cards ─────────────────────────────────────
                    ..._circles.map(
                      (c) => _CircleCard(circle: c, isDark: isDark),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // ── Create a new circle Button ───────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.primary,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  minimumSize: Size(double.infinity, 52.h),
                ),
                child: Text(
                  'Create a new circle',
                  style: AppTexts.bodyLarge.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.primary,
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

// ─── Sub-Widgets ──────────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  final bool isDark;
  const _AddButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add_rounded, color: Colors.white, size: 22.sp),
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final bool isDark;
  const _SummaryBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Light mode: pill container. Dark mode: two side-by-side stats.
    if (isDark) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You are owed ₹2,400',
                    style: AppTexts.bodyMedium.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
            Container(width: 1.w, height: 28.h, color: AppColors.borderDark),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Text(
                  'You owe ₹800',
                  style: AppTexts.bodyMedium.copyWith(color: AppColors.expense),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Light mode pill
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : const Color(0xFFF0F0E9),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_downward_rounded,
                  size: 16.sp,
                  color: AppColors.income,
                ),
                SizedBox(width: 6.w),
                Text(
                  'YOU ARE OWED ₹2,400',
                  style: AppTexts.bodySmall.copyWith(
                    color: AppColors.income,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_upward_rounded,
                  size: 16.sp,
                  color: AppColors.expense,
                ),
                SizedBox(width: 6.w),
                Text(
                  'YOU OWE ₹800',
                  style: AppTexts.bodySmall.copyWith(
                    color: AppColors.expense,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleCard extends StatelessWidget {
  final CircleData circle;
  final bool isDark;
  const _CircleCard({required this.circle, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final isOneTime = circle.type == CircleType.oneTime;

    return GestureDetector(
      onTap: () {
        context.push(AppRouter.circleDetails, extra: circle.name);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Type badge + member avatars ──
            Row(
              children: [
                _TypeBadge(
                  label: isOneTime ? 'ONE-TIME' : 'ONGOING',
                  isDark: isDark,
                ),
                const Spacer(),
                _MemberAvatarStack(members: circle.members),
              ],
            ),
            SizedBox(height: 12.h),

            // ── Name + chevron ──
            Row(
              children: [
                Expanded(
                  child: Text(
                    circle.name,
                    style: AppTexts.displayMedium.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.primary,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.sp,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ],
            ),
            SizedBox(height: 4.h),

            // ── Member count ──
            Row(
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 15.sp,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                SizedBox(width: 6.w),
                Text(
                  '${circle.members.length} members',
                  style: AppTexts.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // ── Amount stats ──
            if (isOneTime) ...[
              Row(
                children: [
                  _StatColumn(
                    label: 'You paid',
                    value: '₹${circle.totalAmount.toStringAsFixed(0)}',
                    isDark: isDark,
                    valueColor: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  SizedBox(width: 32.w),
                  _StatColumn(
                    label: 'Pending',
                    value: '₹${circle.pending!.toStringAsFixed(0)}',
                    isDark: isDark,
                    valueColor: AppColors.expense,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Settlement progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settlement Progress',
                    style: AppTexts.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(circle.settlementProgress * 100).toStringAsFixed(0)}%',
                    style: AppTexts.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: circle.settlementProgress,
                  minHeight: 6.h,
                  backgroundColor: isDark
                      ? AppColors.borderDark
                      : const Color(0xFFE5E5E0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  _StatColumn(
                    label: 'This month',
                    value: '₹${circle.totalAmount.toStringAsFixed(0)}',
                    isDark: isDark,
                    valueColor: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  SizedBox(width: 32.w),
                  if (circle.yourShare != null)
                    _StatColumn(
                      label: 'Your share',
                      value: '₹${circle.yourShare!.toStringAsFixed(0)}',
                      isDark: isDark,
                      valueColor: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  if (circle.youOwe != null)
                    _StatColumn(
                      label: 'You owe',
                      value: '₹${circle.youOwe!.toStringAsFixed(0)}',
                      isDark: isDark,
                      valueColor: AppColors.expense,
                    ),
                ],
              ),
              if (circle.lastActivity.isNotEmpty) ...[
                SizedBox(height: 16.h),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(
                      circle.lastActivity == 'Today'
                          ? Icons.flash_on_rounded
                          : Icons.access_time_rounded,
                      size: 14.sp,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Last activity: ${circle.lastActivity}',
                      style: AppTexts.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;
  final bool isDark;
  const _TypeBadge({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isOngoing = label == 'ONGOING';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isOngoing
            ? AppColors.income.withAlpha(isDark ? 60 : 30)
            : (isDark ? AppColors.cardDark : const Color(0xFFF0F0E9)),
        borderRadius: BorderRadius.circular(20.r),
        border: isOngoing
            ? null
            : Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
      ),
      child: Text(
        label,
        style: AppTexts.bodySmall.copyWith(
          color: isOngoing
              ? AppColors.income
              : (isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight),
          fontWeight: FontWeight.w700,
          fontSize: 10.sp,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MemberAvatarStack extends StatelessWidget {
  final List<CircleMember> members;
  const _MemberAvatarStack({required this.members});

  @override
  Widget build(BuildContext context) {
    // Show at most 2 avatars + overflow count
    final visible = members.take(2).toList();
    final overflow = members.length - visible.length;
    final avatarSize = 32.w;
    const overlap = 10.0;

    return SizedBox(
      height: avatarSize,
      width:
          avatarSize * visible.length +
          (overflow > 0 ? avatarSize : 0) -
          (visible.length - 1) * overlap,
      child: Stack(
        children: [
          ...visible.asMap().entries.map((e) {
            return Positioned(
              left: e.key * (avatarSize - overlap),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: e.value.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.cardDark
                        : Colors.white,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  e.value.initials,
                  style: AppTexts.bodySmall.copyWith(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }),
          if (overflow > 0)
            Positioned(
              left: visible.length * (avatarSize - overlap),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.cardDark
                        : Colors.white,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$overflow',
                  style: AppTexts.bodySmall.copyWith(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final Color valueColor;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.isDark,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTexts.bodySmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTexts.bodyLarge.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }
}
