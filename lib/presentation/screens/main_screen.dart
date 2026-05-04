import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../providers/navigation_provider.dart';
import 'dashboard_screen.dart';
import 'transaction_list_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  final List<Widget> _screens = const [
    DashboardScreen(),
    TransactionListScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: selectedIndex, children: _screens),
          Positioned(
            left: 24.w,
            right: 24.w,
            bottom: 24.h,
            child: _buildCustomNavBar(context, ref, isDark, selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomNavBar(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    int selectedIndex,
  ) {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.surfaceDark.withAlpha(230)
            : Colors.white.withAlpha(230),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: AppTheme.getBorderColor(context).withAlpha(100),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 80 : 30),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ColorFilter.mode(
            isDark ? Colors.black.withAlpha(20) : Colors.white.withAlpha(20),
            BlendMode.srcOver,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  isSelected: selectedIndex == 0,
                  onTap: () =>
                      ref.read(navigationIndexProvider.notifier).state = 0,
                ),
                _NavBarItem(
                  icon: Icons.bar_chart_outlined,
                  activeIcon: Icons.bar_chart_rounded,
                  isSelected: selectedIndex == 1,
                  onTap: () =>
                      ref.read(navigationIndexProvider.notifier).state = 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = AppTheme.getNeutralColor(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          UIHelpers.lightImpact();
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor.withAlpha(30)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 26.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
