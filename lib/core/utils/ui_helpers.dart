import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UIHelpers {
  // Spacing helper
  static SizedBox verticalSpace(double height) => SizedBox(height: height.h);
  static SizedBox horizontalSpace(double width) => SizedBox(width: width.w);

  // Haptic Feedback Helpers
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  // Common Padding
  static EdgeInsets get screenPadding => EdgeInsets.all(20.w);
  static EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: 20.w);
  static EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: 20.h);

  // Decorations
  static BoxDecoration glassDecoration({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark 
        ? Colors.white.withAlpha(13) // 0.05 * 255
        : Colors.white.withAlpha(179), // 0.7 * 255
      borderRadius: BorderRadius.circular(24.r),
      border: Border.all(
        color: isDark 
          ? Colors.white.withAlpha(26) // 0.1 * 255
          : Colors.white.withAlpha(77), // 0.3 * 255
      ),
    );
  }
}

extension AppSpacing on num {
  SizedBox get verticalSpace => SizedBox(height: toDouble().h);
  SizedBox get horizontalSpace => SizedBox(width: toDouble().w);
}
