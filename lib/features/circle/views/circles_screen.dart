import 'package:expense_tracker/core/utils/ui_helpers.dart';
import 'package:expense_tracker/features/circle/models/circle_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors_extension.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_router.dart';
import '../models/circle_data.dart';
import '../viewmodels/circle_notifier.dart';
import '../widgets/circle_card.dart';
import '../widgets/circle_summary_banner.dart';

class CirclesScreen extends ConsumerWidget {
  const CirclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circleState = ref.watch(circleProvider);
    final circles = circleState.circles;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Center(child: Text('Circle feature Coming Soon')),
      ),
    );
  }
}

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

