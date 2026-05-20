import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../domain/entities/transaction.dart';
import '../providers/history_filter_provider.dart';
import '../providers/transaction_notifier.dart';
import '../providers/transaction_state.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/modern_filter_chips.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/transaction_card.dart';
import '../widgets/transaction_filter_sheet.dart';

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

  Future<void> _exportToCsv(List<Transaction> transactions) async {
    // Export only transactions that contain raw SMS
    final filtered = transactions.where((t) => t.rawSms != null).toList();

    if (filtered.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No parsed transactions found to export'),
          ),
        );
      }
      return;
    }

    try {
      final List<List<dynamic>> rows = [];

      // CSV Header
      rows.add([
        'Date',
        'Amount',
        'Type',
        'Bank',
        'Account',
        'Method',
        'Category',
        'Merchant',
        'Description',
        'Verified',
        'Raw SMS',
      ]);

      // CSV Data
      for (final t in filtered) {
        rows.add([
          DateFormat('dd-MMM-yyyy HH:mm:ss').format(t.date),
          t.amount.toStringAsFixed(2),
          t.type.name.toUpperCase(),
          t.bankName,
          t.account ?? '',
          t.method.name.toUpperCase(),
          t.category?.name ?? '',
          t.merchant ?? '',
          t.description ?? '',
          t.isVerified ? 'Yes' : 'No',
          t.rawSms ?? '',
        ]);
      }

      // Convert to CSV
      final csvData = csv.encoder.convert(rows);

      // Add UTF-8 BOM for Excel compatibility
      final csvWithBom = '\uFEFF$csvData';

      // File name
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/transactions_export_$timestamp.csv';
      final file = File(path);

      await file.writeAsString(csvWithBom, encoding: utf8);

      // Share file
      if (mounted) {
        await Share.shareXFiles(
          [XFile(path)],
          subject: 'Expense Tracker CSV Export',
          text: 'Exported transaction data in CSV format.',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('CSV Export Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);
    final historyFilters = ref.watch(historyFilterProvider);
    final controller = ref.read(transactionProvider.notifier);
    final filteredTransactions = ref.watch(filteredTransactionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Simple local search filter
    final searchQuery = _searchController.text.toLowerCase();
    final transactions = filteredTransactions.where((t) {
      if (searchQuery.isEmpty) return true;
      final merchant = (t.merchant ?? '').toLowerCase();
      final desc = (t.description ?? '').toLowerCase();
      return merchant.contains(searchQuery) || desc.contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.bgDark : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Transactions',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () => _exportToCsv(transactions),
            icon: Icon(Icons.file_download_outlined, size: 22.sp),
            tooltip: 'Export to CSV',
          ),
          SizedBox(width: 8.w),
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
                      color: isDark ? AppTheme.surfaceDark : Colors.white,
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
                UIHelpers.horizontalSpace(12),
                // Filter Button
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _showFilterSheet(context);
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withAlpha(10)
                                : AppTheme.borderLight,
                          ),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: historyFilters.activeFiltersCount > 0
                              ? Theme.of(context).colorScheme.primary
                              : AppTheme.getNeutralColor(context),
                          size: 22.sp,
                        ),
                      ),
                      if (historyFilters.activeFiltersCount > 0)
                        Positioned(
                          right: -4.w,
                          top: -4.h,
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF0F172A)
                                    : Colors.white,
                                width: 2,
                              ),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 18.w,
                              minHeight: 18.h,
                            ),
                            child: Center(
                              child: Text(
                                '${historyFilters.activeFiltersCount}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Filters
          ModernFilterBar(
            state: state,
            filters: historyFilters,
            controller: ref.read(historyFilterProvider.notifier),
          ),

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
      return "Today, ${DateFormat('MMM dd, yyyy').format(date)}";
    } else if (tDate == yesterday) {
      return "Yesterday, ${DateFormat('MMM dd, yyyy').format(date)}";
    } else {
      return DateFormat('EEEE, MMM dd, yyyy').format(date);
    }
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TransactionFilterSheet(),
    );
  }
}
