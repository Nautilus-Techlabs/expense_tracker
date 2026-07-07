import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class CirclesScreen extends StatelessWidget {
  const CirclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Circles', style: AppTexts.headingMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text('Circles Coming Soon', style: AppTexts.bodyLarge),
      ),
    );
  }
}
