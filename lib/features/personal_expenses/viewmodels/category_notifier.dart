import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/remote/supabase/supabase_helper.dart';
import '../../auth/viewmodels/auth_notifier.dart';
import 'category_state.dart';

final categoryProvider =
    NotifierProvider<CategoryNotifier, CategoryState>(() {
  return CategoryNotifier();
});

class CategoryNotifier extends Notifier<CategoryState> {
  @override
  CategoryState build() {
    // Fetch categories on init — categories are user-agnostic (system + user)
    Future.microtask(() => fetchCategories());
    return CategoryState();
  }

  Future<void> fetchCategories() async {
    state = state.copyWith(isLoading: true);
    final result = await SupabaseHelper().fetchAllCategories();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: () => failure.message,
      ),
      (categories) {
        // Only keep active categories
        final active = categories.where((c) => c.isActive).toList();
        state = state.copyWith(isLoading: false, categories: active);
      },
    );
  }

  Future<bool> addCategory({
    required String name,
    required String type, // 'expense', 'income', 'both'
    required String icon,
    required String color,
  }) async {
    final user = ref.read(authProvider).user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await SupabaseHelper().createCategory(
      userId: user.id,
      name: name,
      type: type,
      icon: icon,
      color: color,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      (newCategory) {
        final currentCategories = List.of(state.categories);
        currentCategories.add(newCategory);
        state = state.copyWith(
          isLoading: false,
          categories: currentCategories,
        );
        return true;
      },
    );
  }
}
