import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/modern_filter_chips.dart';
import '../widgets/transaction_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/empty_state_view.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);
    final controller = ref.read(transactionProvider.notifier);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.syncTransactions,
        displacement: MediaQuery.of(context).padding.top + 40,
        color: Theme.of(context).colorScheme.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 1. Dashboard Header
            SliverToBoxAdapter(
              child: DashboardHeader(
                balance: state.balance,
                income: state.totalCredit,
                spends: state.totalDebit,
                onSync: controller.syncTransactions,
                onSort: controller.setSort,
                currentSort: state.currentSort,
                isLoading: state.isLoading,
              ),
            ),

            // 2. Filters
            SliverToBoxAdapter(
              child: ModernFilterBar(state: state, controller: controller),
            ),

            // 3. Main Content Area
            SliverPadding(
              padding: EdgeInsets.only(top: 8.h, bottom: 40.h),
              sliver: _buildSliverContent(state, controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverContent(
    TransactionState state,
    TransactionController controller,
  ) {
    if (state.isLoading && state.transactions.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: ShimmerLoading(key: ValueKey('loading')),
      );
    }

    if (state.errorMessage != null && state.transactions.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateView(
          key: const ValueKey('error'),
          isError: true,
          message: state.errorMessage!,
          onRetry: controller.syncTransactions,
        ),
      );
    }

    if (state.transactions.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateView(
          key: const ValueKey('empty'),
          onRetry: controller.syncTransactions,
        ),
      );
    }

    return SliverList.builder(
      key: ValueKey(
        'list_${state.selectedBank}_${state.selectedMethod}_${state.currentSort}_${state.isShowingSampleData}',
      ),
      itemCount: state.transactions.length,
      itemBuilder: (context, index) {
        final transaction = state.transactions[index];
        return TransactionCard(
          key: ValueKey(transaction.rawSms),
          transaction: transaction,
        );
      },
    );
  }
}
