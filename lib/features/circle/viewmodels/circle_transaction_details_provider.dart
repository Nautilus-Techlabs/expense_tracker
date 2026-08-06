import 'package:expense_tracker/data/repositories/supabase_provider.dart';
import 'package:expense_tracker/features/circle/models/circle_transaction_split_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final circleTransactionDetailsProvider =
    FutureProvider.family<CircleTransactionSplitModel?, int>((
      ref,
      transactionId,
    ) async {
      final result = await ref
          .read(supabaseHelperProvider)
          .getCircleTransactionsDetails(transactionId: transactionId);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );
    });
