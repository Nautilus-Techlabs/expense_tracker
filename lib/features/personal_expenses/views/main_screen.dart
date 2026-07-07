import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/navigation_provider.dart';
import 'circles_screen.dart';
import 'dashboard_screen.dart';
import 'reports_screen.dart';
import 'transaction_list_screen.dart';
import 'add_transaction_screen.dart'; // Add transaction is now a bottom sheet, but we might just show modal from here.

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  final List<Widget> _screens = const [
    DashboardScreen(),
    TransactionListScreen(),
    CirclesScreen(),
    ReportsScreen(),
  ];

  void _showAddTransactionBottomSheet(BuildContext context) {
    // In Phase 3, AddTransactionScreen will be a bottom sheet.
    // For now, we can show a placeholder or navigate.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.backgroundDark 
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: const Center(child: Text("Add Transaction Bottom Sheet")),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: IndexedStack(
        index: selectedIndex > 1 ? selectedIndex - 1 : selectedIndex, // Adjusted for the FAB hole
        children: _screens,
      ),
      floatingActionButton: Container(
        height: 56.w,
        width: 56.w,
        margin: EdgeInsets.only(top: 30.h), // Push down to overlap nav bar properly
        child: FloatingActionButton(
          onPressed: () => _showAddTransactionBottomSheet(context),
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: const CircleBorder(),
          child: Icon(Icons.add_rounded, color: Colors.white, size: 32.sp),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildCustomNavBar(context, ref, isDark, selectedIndex),
    );
  }

  Widget _buildCustomNavBar(BuildContext context, WidgetRef ref, bool isDark, int selectedIndex) {
    return BottomAppBar(
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      elevation: 0,
      notchMargin: 8.w,
      shape: const CircularNotchedRectangle(),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight, 
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavBarItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                    isSelected: selectedIndex == 0,
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
                  ),
                  _NavBarItem(
                    icon: Icons.account_balance_wallet_outlined,
                    activeIcon: Icons.account_balance_wallet_rounded,
                    label: 'Transactions',
                    isSelected: selectedIndex == 1,
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
                  ),
                ],
              ),
            ),
            // Center space for FAB
            SizedBox(width: 48.w),
            // Right side
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavBarItem(
                    icon: Icons.group_outlined,
                    activeIcon: Icons.group_rounded,
                    label: 'Circles',
                    isSelected: selectedIndex == 2,
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 2,
                  ),
                  _NavBarItem(
                    icon: Icons.bar_chart_outlined,
                    activeIcon: Icons.bar_chart_rounded,
                    label: 'Reports',
                    isSelected: selectedIndex == 3,
                    onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.textPrimaryDark : AppColors.primary;
    final inactiveColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? activeColor : inactiveColor,
            size: 24.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTexts.navLabel.copyWith(
              color: isSelected ? activeColor : inactiveColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
