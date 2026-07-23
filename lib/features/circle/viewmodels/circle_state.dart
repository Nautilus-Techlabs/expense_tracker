
import 'package:expense_tracker/features/circle/models/circle_data.dart';

class CircleState {
  final List<CircleData> circles;
  final bool isLoading;
  final String? error;

  const CircleState({
    this.circles = const [],
    this.isLoading = false,
    this.error,
  });

  CircleState copyWith({
    List<CircleData>? circles,
    bool? isLoading,
    String? error,
  }) {
    return CircleState(
      circles: circles ?? this.circles,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
