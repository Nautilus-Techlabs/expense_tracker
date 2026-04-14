import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'transaction_controller.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/modern_filter_chips.dart';
import 'widgets/transaction_card.dart';
import 'widgets/shimmer_loading.dart';
import 'widgets/empty_state_view.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-sync on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionController>().syncTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TransactionController>(
        builder: (context, controller, child) {
          return RefreshIndicator(
            onRefresh: controller.syncTransactions,
            displacement: MediaQuery.of(context).padding.top + 40,
            color: Theme.of(context).colorScheme.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // 1. Dashboard Header (Scrolable)
                SliverToBoxAdapter(
                  child: DashboardHeader(
                    balance: controller.balance,
                    income: controller.totalCredit,
                    spends: controller.totalDebit,
                    onSync: controller.syncTransactions,
                    onSort: controller.setSort,
                    currentSort: controller.currentSort,
                    isLoading: controller.isLoading,
                  ),
                ),

                // 2. Filters (Fixed below header, but scrolls with list)
                SliverToBoxAdapter(
                  child: ModernFilterBar(controller: controller),
                ),

                // 3. Main Content Area
                SliverPadding(
                  padding: EdgeInsets.only(top: 8.h, bottom: 40.h),
                  sliver: _buildSliverContent(controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverContent(TransactionController controller) {
    if (controller.isLoading && controller.transactions.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: const ShimmerLoading(key: ValueKey('loading')),
      );
    }

    if (controller.errorMessage != null && controller.transactions.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateView(
          key: const ValueKey('error'),
          isError: true,
          message: controller.errorMessage!,
          onRetry: controller.syncTransactions,
        ),
      );
    }

    if (controller.transactions.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateView(
          key: const ValueKey('empty'),
          onRetry: controller.syncTransactions,
        ),
      );
    }

    // Unified list scrolling with the rest of the slivers
    return SliverList.builder(
      key: const ValueKey('list'),
      itemCount: controller.transactions.length,
      itemBuilder: (context, index) {
        return TransactionCard(transaction: controller.transactions[index]);
      },
    );
  }
}
