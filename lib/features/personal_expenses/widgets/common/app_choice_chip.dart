import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_theme.dart';

class AppChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final void Function(bool) onSelected;
  final Color? color;
  final Widget? avatar;
  final bool showCheckmark;

  const AppChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.color,
    this.avatar,
    this.showCheckmark = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = color ?? colorScheme.primary;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      showCheckmark: showCheckmark,
      selectedColor: primaryColor.withValues(alpha: 0.12),
      backgroundColor: AppTheme.getSurfaceSecondaryColor(context),
      avatar: avatar,
      labelStyle: TextStyle(
        color: isSelected
            ? primaryColor
            : Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: 12.sp,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: isSelected ? primaryColor : AppTheme.getBorderColor(context),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
    );
  }
}
