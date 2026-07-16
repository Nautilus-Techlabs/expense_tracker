import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/viewmodels/auth_notifier.dart';
import '../models/account_model.dart';
import 'account_state.dart';
import 'package:expense_tracker/data/repositories/supabase_provider.dart';

final accountProvider = NotifierProvider<AccountNotifier, AccountState>(() {
  return AccountNotifier();
});

class AccountNotifier extends Notifier<AccountState> {
  @override
  AccountState build() {
    // Attempt to fetch accounts if user is already available
    final user = ref.watch(authProvider).user;
    if (user != null) {
      Future.microtask(() => fetchAccounts());
    }
    return AccountState();
  }

  Future<void> fetchAccounts() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    state = state.copyWith(isLoading: true);
    final result = await ref.read(supabaseHelperProvider).fetchAllAccounts(user.id);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: () => failure.message,
      ),
      (accounts) =>
          state = state.copyWith(isLoading: false, accounts: accounts),
    );
  }

  AccountModel? getAccountById(int? id) {
    if (id == null) return null;
    try {
      return state.accounts.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> createAccount({
    required String name,
    required AccountType type,
    required double balance,
  }) async {
    final user = ref.read(authProvider).user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await ref.read(supabaseHelperProvider).createAccount(
      userId: user.id,
      name: name,
      type: type,
      balance: balance,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      (account) {
        state = state.copyWith(
          isLoading: false,
          accounts: [...state.accounts, account],
        );
        return true;
      },
    );
  }
}
