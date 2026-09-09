import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/supabase_provider.dart';
import '../../../core/utils/app_logger.dart';

enum JoinCircleStatus { loadingInfo, ready, joining, failedToLoad }

class JoinCircleState {
  final JoinCircleStatus status;
  final String circleName;
  final String ownerName;

  const JoinCircleState({
    this.status = JoinCircleStatus.loadingInfo,
    this.circleName = 'a circle',
    this.ownerName = 'someone',
  });

  JoinCircleState copyWith({
    JoinCircleStatus? status,
    String? circleName,
    String? ownerName,
  }) {
    return JoinCircleState(
      status: status ?? this.status,
      circleName: circleName ?? this.circleName,
      ownerName: ownerName ?? this.ownerName,
    );
  }

  bool get isLoadingInfo => status == JoinCircleStatus.loadingInfo;
  bool get isReady => status == JoinCircleStatus.ready;
  bool get isJoining => status == JoinCircleStatus.joining;
  bool get hasFailed => status == JoinCircleStatus.failedToLoad;
}

// ── Provider ─────────────────────────────────────────────────
final joinCircleProvider =
    NotifierProvider<JoinCircleNotifier, JoinCircleState>(
      JoinCircleNotifier.new,
    );

// ── Notifier ─────────────────────────────────────────────────
class JoinCircleNotifier extends Notifier<JoinCircleState> {
  @override
  JoinCircleState build() => const JoinCircleState();

  Future<void> loadCircleInfo(int circleId) async {
    state = state.copyWith(status: JoinCircleStatus.loadingInfo);
    try {
      final result = await ref
          .read(supabaseHelperProvider)
          .getCircleInviteInfo(circleId);
      result.fold(
        (failure) {
          AppLogger.e('Failed to fetch circle info: ${failure.message}');
          state = state.copyWith(status: JoinCircleStatus.failedToLoad);
        },
        (info) {
          state = state.copyWith(
            circleName: info['circleName'] ?? 'a circle',
            ownerName: info['ownerName'] ?? 'someone',
            status: JoinCircleStatus.ready,
          );
        },
      );
    } catch (e) {
      AppLogger.e('Exception fetching circle info: $e');
      state = state.copyWith(status: JoinCircleStatus.failedToLoad);
    }
  }

  void setJoining() => state = state.copyWith(status: JoinCircleStatus.joining);

  void setReady() => state = state.copyWith(status: JoinCircleStatus.ready);
}
