import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../../../../core/utils/ui_helpers.dart';

class StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final Color valueColor;

  const StatColumn({
    super.key,
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
          style: context.appTexts.bodySmall.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        UIHelpers.verticalSpace(4),
        Text(
          value,
          style: context.appTexts.bodyLarge.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }
}
