import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache/cache_manager.dart';
import '../../../data/remote/supabase/supabase_helper.dart';
import '../model/user_payload.dart';
import 'auth_state.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  late final CacheManager _cacheManager;

  @override
  AuthState build() {
    _cacheManager = ref.watch(cacheManagerProvider);
    _init();
    return AuthState();
  }

  Future<void> _init() async {
    final cachedUser = await _cacheManager.getUser();
    final supabaseUser = SupabaseHelper().supabase.auth.currentUser;

    if (cachedUser != null && supabaseUser != null) {
      state = state.copyWith(user: () => cachedUser);
    } else if (supabaseUser != null) {
      final result = await SupabaseHelper().fetchUserProfile(supabaseUser.id);
      result.fold((l) => null, (user) {
        _cacheManager.saveUser(user);
        state = state.copyWith(user: () => user);
      });
    }
  }

  Future<bool> signUp(UserPayload payload) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await SupabaseHelper().createUser(payload);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      (user) async {
        await _cacheManager.saveUser(user);
        state = state.copyWith(isLoading: false, user: () => user);
        return true;
      },
    );
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await SupabaseHelper().signIn(email, password);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      (user) async {
        await _cacheManager.saveUser(user);
        state = state.copyWith(isLoading: false, user: () => user);
        return true;
      },
    );
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await SupabaseHelper().signInWithGoogle();

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }

  Future<void> signOut() async {
    await _cacheManager.deleteUser();
    // Also sign out from Supabase if needed
    await SupabaseHelper().supabase.auth.signOut();
    state = AuthState();
  }
}
