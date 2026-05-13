import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_constants.dart';

class BankLogoAvatar extends StatelessWidget {
  final String bankName;
  final String? logoPath;
  final double size;
  final bool isSelected;
  final Color fallbackColor;
  final EdgeInsets? padding;

  const BankLogoAvatar({
    super.key,
    required this.bankName,
    this.logoPath,
    this.size = 24,
    this.isSelected = false,
    required this.fallbackColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // If no logo path provided, try fallback to app constants
    final actualLogoPath = logoPath ?? AppConstants.getBankLogo(bankName);
    final hasLogo = actualLogoPath.isNotEmpty;

    return Container(
      padding: padding ?? EdgeInsets.all(hasLogo ? 8.w : 12.w),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withValues(alpha: 0.2)
            : (hasLogo ? Colors.white : fallbackColor.withValues(alpha: 0.1)),
        shape: BoxShape.circle,
        boxShadow: (hasLogo && !isSelected)
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: hasLogo && !isSelected
          ? ClipOval(
              child: actualLogoPath.endsWith('.svg')
                  ? SvgPicture.asset(
                      actualLogoPath,
                      width: size.sp,
                      height: size.sp,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      actualLogoPath,
                      width: size.sp,
                      height: size.sp,
                      fit: BoxFit.contain,
                    ),
            )
          : Text(
              bankName.isNotEmpty ? bankName.substring(0, 1).toUpperCase() : '?',
              style: TextStyle(
                color: isSelected ? Colors.white : fallbackColor,
                fontWeight: FontWeight.w900,
                fontSize: (size * 0.7).sp,
              ),
            ),
    );
  }
}
