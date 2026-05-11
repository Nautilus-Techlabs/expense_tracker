import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../providers/navigation_provider.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/transaction_card.dart';
import '../widgets/transaction_ui_components.dart';
import 'add_transaction_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);
    final controller = ref.read(transactionProvider.notifier);

    final latestTransactions = state.latestTransactions;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.syncTransactions,
        displacement: MediaQuery.of(context).padding.top + 40,
        color: Theme.of(context).colorScheme.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 1. Pinned Summary Header
            SliverPersistentHeader(
              pinned: true,
              delegate: DashboardHeaderDelegate(
                balance: state.globalBalance,
                income: state.totalGlobalCredit,
                spends: state.totalGlobalDebit,
                onSync: controller.syncTransactions,
                onSort: controller.setSort,
                currentSort: state.currentSort,
                isLoading: state.isLoading,
                topPadding: MediaQuery.of(context).padding.top,
              ),
            ),

            // 2. Section Header: Latest Transactions
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 16.h),
              sliver: SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Recent Transactions',
                  actionLabel: 'See All',
                  onActionPressed: () {
                    ref.read(navigationIndexProvider.notifier).state = 1;
                  },
                  trailing: IconButton(
                    onPressed: () => _showSortMenu(context, ref),
                    icon: Icon(
                      Icons.sort_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20.sp,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ),

            // 3. Latest 10 Transactions
            if (state.isLoading && state.allTransactions.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: ShimmerLoading(),
              )
            else if (state.allTransactions.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyStateView(onRetry: controller.syncTransactions),
              )
            else
              SliverList.builder(
                itemCount: latestTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = latestTransactions[index];
                  return TransactionCard(
                    key: ValueKey(
                      'dash_${transaction.id ?? transaction.rawSms}',
                    ),
                    transaction: transaction,
                    showDate: true,
                    heroTag:
                        'hero_dash_${transaction.id ?? transaction.rawSms}',
                  );
                },
              ),

            SliverPadding(padding: EdgeInsets.only(bottom: 100.h)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add', style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double balance;
  final double income;
  final double spends;
  final VoidCallback onSync;
  final Function(TransactionSort) onSort;
  final TransactionSort currentSort;
  final bool isLoading;
  final double topPadding;

  DashboardHeaderDelegate({
    required this.balance,
    required this.income,
    required this.spends,
    required this.onSync,
    required this.onSort,
    required this.currentSort,
    required this.isLoading,
    required this.topPadding,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DashboardHeader(
      balance: balance,
      income: income,
      spends: spends,
      onSync: onSync,
      isLoading: isLoading,
    );
  }

  @override
  double get maxExtent => 290.h + topPadding;

  @override
  double get minExtent => 290.h + topPadding;

  @override
  bool shouldRebuild(covariant DashboardHeaderDelegate oldDelegate) {
    return oldDelegate.balance != balance ||
        oldDelegate.income != income ||
        oldDelegate.spends != spends ||
        oldDelegate.isLoading != isLoading;
  }
}

void _showSortMenu(BuildContext context, WidgetRef ref) {
  final state = ref.read(transactionProvider);
  final controller = ref.read(transactionProvider.notifier);
  final theme = Theme.of(context);

  showMenu<TransactionSort>(
    context: context,
    position: RelativeRect.fromLTRB(
      MediaQuery.of(context).size.width - 50.w,
      400.h, // Adjusted position for dashboard list
      24.w,
      0,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    color: theme.colorScheme.surface,
    elevation: 8,
    items: [
      _buildSortItem(
        context,
        TransactionSort.dateDesc,
        'Newest First',
        Icons.calendar_today_rounded,
        state.currentSort,
      ),
      _buildSortItem(
        context,
        TransactionSort.dateAsc,
        'Oldest First',
        Icons.history_rounded,
        state.currentSort,
      ),
      _buildSortItem(
        context,
        TransactionSort.amountDesc,
        'High to Low',
        Icons.trending_down_rounded,
        state.currentSort,
      ),
      _buildSortItem(
        context,
        TransactionSort.amountAsc,
        'Low to High',
        Icons.trending_up_rounded,
        state.currentSort,
      ),
    ],
  ).then((value) {
    if (value != null) controller.setSort(value);
  });
}

PopupMenuItem<TransactionSort> _buildSortItem(
  BuildContext context,
  TransactionSort value,
  String label,
  IconData icon,
  TransactionSort currentSort,
) {
  final isSelected = currentSort == value;

  return PopupMenuItem(
    value: value,
    child: Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : AppTheme.getNeutralColor(context),
        ),
        UIHelpers.horizontalSpace(12),
        Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    ),
  );
}
