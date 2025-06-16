import '../../domain/models/category/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();
  Future<List<Category>> getCategoriesByType(bool isIncome);
}