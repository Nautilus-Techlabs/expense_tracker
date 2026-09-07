import 'package:expense_tracker/features/circle/models/circle_details_screen_model.dart';

class CircleDetailsState {
  final CircleDetailScreenModel? screenData;
  final bool isLoading;
  final String? error;

  const CircleDetailsState({
    this.screenData,
    this.isLoading = false,
    this.error,
  });

  CircleDetailsState copyWith({
    CircleDetailScreenModel? screenData,
    bool? isLoading,
    String? error,
  }) {
    return CircleDetailsState(
      screenData: screenData ?? this.screenData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
