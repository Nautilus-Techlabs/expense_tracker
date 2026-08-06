import 'package:expense_tracker/features/personal_expenses/models/transaction_model.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/account_notifier.dart';
import 'package:expense_tracker/features/personal_expenses/viewmodels/category_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:expense_tracker/features/auth/viewmodels/auth_notifier.dart';
import 'package:expense_tracker/features/circle/viewmodels/circle_details_notifier.dart';

class DetailedTransactionState {
  final bool isExpense;
  final bool isCircleTransaction;
  final String categoryName;
  final String accountName;
  final bool canEditOrDelete;

  DetailedTransactionState({
    required this.isExpense,
    required this.isCircleTransaction,
    required this.categoryName,
    required this.accountName,
    required this.canEditOrDelete,
  });
}

final detailedTransactionProvider =
    Provider.family<DetailedTransactionState, TransactionModel>((
      ref,
      transaction,
    ) {
      final isExpense =
          transaction.type == 'expense' || transaction.type == 'withdrawal';

      final category = ref
          .watch(categoryProvider.notifier)
          .getCategoryById(transaction.categoryId);
      final categoryName = category?.name ?? 'Uncategorized';

      final account = ref
          .watch(accountProvider.notifier)
          .getAccountById(transaction.accountId);
      final accountName = account?.name ?? 'Unknown Account';

      bool canEditOrDelete = true;
      if (transaction.isCircleTransaction) {
        final currentUserId = ref.watch(authProvider).user?.id;
        final isCreator = transaction.userId == currentUserId;

        bool isOwner = false;
        if (transaction.circleId != null) {
          final circleDetails = ref
              .watch(circleDetailsProvider(transaction.circleId!))
              .screenData;
          if (circleDetails != null) {
            final selfMember = circleDetails.members.firstWhereOrNull(
              (m) => m.isSelf,
            );
            isOwner = selfMember?.role == 'owner';
          }
        }
        canEditOrDelete = isCreator || isOwner;
      }

      return DetailedTransactionState(
        isExpense: isExpense,
        isCircleTransaction: transaction.isCircleTransaction,
        categoryName: categoryName,
        accountName: accountName,
        canEditOrDelete: canEditOrDelete,
      );
    });
