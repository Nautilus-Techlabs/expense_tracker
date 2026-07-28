import 'package:expense_tracker/features/circle/models/circle_screen_model.dart';

class CircleState {
  final CircleScreenModel? screenData;
  final bool isLoading;
  final String? error;

  const CircleState({
    this.screenData,
    this.isLoading = false,
    this.error,
  });

  CircleState copyWith({
    CircleScreenModel? screenData,
    bool? isLoading,
    String? error,
  }) {
    return CircleState(
      screenData: screenData ?? this.screenData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

