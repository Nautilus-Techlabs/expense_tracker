import '../model/user_model.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final UserModel? user;
  final bool isNewUser;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.isNewUser = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
    UserModel? Function()? user,
    bool? isNewUser,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      user: user != null ? user() : this.user,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}
