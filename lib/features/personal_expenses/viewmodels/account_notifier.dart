import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/remote/supabase/supabase_helper.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import '../models/account_model.dart';
import 'account_state.dart';

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
    final result = await SupabaseHelper().fetchAllAccounts(user.id);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: () => failure.message,
      ),
      (accounts) =>
          state = state.copyWith(isLoading: false, accounts: accounts),
    );
  }

  Future<bool> createAccount({
    required String name,
    required AccountType type,
    required double balance,
  }) async {
    final user = ref.read(authProvider).user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await SupabaseHelper().createAccount(
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
