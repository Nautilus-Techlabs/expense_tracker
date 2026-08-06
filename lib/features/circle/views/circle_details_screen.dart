import 'package:expense_tracker/core/services/link_generator.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/features/circle/widgets/circle_summary_card.dart';
import 'package:expense_tracker/features/circle/widgets/circle_transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors_extension.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';
import '../../../core/constants/args.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import '../viewmodels/circle_details_notifier.dart';
import '../widgets/add_circle_expense_bottom_sheet.dart';
import '../widgets/circle_member_card.dart';
import '../widgets/settle_up_bottom_sheet.dart';

class CircleDetailsScreen extends ConsumerStatefulWidget {
  final CircleDetailsArgs args;

  const CircleDetailsScreen({super.key, required this.args});

  @override
  ConsumerState<CircleDetailsScreen> createState() =>
      _CircleDetailsScreenState();
}

class _CircleDetailsScreenState extends ConsumerState<CircleDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        ref
            .read(circleDetailsProvider(widget.args.circleId).notifier)
            .fetchCircleDetails(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final currentUserId = user?.id ?? 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final detailsState = ref.watch(circleDetailsProvider(widget.args.circleId));
    final data = detailsState.screenData;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: context.colors.textPrimary,
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.args.circleName,
          style: context.appTexts.displayMedium.copyWith(
            color: context.colors.textPrimary,
            fontSize: 22.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: context.colors.textPrimary,
              size: 24.sp,
            ),
            onPressed: () {
              final owner = data?.members.firstWhere(
                (m) => m.role.toLowerCase() == 'owner',
                orElse: () => data.members.first,
              );
              context.push(
                AppRouter.circleSettings,
                extra: CircleSettingsArgs(
                  circleId: widget.args.circleId,
                  circleName: widget.args.circleName,
                  ownerId: owner?.userId,
                ),
              );
            },
          ),
        ],

        centerTitle: false,
      ),
      body: detailsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : detailsState.error != null
          ? Center(child: Text(detailsState.error!))
          : data == null
          ? const Center(child: Text('No data found'))
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final user = ref.read(authProvider).user;
                      if (user != null) {
                        await ref
                            .read(
                              circleDetailsProvider(
                                widget.args.circleId,
                              ).notifier,
                            )
                            .fetchCircleDetails(user.id);
                      }
                    },
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelpers.verticalSpace(12),
                          // ── Summary Card ──
                          CircleSummaryCard(
                            isDark: isDark,
                            totalSpent: data.totalSpent.toDouble(),
                            settledAmount: data.settledAmount.toDouble(),
                            pendingAmount: data.pendingAmount.toDouble(),
                            progressPct: data.settlementProgressPct.toDouble(),
                          ),
                          UIHelpers.verticalSpace(28),

                          // ── Members Section Header ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'MEMBERS (${data.members.length})',
                                style: context.appTexts.bodySmall.copyWith(
                                  color: context.colors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  ShareHelper.inviteCircle(
                                    widget.args.circleId,
                                  );
                                },
                                icon: Icon(
                                  Icons.person_add_outlined,
                                  size: 16.sp,
                                  color: AppColors.primary,
                                ),
                                label: Text(
                                  'Add member',
                                  style: context.appTexts.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                          UIHelpers.verticalSpace(12),

                          // ── Member List ──
                          ...data.members.map((m) {
                            final initials = m.fullName.isNotEmpty
                                ? m.fullName
                                      .trim()
                                      .split(' ')
                                      .map((e) => e.isNotEmpty ? e[0] : '')
                                      .take(2)
                                      .join()
                                      .toUpperCase()
                                : 'M';

                            String subtext = '';
                            Color? subtextColor;

                            switch (m.status) {
                              case 'owes_you':
                                subtext =
                                    'Owes ₹${m.relationshipAmount.abs()} to you';
                                subtextColor = AppColors.income;
                                break;

                              case 'you_owe':
                                subtext =
                                    'You owe ₹${m.relationshipAmount.abs()} to them';
                                subtextColor = AppColors.expense;
                                break;

                              default:
                                subtext = 'Settled up';
                            }

                            return CircleMemberCard(
                              initials: initials,
                              name: m.isSelf
                                  ? '${m.fullName} (You)'
                                  : m.fullName,
                              subtext: subtext,
                              badgeText: m.role.toUpperCase(),
                              avatarColor: m.isSelf
                                  ? AppColors.primary
                                  : const Color(0xFF7B3B1D),
                              badgeColor: m.role == 'owner'
                                  ? AppColors.primary
                                  : AppColors.textSecondaryLight,
                              isDark: isDark,
                              showRemind: !m.isSelf && m.status == 'owes_you',
                              subtextColor: subtextColor,
                            );
                          }),

                          UIHelpers.verticalSpace(28),

                          // ── Activity Section Header ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'RECENT ACTIVITY',
                                style: context.appTexts.bodySmall.copyWith(
                                  color: context.colors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push(
                                    AppRouter.circleAllTransactions,
                                    extra: widget.args.circleId,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'View all',
                                  style: context.appTexts.bodySmall.copyWith(
                                    color: context.colors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          UIHelpers.verticalSpace(12),

                          // ── Recent Activity Container ──
                          Container(
                            decoration: BoxDecoration(
                              color: context.colors.card,
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(color: context.colors.border),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.recentActivity.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                indent: 76.w,
                                color: context.colors.border,
                              ),
                              itemBuilder: (context, index) {
                                final activity = data.recentActivity[index];
                                return CircleTransactionTile(
                                  icon: Icons.receipt_long_rounded,
                                  title: activity.note ?? 'Expense',
                                  subtitle:
                                      'Paid by ${activity.paidByName} • ${DateFormat('MMM dd').format(activity.txnDate)}',
                                  amount: '₹${activity.amount}',
                                );
                              },
                            ),
                          ),
                          UIHelpers.verticalSpace(24),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Fixed Bottom Actions ──
                Container(
                  padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
                  decoration: BoxDecoration(
                    color: context.colors.background,
                    border: Border(
                      top: BorderSide(color: context.colors.border),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => showSettleUpBottomSheet(
                            context,
                            widget.args.circleId,
                            currentUserId,
                          ),
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
                            minimumSize: Size(0, 52.h),
                          ),
                          child: Text(
                            'Settle up',
                            style: context.appTexts.bodyLarge.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      UIHelpers.horizontalSpace(12),
                      Expanded(
                        child: PrimaryButton(
                          text: '+ Add expense',
                          onPressed: () {
                            showAddCircleExpenseBottomSheet(
                              context: context,
                              circleId: widget.args.circleId,
                              members: data.members,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
