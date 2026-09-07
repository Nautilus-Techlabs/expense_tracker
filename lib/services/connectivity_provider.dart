import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A StreamProvider that listens to network connectivity changes.
/// Yields true if the device is connected to the internet (mobile, wifi, ethernet, etc.).
/// Yields false if there is no connection.
final connectivityStreamProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  // Initial check
  final initialResult = await connectivity.checkConnectivity();
  yield !initialResult.contains(ConnectivityResult.none);

  // Listen for changes
  await for (final resultList in connectivity.onConnectivityChanged) {
    yield !resultList.contains(ConnectivityResult.none);
  }
});
