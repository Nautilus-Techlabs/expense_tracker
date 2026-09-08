import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failure.dart';
import '../../../../data/repositories/supabase_provider.dart';

class FeedbackNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Either<Failure, bool>> checkEligibility() async {
    final helper = ref.read(supabaseHelperProvider);
    return await helper.checkFeedbackEligibility();
  }

  Future<Either<Failure, bool>> consumePrompt() async {
    final helper = ref.read(supabaseHelperProvider);
    return await helper.consumeFeedbackPrompt();
  }

  Future<Either<Failure, int>> sendFeedback({
    required String feedbackText,
    String? appVersion,
  }) async {
    state = const AsyncValue.loading();
    final helper = ref.read(supabaseHelperProvider);
    final result = await helper.sendFeedback(
      feedbackText: feedbackText,
      appVersion: appVersion,
    );

    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (id) => state = const AsyncValue.data(null),
    );

    return result;
  }
}

final feedbackProvider = NotifierProvider<FeedbackNotifier, AsyncValue<void>>(
  FeedbackNotifier.new,
);
