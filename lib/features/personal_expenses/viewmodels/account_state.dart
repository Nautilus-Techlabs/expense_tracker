import '../models/account_model.dart';

class AccountState {
  final bool isLoading;
  final List<AccountModel> accounts;
  final String? errorMessage;

  AccountState({
    this.isLoading = false,
    this.accounts = const [],
    this.errorMessage,
  });

  AccountState copyWith({
    bool? isLoading,
    List<AccountModel>? accounts,
    String? Function()? errorMessage,
  }) {
    return AccountState(
      isLoading: isLoading ?? this.isLoading,
      accounts: accounts ?? this.accounts,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
