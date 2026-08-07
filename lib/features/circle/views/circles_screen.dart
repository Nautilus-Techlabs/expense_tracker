import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../core/constants/app_constants.dart';
import '../viewmodels/circle_notifier.dart';
import '../widgets/circle_card.dart';
import '../widgets/circle_summary_banner.dart';

import '../widgets/create_circle_bottom_sheet.dart';
import '../../auth/viewmodels/auth_notifier.dart';

class CirclesScreen extends ConsumerStatefulWidget {
  const CirclesScreen({super.key});

  @override
  ConsumerState<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends ConsumerState<CirclesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        ref.read(circleProvider.notifier).fetchCirclesScreenData(user.id);
      }
    });
  }

  Future<void> _onRefresh() async {
    final user = ref.read(authProvider).user;
    if (user != null) {
      await ref.read(circleProvider.notifier).fetchCirclesScreenData(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final circleState = ref.watch(circleProvider);
    final screenData = circleState.screenData;
    final circles = screenData?.circles ?? [];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: circleState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : circleState.error != null
          ? Center(
              child: Text(
                circleState.error!,
                style: context.appTexts.bodyMedium.copyWith(
                  color: AppColors.expense,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelpers.verticalSpace(24),

                          // ── Header ──────────────────────────────────────────
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Circles',
                                  style: context.appTexts.displayMedium
                                      .copyWith(
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.primary,
                                        fontSize: 32.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          UIHelpers.verticalSpace(20),

                          // ── Owed / Owe Summary ───────────────────────────────
                          CircleSummaryBanner(
                            totals: screenData?.totals,
                            isDark: isDark,
                          ),
                          UIHelpers.verticalSpace(24),

                          // ── Circle Cards ─────────────────────────────────────
                          if (circles.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 40.h,
                              ),
                              child: Center(
                                child: Text(
                                  'No circles found. Create one to get started!',
                                  style: context.appTexts.bodyMedium.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          else
                            ...circles.map(
                              (c) => CircleCard(circle: c, isDark: isDark),
                            ),
                          UIHelpers.verticalSpace(16),
                        ],
                      ),
                    ),
                  ),
                ),
                // ── Create a new circle Button ───────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h + MediaQuery.of(context).padding.bottom),
                  child: OutlinedButton(
                    onPressed: () => showCreateCircleBottomSheet(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.primary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      minimumSize: Size(double.infinity, 52.h),
                    ),
                    child: Text(
                      'Create a new circle',
                      style: context.appTexts.bodyLarge.copyWith(
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
    );
  }
}

