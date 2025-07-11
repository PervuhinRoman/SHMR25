import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:shmr_finance/data/repositories/category_repo_impl.dart';
import 'package:shmr_finance/domain/models/category/category.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepoImpl _categoryRepo = CategoryRepoImpl();

  CategoryCubit() : super(const CategoryState(isLoading: true)) {
    loadAllCategories();
  }

  /// Загружает все категории
  Future<void> loadAllCategories() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      log('📱 Загружаю все категории...', name: 'Category');

      final categories = await _categoryRepo.getAllCategories();

      emit(
        state.copyWith(
          categories: categories,
          filteredCategories: categories,
          isLoading: false,
        ),
      );
      log('✅ Загружено ${categories.length} категорий', name: 'Category');
    } catch (e) {
      log('❌ Ошибка при загрузке категорий: $e', name: 'Category');
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Загружает категории по типу (доходы/расходы)
  Future<void> loadCategoriesByType(bool isIncome) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      log(
        '📱 Загружаю категории ${isIncome ? "доходов" : "расходов"}...',
        name: 'Category',
      );

      final categories = await _categoryRepo.getCategoriesByType(isIncome);

      emit(
        state.copyWith(
          categories: categories,
          //filteredCategories: categories,
          isLoading: false,
        ),
      );
      log(
        '✅ Загружено ${categories.length} категорий ${isIncome ? "доходов" : "расходов"}',
        name: 'Category',
      );
    } catch (e) {
      log('❌ Ошибка при загрузке категорий: $e', name: 'Category');
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Получает только категории расходов
  Future<void> loadExpenseCategories() async {
    await loadCategoriesByType(false);
  }

  /// Получает только категории доходов
  Future<void> loadIncomeCategories() async {
    await loadCategoriesByType(true);
  }

  /// Обновляет список категорий
  void updateCategories(List<Category> categories) {
    emit(
      state.copyWith(categories: categories, filteredCategories: categories),
    );
  }

  /// Очищает ошибку
  void clearError() {
    emit(state.copyWith(error: null));
  }

  /// Выполняет поиск по категориям с fuzzy search
  void searchCategories(String query) {
    if (query.isEmpty) {
      // Если запрос пустой, показываем все категории
      emit(
        state.copyWith(
          searchQuery: query,
          filteredCategories: state.categories,
        ),
      );
      return;
    }

    final results = <Category>[];
    final queryLower = query.toLowerCase();

    for (final category in state.categories) {
      // Ищем по названию категории
      final nameRatio = ratio(queryLower, category.name.toLowerCase());

      // Ищем по эмодзи (если пользователь ввел эмодзи)
      final emojiRatio = ratio(queryLower, category.emoji);

      // Если хотя бы одно совпадение выше порога (10%), добавляем в результаты
      if (nameRatio > 10 || emojiRatio > 10) {
        results.add(category);
      }
    }

    // Сортируем результаты по релевантности
    results.sort((a, b) {
      final aNameRatio = ratio(queryLower, a.name.toLowerCase());
      final aEmojiRatio = ratio(queryLower, a.emoji);
      final aMaxRatio = aNameRatio > aEmojiRatio ? aNameRatio : aEmojiRatio;

      final bNameRatio = ratio(queryLower, b.name.toLowerCase());
      final bEmojiRatio = ratio(queryLower, b.emoji);
      final bMaxRatio = bNameRatio > bEmojiRatio ? bNameRatio : bEmojiRatio;

      return bMaxRatio.compareTo(aMaxRatio); // Сортировка по убыванию
    });

    emit(state.copyWith(searchQuery: query, filteredCategories: results));

    log(
      '🔍 Поиск: "$query" - найдено ${results.length} результатов',
      name: 'Category',
    );
  }

  /// Очищает поиск
  void clearSearch() {
    emit(state.copyWith(searchQuery: '', filteredCategories: state.categories));
  }
}
