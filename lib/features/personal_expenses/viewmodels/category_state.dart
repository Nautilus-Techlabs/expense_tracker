import '../models/category_model.dart';

class CategoryState {
  final bool isLoading;
  final List<CategoryModel> categories;
  final String? errorMessage;

  CategoryState({
    this.isLoading = false,
    this.categories = const [],
    this.errorMessage,
  });

  CategoryState copyWith({
    bool? isLoading,
    List<CategoryModel>? categories,
    String? Function()? errorMessage,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
