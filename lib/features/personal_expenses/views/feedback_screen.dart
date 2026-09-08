import 'package:expense_tracker/core/utils/app_logger.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors_extension.dart';
import '../../../core/widgets/primary_button.dart';
import '../viewmodels/feedback_notifier.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _sendFeedback() async {
    final feedbackText = _feedbackController.text.trim();
    if (feedbackText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your feedback')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      String? appVersion;
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        appVersion = packageInfo.version;
      } catch (e) {
        AppLogger.e('Failed to get package info: $e');
      }

      final result = await ref
          .read(feedbackProvider.notifier)
          .sendFeedback(feedbackText: feedbackText, appVersion: appVersion);

      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: AppColors.expense,
            ),
          );
        },
        (feedbackId) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thank you! Your feedback has been submitted.'),
              backgroundColor: AppColors.income,
            ),
          );
          context.pop();
        },
      );
    } catch (e) {
      AppLogger.e('Error submitting feedback: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20.sp,
            color: context.colors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Feedback',
          style: context.appTexts.heading.copyWith(
            color: context.colors.textPrimary,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelpers.verticalSpace(24),

            // ── Feedback Message Textfield ──
            Container(
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: context.colors.border),
              ),
              child: TextField(
                controller: _feedbackController,
                maxLines: 6,
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Type your feedback here...',
                  hintStyle: context.appTexts.bodyMedium.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  contentPadding: EdgeInsets.all(20.w),
                  border: InputBorder.none,
                ),
              ),
            ),
            UIHelpers.verticalSpace(32),

            // ── Submit Button ──
            PrimaryButton(
              text: 'Submit Feedback',
              isLoading: _isSending,
              onPressed: _sendFeedback,
            ),
            UIHelpers.verticalSpace(40),
          ],
        ),
      ),
    );
  }
}
