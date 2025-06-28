import 'package:shmr_finance/domain/models/category/category.dart';

class CategoryState {
  final List<Category> categories;
  final List<Category> filteredCategories;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const CategoryState({
    this.categories = const [],
    this.filteredCategories = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  CategoryState copyWith({
    List<Category>? categories,
    List<Category>? filteredCategories,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
} 