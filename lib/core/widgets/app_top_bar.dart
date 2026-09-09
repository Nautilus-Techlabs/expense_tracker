import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors_extension.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool showBack;

  const AppTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.bottom,
    this.showBack = true,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: showBack
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 20.sp,
                color: context.colors.textPrimary,
              ),
              onPressed: onBack ?? () => context.pop(),
            )
          : null,
      automaticallyImplyLeading: showBack,
      title: Text(
        title,
        style: context.appTexts.heading.copyWith(
          color: context.colors.textPrimary,
          fontSize: 18.sp,
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}
