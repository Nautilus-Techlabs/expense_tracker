import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/remote/supabase/supabase_helper.dart';
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
}
