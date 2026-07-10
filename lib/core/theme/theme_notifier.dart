import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../cache/cache_manager.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final cacheManager = ref.watch(cacheManagerProvider);
  return ThemeNotifier(cacheManager);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final CacheManager _cacheManager;

  ThemeNotifier(this._cacheManager) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedMode = await _cacheManager.getThemeMode();
    if (savedMode != null) {
      state = _fromString(savedMode);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _cacheManager.saveThemeMode(mode.name);
  }

  ThemeMode _fromString(String mode) {
    return ThemeMode.values.firstWhere(
      (e) => e.name == mode,
      orElse: () => ThemeMode.system,
    );
  }
}
