import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/viewmodels/auth_notifier.dart';
import '../models/category_model.dart';
import 'category_state.dart';
import 'package:expense_tracker/data/repositories/supabase_provider.dart';

final categoryProvider = NotifierProvider<CategoryNotifier, CategoryState>(() {
  return CategoryNotifier();
});

final categoriesByTypeProvider = Provider.family<List<CategoryModel>, String>((
  ref,
  type,
) {
  final state = ref.watch(categoryProvider);
  return state.categories.where((c) {
    if (type == 'expense') {
      return c.type == CategoryType.expense || c.type == CategoryType.both;
    } else if (type == 'income') {
      return c.type == CategoryType.income || c.type == CategoryType.both;
    }
    return true; // Fallback
  }).toList();
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
    final result = await ref
        .read(supabaseHelperProvider)
        .fetchAllCategories(currentUserId: ref.read(authProvider).user!.id);

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

  CategoryModel? getCategoryById(int? id) {
    if (id == null) return null;
    try {
      return state.categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> addCategory({
    required String name,
    required CategoryType type,
    required String icon,
    required String color,
  }) async {
    final user = ref.read(authProvider).user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await ref
        .read(supabaseHelperProvider)
        .createCategory(
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
        state = state.copyWith(isLoading: false, categories: currentCategories);
        return true;
      },
    );
  }
}
