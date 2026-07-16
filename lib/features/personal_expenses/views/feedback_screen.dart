import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/primary_button.dart';
import 'package:expense_tracker/core/utils/ui_helpers.dart';
import '../../../../core/theme/app_colors_extension.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  String _selectedType = 'Suggestion';
  bool _isSending = false;

  final List<String> _feedbackTypes = ['Bug Report', 'Suggestion', 'Feature Request', 'Other'];

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

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'hi@nautilustechlabs.com',
      query: _encodeQuery({
        'subject': 'Finia App – $_selectedType',
        'body': feedbackText,
      }),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        if (mounted) context.pop();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open email client. Please email us at hi@nautilustechlabs.com'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
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
            UIHelpers.verticalSpace(32),

            // ── Icon ──
            Center(
              child: Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.feedback_outlined, size: 34.sp, color: context.colors.primary),
              ),
            ),
            UIHelpers.verticalSpace(20),

            // ── Title & Subtitle ──
            Center(
              child: Text(
                'How can we improve?',
                style: context.appTexts.displayMedium.copyWith(
                  color: context.colors.primary,
                  fontSize: 24.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            UIHelpers.verticalSpace(8),
            Center(
              child: Text(
                'Share your thoughts, report a bug or suggest a new feature.',
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            UIHelpers.verticalSpace(36),

            // ── Type Selector ──
            Text(
              'Type',
              style: context.appTexts.bodySmall.copyWith(
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            UIHelpers.verticalSpace(10),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _feedbackTypes.map((type) {
                final isSelected = _selectedType == type;
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = type),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (context.colors.border),
                      ),
                    ),
                    child: Text(
                      type,
                      style: context.appTexts.bodySmall.copyWith(
                        color: isSelected
                            ? Colors.white
                            : (context.colors.textPrimary),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            UIHelpers.verticalSpace(24),

            // ── Message ──
            Text(
              'Message',
              style: context.appTexts.bodySmall.copyWith(
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            UIHelpers.verticalSpace(10),
            Container(
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: context.colors.border,
                ),
              ),
              child: TextField(
                controller: _feedbackController,
                maxLines: 8,
                style: context.appTexts.bodyMedium.copyWith(
                  color: context.colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  hintStyle: context.appTexts.bodyMedium.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  contentPadding: EdgeInsets.all(20.w),
                  border: InputBorder.none,
                ),
              ),
            ),
            UIHelpers.verticalSpace(36),

            // ── Submit Button ──
            PrimaryButton(
              text: 'Send Feedback',
              isLoading: _isSending,
              onPressed: _sendFeedback,
            ),
            UIHelpers.verticalSpace(16),

            // ── Email fallback ──
            Center(
              child: Text(
                'Or email us at hi@nautilustechlabs.com',
                style: context.appTexts.bodySmall.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
            UIHelpers.verticalSpace(40),
          ],
        ),
      ),
    );
  }
}
