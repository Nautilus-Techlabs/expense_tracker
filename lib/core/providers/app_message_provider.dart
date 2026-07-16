import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents a global snackbar message to show to the user.
class AppMessage {
  final String text;
  final bool isError;

  const AppMessage({required this.text, this.isError = false});
}

/// Holds a single pending message that the root app will observe and display.
/// After displaying, the UI should call [clear] to reset the state.
class AppMessageNotifier extends Notifier<AppMessage?> {
  @override
  AppMessage? build() => null;

  void showError(String message) {
    state = AppMessage(text: message, isError: true);
  }

  void showSuccess(String message) {
    state = AppMessage(text: message, isError: false);
  }

  void clear() {
    state = null;
  }
}

final appMessageProvider =
    NotifierProvider<AppMessageNotifier, AppMessage?>(AppMessageNotifier.new);
