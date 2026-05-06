import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/modern_filter_chips.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/transaction_card.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);
    final controller = ref.read(transactionProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Simple local search filter (can be moved to provider if needed)
    final searchQuery = _searchController.text.toLowerCase();
    final transactions = state.transactions.where((t) {
      if (searchQuery.isEmpty) return true;
      final merchant = (t.merchant ?? '').toLowerCase();
      final desc = (t.description ?? '').toLowerCase();
      return merchant.contains(searchQuery) || desc.contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Transactions',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {}, // Share functionality
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withAlpha(10)
                            : AppTheme.borderLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: AppTheme.getNeutralColor(context),
                          size: 20.sp,
                        ),
                        UIHelpers.horizontalSpace(12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() {}),
                            style: TextStyle(fontSize: 14.sp),
                            decoration: InputDecoration(
                              hintText: 'Search transactions...',
                              hintStyle: TextStyle(
                                color: AppTheme.getNeutralColor(context),
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Filters
          ModernFilterBar(state: state, controller: controller),

          // 3. Transactions List
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.syncTransactions,
              color: Theme.of(context).colorScheme.primary,
              child: _buildListContent(state, controller, transactions),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListContent(
    TransactionState state,
    TransactionController controller,
    List<Transaction> transactions,
  ) {
    if (state.isLoading && transactions.isEmpty) {
      return const ShimmerLoading();
    }

    if (transactions.isEmpty) {
      return EmptyStateView(onRetry: controller.syncTransactions);
    }

    // Group transactions by date
    final groupedTransactions = _groupTransactionsByDate(transactions);

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 100.h),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final group = groupedTransactions[index];

        if (group is String) {
          return Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
            child: Text(
              group.toUpperCase(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppTheme.getNeutralColor(context),
                letterSpacing: 0.5,
              ),
            ),
          );
        } else {
          final t = group as Transaction;
          return TransactionCard(
            key: ValueKey('list_${t.id ?? t.rawSms}'),
            transaction: t,
            heroTag: 'hero_list_${t.id ?? t.rawSms}',
          );
        }
      },
    );
  }

  List<dynamic> _groupTransactionsByDate(List<Transaction> transactions) {
    final List<dynamic> grouped = [];
    String? lastDate;

    // Transactions are assumed to be sorted by date descending
    for (final t in transactions) {
      final dateStr = _formatDateHeader(t.date);
      if (dateStr != lastDate) {
        grouped.add(dateStr);
        lastDate = dateStr;
      }
      grouped.add(t);
    }
    return grouped;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tDate = DateTime(date.year, date.month, date.day);

    if (tDate == today) {
      return "Today, ${DateFormat('MMM dd').format(date)}";
    } else if (tDate == yesterday) {
      return "Yesterday, ${DateFormat('MMM dd').format(date)}";
    } else {
      return DateFormat('EEEE, MMM dd').format(date);
    }
  }
}
