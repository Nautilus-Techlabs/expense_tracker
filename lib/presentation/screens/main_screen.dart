import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../providers/navigation_provider.dart';
import 'bank_accounts_screen.dart';
import 'dashboard_screen.dart';
import 'transaction_list_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  final List<Widget> _screens = const [
    DashboardScreen(),
    TransactionListScreen(),
    BankAccountsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: _screens),
      bottomNavigationBar: _buildCustomNavBar(
        context,
        ref,
        isDark,
        selectedIndex,
      ),
    );
  }

  Widget _buildCustomNavBar(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    int selectedIndex,
  ) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 72.h + bottomPadding,
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceSecondaryColor(context),
        border: Border(
          top: BorderSide(color: AppTheme.getBorderColor(context), width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: selectedIndex == 0,
              onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
            ),
            _NavBarItem(
              icon: Icons.bar_chart_rounded,
              label: 'History',
              isSelected: selectedIndex == 1,
              onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
            ),
            _NavBarItem(
              icon: Icons.account_balance_wallet_rounded,
              label: 'Wallet',
              isSelected: selectedIndex == 2,
              onTap: () => ref.read(navigationIndexProvider.notifier).state = 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.45 : 0.5,
    );

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
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 24.sp,
              ),
            ),
            UIHelpers.verticalSpace(4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? activeColor : inactiveColor,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
