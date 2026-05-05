import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/navigation_provider.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/transaction_card.dart';
import '../widgets/transaction_ui_components.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);
    final controller = ref.read(transactionProvider.notifier);

    // Limit to latest 10 transactions
    final latestTransactions = state.transactions.take(10).toList();

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
                balance: state.balance,
                income: state.totalCredit,
                spends: state.totalDebit,
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
                ),
              ),
            ),

            // 3. Latest 10 Transactions
            if (state.isLoading && state.transactions.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: ShimmerLoading(),
              )
            else if (state.transactions.isEmpty)
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
                    heroTag:
                        'hero_dash_${transaction.id ?? transaction.rawSms}',
                  );
                },
              ),

            SliverPadding(padding: EdgeInsets.only(bottom: 100.h)),
          ],
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
      onSort: onSort,
      currentSort: currentSort,
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
        oldDelegate.isLoading != isLoading ||
        oldDelegate.currentSort != currentSort;
  }
}
