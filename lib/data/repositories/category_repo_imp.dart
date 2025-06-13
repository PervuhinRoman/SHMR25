import '../../domain/models/category/category.dart';
import 'category_repo.dart';

class MockCategoryRepository implements CategoryRepository {
  final List<Category> _categories = [
    Category(
      id: 1,
      name: 'Зарплата',
      emoji: '💸',
      isIncome: true,
    ),
    Category(
      id: 2,
      name: 'Продукты',
      emoji: '🥩',
      isIncome: false,
    ),
    Category(
      id: 3,
      name: 'Подработка',
      emoji: '💡',
      isIncome: true,
    ),
    Category(
      id: 4,
      name: 'Транспорт',
      emoji: '🚌',
      isIncome: false,
    ),
  ];

  @override
  Future<List<Category>> getAllCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _categories;
  }

  @override
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _categories.where((category) => category.isIncome == isIncome).toList();
  }
}