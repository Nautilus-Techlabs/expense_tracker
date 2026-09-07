import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/utils/ui_helpers.dart';

class FaqScreen extends ConsumerWidget {
  const FaqScreen({super.key});

  final List<Map<String, String>> _faqs = const [
    {
      'question': 'How do I add a new transaction?',
      'answer':
          'You can add a new transaction by tapping the floating "+" button on the home screen or the bottom navigation bar. From there, enter the amount, select the category, and choose whether it is an income or expense.',
    },
    {
      'question': 'Can I track expenses across multiple accounts?',
      'answer':
          'Yes! You can manage multiple accounts (like Cash, Bank, and Credit Card) in the Accounts section. When adding a transaction, you can select which account it applies to.',
    },
    {
      'question': 'How are my reports generated?',
      'answer':
          'Reports are automatically generated based on your transaction history. You can view weekly, monthly, and yearly breakdowns in the Reports tab to get a clear picture of your spending habits.',
    },
    {
      'question': 'Can I create custom categories?',
      'answer':
          'Absolutely. Go to Settings > Categories to add, edit, or remove categories. You can specify whether a category is for income, expenses, or both.',
    },
    {
      'question': 'Is my financial data secure?',
      'answer':
          'Your data is securely stored and authenticated. We use industry-standard encryption to ensure that only you have access to your personal financial information.',
    },
    {
      'question': 'How do I manage a budget?',
      'answer':
          'You can set a monthly budget from the Home screen by tapping the "Add Budget" or "Edit Budget" button. Your dashboard will then show you how much of your budget you have used for the current month.',
    },
  ];

  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'hi@nautilustechlabs.com',
      queryParameters: {'subject': 'Expense Lite Support Request'},
    );

    try {
      if (!await launchUrl(emailLaunchUri)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch email client')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch email client')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colors.textPrimary,
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Help & FAQ',
          style: context.appTexts.displayMedium.copyWith(
            color: context.colors.textPrimary,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Help / Contact Us Banner
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.support_agent_rounded,
                                color: AppColors.primary,
                                size: 24.sp,
                              ),
                            ),
                            UIHelpers.horizontalSpace(12),
                            Expanded(
                              child: Text(
                                'Need more help?',
                                style: context.appTexts.headingSmall.copyWith(
                                  color: context.colors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        UIHelpers.verticalSpace(12),
                        Text(
                          'If you couldn\'t find the answer to your question, feel free to reach out to our support team.',
                          style: context.appTexts.bodySmall.copyWith(
                            color: context.colors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        UIHelpers.verticalSpace(16),
                        ElevatedButton.icon(
                          onPressed: () => _launchEmail(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 24.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          icon: Icon(Icons.email_outlined, size: 18.sp),
                          label: Text(
                            'Contact Support',
                            style: context.appTexts.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  UIHelpers.verticalSpace(32),

                  Text(
                    'Frequently Asked Questions',
                    style: context.appTexts.headingSmall.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  UIHelpers.verticalSpace(16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final faq = _faqs[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.card,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          faq['question']!,
                          style: context.appTexts.bodyMedium.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        iconColor: context.colors.primary,
                        collapsedIconColor: context.colors.textSecondary,
                        childrenPadding: EdgeInsets.fromLTRB(
                          16.w,
                          0,
                          16.w,
                          16.h,
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            faq['answer']!,
                            style: context.appTexts.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, childCount: _faqs.length),
            ),
          ),
          SliverToBoxAdapter(child: UIHelpers.verticalSpace(48)),
        ],
      ),
    );
  }
}
