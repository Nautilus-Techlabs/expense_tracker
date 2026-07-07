import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../domain/entities/transaction.dart';
import '../viewmodels/transaction_notifier.dart';
import '../viewmodels/transaction_state.dart';
import '../viewmodels/history_filter_provider.dart';

class TransactionFilterSheet extends ConsumerStatefulWidget {
  const TransactionFilterSheet({super.key});

  @override
  ConsumerState<TransactionFilterSheet> createState() =>
      _TransactionFilterSheetState();
}

class _TransactionFilterSheetState
    extends ConsumerState<TransactionFilterSheet> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);
    final historyFilters = ref.watch(historyFilterProvider);
    final controller = ref.read(historyFilterProvider.notifier);
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: AppTheme.getNeutralColor(context).withAlpha(40),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'More Filters',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    controller.clearAll();
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            UIHelpers.verticalSpace(16),

            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Transaction Type
                    _SectionHeader(title: 'TRANSACTION TYPE'),
                    _TypeFilter(filters: historyFilters, controller: controller),
                    UIHelpers.verticalSpace(24),

                    // 2. Payment Method
                    _SectionHeader(title: 'PAYMENT METHOD'),
                    _MethodFilter(state: state, filters: historyFilters, controller: controller),
                    UIHelpers.verticalSpace(24),

                    // 3. Category
                    _SectionHeader(title: 'CATEGORY'),
                    _CategoryFilter(state: state, filters: historyFilters, controller: controller),
                    UIHelpers.verticalSpace(32),
                  ],
                ),
              ),
            ),

            // Apply Button
            Padding(
              padding: EdgeInsets.only(bottom: 40.h, top: 16.h),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: AppTheme.getNeutralColor(context),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _TypeFilter extends StatelessWidget {
  final HistoryFilterState filters;
  final HistoryFilterNotifier controller;

  const _TypeFilter({required this.filters, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _FilterChipWrapper(
          label: 'All',
          isSelected: filters.selectedType == null,
          onTap: () => controller.setTypeFilter(null),
        ),
        _FilterChipWrapper(
          label: 'Debit',
          isSelected: filters.selectedType == TransactionType.debit,
          onTap: () => controller.setTypeFilter(TransactionType.debit),
          icon: Icons.arrow_outward_rounded,
        ),
        _FilterChipWrapper(
          label: 'Credit',
          isSelected: filters.selectedType == TransactionType.credit,
          onTap: () => controller.setTypeFilter(TransactionType.credit),
          icon: Icons.south_west_rounded,
        ),
      ],
    );
  }
}

class _MethodFilter extends StatelessWidget {
  final TransactionState state;
  final HistoryFilterState filters;
  final HistoryFilterNotifier controller;

  const _MethodFilter({required this.state, required this.filters, required this.controller});

  @override
  Widget build(BuildContext context) {
    final methods = state.getAvailableMethods();
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _FilterChipWrapper(
          label: 'All',
          isSelected: filters.selectedMethod == null,
          onTap: () => controller.setMethodFilter(null),
        ),
        ...methods.map(
          (m) => _FilterChipWrapper(
            label: m.name.toUpperCase(),
            isSelected: filters.selectedMethod == m,
            onTap: () => controller.setMethodFilter(m),
          ),
        ),
      ],
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final TransactionState state;
  final HistoryFilterState filters;
  final HistoryFilterNotifier controller;

  const _CategoryFilter({required this.state, required this.filters, required this.controller});

  @override
  Widget build(BuildContext context) {
    final categories = state.categories;
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _FilterChipWrapper(
          label: 'All',
          isSelected: filters.selectedCategoryIds.isEmpty,
          onTap: () => controller.clearCategoryFilter(),
        ),
        ...categories.map(
          (cat) => _FilterChipWrapper(
            label: cat.name,
            isSelected: filters.selectedCategoryIds.contains(cat.id),
            onTap: () => controller.toggleCategoryFilter(cat.id!),
            icon: UIHelpers.getCategoryIcon(cat.icon),
          ),
        ),
      ],
    );
  }
}

class _FilterChipWrapper extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilterChipWrapper({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = theme.colorScheme.primary;

    return InkWell(
      onTap: () {
        UIHelpers.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(30.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : (isDark
                    ? theme.colorScheme.surfaceContainerHighest
                    : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? Colors.white.withAlpha(10) : Colors.transparent),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withAlpha(60),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16.sp,
                color: isSelected
                    ? Colors.white
                    : AppTheme.getNeutralColor(context),
              ),
              UIHelpers.horizontalSpace(8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black87),
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
