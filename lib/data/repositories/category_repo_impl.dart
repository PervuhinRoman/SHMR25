import '../../domain/models/category/category.dart';
import '../services/api_service.dart';
import 'category_repo.dart';
import '../database/transaction_database.dart';
import 'package:drift/drift.dart';
import 'dart:developer';

class CategoryRepoImpl implements CategoryRepository {
  final ApiService _apiService;
  final AppDatabase _database;

  CategoryRepoImpl([ApiService? apiService, AppDatabase? database])
    : _apiService = apiService ?? ApiService(),
      _database = database ?? AppDatabase.instance;

  final List<Category> _categories = [
    Category(id: 1, name: 'М', emoji: '💸', isIncome: true),
    Category(id: 2, name: 'О', emoji: '🥩', isIncome: false),
    Category(id: 3, name: 'К', emoji: '💡', isIncome: true),
    Category(id: 4, name: 'И', emoji: '🚌', isIncome: false),
  ];

  @override
  Future<List<Category>> getAllCategories() async {
    log('🔄 getAllCategories: начинаем загрузку категорий', name: 'CategoryRepo');
    try {
      log('🌐 getAllCategories: пытаемся получить из сети...', name: 'CategoryRepo');
      // Пытаемся получить из сети
      final categories = await _apiService.getCategories();
      log('✅ getAllCategories: получено из сети ${categories.length} категорий', name: 'CategoryRepo');
      
      // Сохраняем в кэш
      log('💾 getAllCategories: сохраняем в Drift-кэш...', name: 'CategoryRepo');
      await saveCategoriesDrift(categories);
      log('✅ getAllCategories: категории успешно сохранены в кэш', name: 'CategoryRepo');
      
      return categories;
    } catch (e) {
      log('❌ getAllCategories: ошибка сети: $e', name: 'CategoryRepo');
      // Если сеть недоступна, пробуем получить из кэша
      try {
        log('📱 getAllCategories: пытаемся получить из Drift-кэша...', name: 'CategoryRepo');
        final cachedCategories = await getCategoriesDrift();
        log('📱 getAllCategories: получено из кэша ${cachedCategories.length} категорий', name: 'CategoryRepo');
        if (cachedCategories.isNotEmpty) {
          log('✅ getAllCategories: возвращаем категории из кэша', name: 'CategoryRepo');
          return cachedCategories;
        } else {
          log('⚠️ getAllCategories: кэш пуст', name: 'CategoryRepo');
        }
      } catch (cacheError) {
        log('❌ getAllCategories: ошибка при получении из кэша: $cacheError', name: 'CategoryRepo');
        // Если кэш пуст или ошибка, используем fallback
      }
      
      // Fallback к локальным данным в случае ошибки
      log('🔄 getAllCategories: используем fallback данные (${_categories.length} категорий)', name: 'CategoryRepo');
      await Future.delayed(const Duration(milliseconds: 500));
      return _categories;
    }
  }

  @override
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    log('🔄 getCategoriesByType: начинаем загрузку категорий типа isIncome=$isIncome', name: 'CategoryRepo');
    try {
      log('🌐 getCategoriesByType: пытаемся получить из сети...', name: 'CategoryRepo');
      // Пытаемся получить из сети
      final categories = await _apiService.getCategoriesByType(isIncome);
      log('✅ getCategoriesByType: получено из сети ${categories.length} категорий типа isIncome=$isIncome', name: 'CategoryRepo');
      
      // Сохраняем в кэш (сохраняем все категории, чтобы не терять данные)
      log('💾 getCategoriesByType: сохраняем все категории в Drift-кэш...', name: 'CategoryRepo');
      final allCategories = await _apiService.getCategories();
      await saveCategoriesDrift(allCategories);
      log('✅ getCategoriesByType: все категории успешно сохранены в кэш', name: 'CategoryRepo');
      
      return categories;
    } catch (e) {
      log('❌ getCategoriesByType: ошибка сети: $e', name: 'CategoryRepo');
      // Если сеть недоступна, пробуем получить из кэша
      try {
        log('📱 getCategoriesByType: пытаемся получить из Drift-кэша...', name: 'CategoryRepo');
        final cachedCategories = await getCategoriesByTypeDrift(isIncome);
        log('📱 getCategoriesByType: получено из кэша ${cachedCategories.length} категорий типа isIncome=$isIncome', name: 'CategoryRepo');
        if (cachedCategories.isNotEmpty) {
          log('✅ getCategoriesByType: возвращаем категории из кэша', name: 'CategoryRepo');
          return cachedCategories;
        } else {
          log('⚠️ getCategoriesByType: кэш пуст для типа isIncome=$isIncome', name: 'CategoryRepo');
        }
      } catch (cacheError) {
        log('❌ getCategoriesByType: ошибка при получении из кэша: $cacheError', name: 'CategoryRepo');
        // Если кэш пуст или ошибка, используем fallback
      }
      
      // Fallback к локальным данным в случае ошибки
      final fallbackCategories = _categories
          .where((category) => category.isIncome == isIncome)
          .toList();
      log('🔄 getCategoriesByType: используем fallback данные (${fallbackCategories.length} категорий типа isIncome=$isIncome)', name: 'CategoryRepo');
      await Future.delayed(const Duration(milliseconds: 500));
      return fallbackCategories;
    }
  }

  // Сохранение категорий в Drift-кэш
  Future<void> saveCategoriesDrift(List<Category> categories) async {
    log('💾 saveCategoriesDrift: начинаем сохранение ${categories.length} категорий', name: 'CategoryRepo');
    try {
      final categoriesData = categories.map((category) => 
        CategoryDBCompanion(
          id: Value(category.id),
          name: Value(category.name),
          emoji: Value(category.emoji),
          isIncome: Value(category.isIncome),
        )
      ).toList();
      
      await _database.saveCategories(categoriesData);
      log('✅ saveCategoriesDrift: категории успешно сохранены в Drift', name: 'CategoryRepo');
    } catch (e) {
      log('❌ saveCategoriesDrift: ошибка при сохранении в Drift: $e', name: 'CategoryRepo');
      rethrow;
    }
  }

  // Получение всех категорий из Drift-кэша
  Future<List<Category>> getCategoriesDrift() async {
    log('📱 getCategoriesDrift: запрашиваем все категории из Drift', name: 'CategoryRepo');
    try {
      final categoriesData = await _database.getCategories();
      log('📱 getCategoriesDrift: получено ${categoriesData.length} категорий из Drift', name: 'CategoryRepo');
      final categories = categoriesData.map((data) => 
        Category(
          id: data.id,
          name: data.name,
          emoji: data.emoji,
          isIncome: data.isIncome,
        )
      ).toList();
      log('✅ getCategoriesDrift: успешно преобразовано в Category объекты', name: 'CategoryRepo');
      return categories;
    } catch (e) {
      log('❌ getCategoriesDrift: ошибка при получении из Drift: $e', name: 'CategoryRepo');
      rethrow;
    }
  }

  // Получение категорий по типу из Drift-кэша
  Future<List<Category>> getCategoriesByTypeDrift(bool isIncome) async {
    log('📱 getCategoriesByTypeDrift: запрашиваем категории типа isIncome=$isIncome из Drift', name: 'CategoryRepo');
    try {
      final categoriesData = await _database.getCategoriesByType(isIncome);
      log('📱 getCategoriesByTypeDrift: получено ${categoriesData.length} категорий типа isIncome=$isIncome из Drift', name: 'CategoryRepo');
      final categories = categoriesData.map((data) => 
        Category(
          id: data.id,
          name: data.name,
          emoji: data.emoji,
          isIncome: data.isIncome,
        )
      ).toList();
      log('✅ getCategoriesByTypeDrift: успешно преобразовано в Category объекты', name: 'CategoryRepo');
      return categories;
    } catch (e) {
      log('❌ getCategoriesByTypeDrift: ошибка при получении из Drift: $e', name: 'CategoryRepo');
      rethrow;
    }
  }
}
