import '../model/user_model.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final UserModel? user;

  AuthState({this.isLoading = false, this.errorMessage, this.user});

  AuthState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
    UserModel? Function()? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      user: user != null ? user() : this.user,
    );
  }
}
