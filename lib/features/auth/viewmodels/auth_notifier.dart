import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache/cache_manager.dart';
import '../model/user_payload.dart';
import 'auth_state.dart';
import 'package:expense_tracker/data/repositories/supabase_provider.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  late final CacheManager _cacheManager;

  @override
  AuthState build() {
    _cacheManager = ref.watch(cacheManagerProvider);
    // Use a small delay to allow build to complete before triggering state change
    Future.microtask(() => _init());
    return AuthState(isLoading: true);
  }

  Future<void> _init() async {
    try {
      final cachedUser = await _cacheManager.getUser();

      if (cachedUser != null) {
        // Optimistically set the user from cache
        state = state.copyWith(user: () => cachedUser, isLoading: false);
      }

      final supabaseUser = ref.read(supabaseHelperProvider).supabase.auth.currentUser;

      if (supabaseUser != null) {
        // If we didn't have a cached user, but have a supabase user, fetch profile
        if (cachedUser == null) {
          final result = await ref.read(supabaseHelperProvider).fetchUserProfile(
            supabaseUser.id,
          );
          result.fold((l) => state = state.copyWith(isLoading: false), (user) {
            _cacheManager.saveUser(user);
            state = state.copyWith(user: () => user, isLoading: false);
          });
        } else if (cachedUser.authId != supabaseUser.id) {
          // Stale cache - fetch fresh profile
          final result = await ref.read(supabaseHelperProvider).fetchUserProfile(
            supabaseUser.id,
          );
          result.fold(
            (l) => signOut(), // Session mismatch, better log out
            (user) {
              _cacheManager.saveUser(user);
              state = state.copyWith(user: () => user, isLoading: false);
            },
          );
        } else {
          // Both match, we're good. Already set isLoading to false above.
          state = state.copyWith(isLoading: false);
        }
      } else {
        // No supabase user - if we had a cached user, it's invalid
        if (cachedUser != null) {
          await signOut();
        } else {
          state = state.copyWith(isLoading: false);
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> signUp(UserPayload payload) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await ref.read(supabaseHelperProvider).createUser(payload);

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

    final result = await ref.read(supabaseHelperProvider).signIn(email, password);

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

    final result = await ref.read(supabaseHelperProvider).signInWithGoogle();

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      (_) async {
        final profileResult = await ref.read(supabaseHelperProvider)
            .fetchOrCreateGoogleProfile();
        return profileResult.fold(
          (failure) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: () => failure.message,
            );
            return false;
          },
          (data) async {
            await _cacheManager.saveUser(data.user);
            state = state.copyWith(
              isLoading: false,
              user: () => data.user,
              isNewUser: data.isNewUser,
            );
            return true;
          },
        );
      },
    );
  }

  Future<void> signOut() async {
    await _cacheManager.deleteUser();
    // Also sign out from Supabase if needed
    await ref.read(supabaseHelperProvider).supabase.auth.signOut();
    state = AuthState();
  }
}
