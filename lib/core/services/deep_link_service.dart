import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:expense_tracker/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cache/cache_manager.dart';

class DeepLinkState {
  final int? pendingCircleInvite;

  const DeepLinkState({this.pendingCircleInvite});

  DeepLinkState copyWith({int? pendingCircleInvite, bool clearInvite = false}) {
    return DeepLinkState(
      pendingCircleInvite:
          clearInvite ? null : (pendingCircleInvite ?? this.pendingCircleInvite),
    );
  }
}

class DeepLinkNotifier extends Notifier<DeepLinkState> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  DeepLinkState build() {
    _appLinks = AppLinks();
    _init();
    ref.onDispose(() => _linkSubscription?.cancel());
    return const DeepLinkState();
  }

  Future<void> _init() async {
    // Handle initial link (cold start)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
    } catch (e) {
      AppLogger.e('Error getting initial deep link: $e');
    }

    // Handle incoming links (warm start / while app is open)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (e) => AppLogger.e('Deep link stream error: $e'),
    );
  }

  Future<void> _handleUri(Uri uri) async {
    AppLogger.i('Deep link received: $uri');

    int? circleId;

    // Handle: expenselite://invite?circleId=42
    if (uri.scheme == 'expenselite' && uri.host == 'invite') {
      final idStr = uri.queryParameters['circleId'];
      circleId = int.tryParse(idStr ?? '');
    }

    // Handle: https://nt-epense-tracker-web.netlify.app/invite?circleId=42
    if (uri.scheme == 'https' &&
        uri.host == 'nt-epense-tracker-web.netlify.app' &&
        uri.path == '/invite') {
      final idStr = uri.queryParameters['circleId'];
      circleId = int.tryParse(idStr ?? '');
    }

    if (circleId != null) {
      AppLogger.i('Parsed circle invite: circleId=$circleId');
      
      final cache = ref.read(cacheManagerProvider);
      final processed = await cache.getProcessedInvites();
      
      if (!processed.contains(circleId)) {
        state = state.copyWith(pendingCircleInvite: circleId);
      } else {
        AppLogger.i('Invite $circleId already processed, ignoring.');
      }
    }
  }

  void clearPendingInvite() {
    state = state.copyWith(clearInvite: true);
  }
}

final deepLinkProvider = NotifierProvider<DeepLinkNotifier, DeepLinkState>(
  DeepLinkNotifier.new,
);
