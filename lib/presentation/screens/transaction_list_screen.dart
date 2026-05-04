import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';
import '../widgets/modern_filter_chips.dart';
import '../widgets/transaction_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/empty_state_view.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);
    final controller = ref.read(transactionProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Redesigned Header
            Container(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          letterSpacing: -1,
                        ),
                      ),
                      _HeaderAction(
                        icon: Icons.sync_rounded,
                        onTap: controller.syncTransactions,
                        isLoading: state.isLoading,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  UIHelpers.verticalSpace(8),
                  Text(
                    '${state.transactions.length} transactions found',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.getNeutralColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Filters (Stays sticky below header)
            ModernFilterBar(state: state, controller: controller),

            // 3. Transactions List
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.syncTransactions,
                color: Theme.of(context).colorScheme.primary,
                child: _buildListContent(state, controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListContent(
    TransactionState state,
    TransactionController controller,
  ) {
    if (state.isLoading && state.transactions.isEmpty) {
      return const ShimmerLoading();
    }

    if (state.errorMessage != null && state.transactions.isEmpty) {
      return EmptyStateView(
        isError: true,
        message: state.errorMessage!,
        onRetry: controller.syncTransactions,
      );
    }

    if (state.transactions.isEmpty) {
      return EmptyStateView(onRetry: controller.syncTransactions);
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 8.h, bottom: 100.h),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: state.transactions.length,
      itemBuilder: (context, index) {
        final transaction = state.transactions[index];
        return TransactionCard(
          key: ValueKey('list_${transaction.id ?? transaction.rawSms}'),
          transaction: transaction,
          heroTag: 'hero_list_${transaction.id ?? transaction.rawSms}',
        );
      },
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isDark;

  const _HeaderAction({
    required this.icon,
    required this.onTap,
    this.isLoading = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceElevatedDark : AppTheme.surfaceSecondaryLight,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppTheme.getBorderColor(context)),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.sp,
                height: 20.sp,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 2.5,
                ),
              )
            : Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20.sp,
              ),
      ),
    );
  }
}
