import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/cubit/categories/category_cubit.dart';
import 'package:shmr_finance/presentation/widgets/item_category.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Мои статьи"),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Ошибка: ${state.error}'));
          }

          if (state.categories.isEmpty) {
            return const Center(child: Text('Нет категорий'));
          }

          return Column(
            children: [
              Container(
                height: 56,
                color: CustomAppTheme.figmaNavBarColor,
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    context.read<CategoryCubit>().searchCategories(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Найти статью...',
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                context.read<CategoryCubit>().clearSearch();
                              },
                            )
                            : const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: CustomAppTheme.figmaBgGrayColor,
              ),
              Expanded(
                child:
                    state.filteredCategories.isEmpty
                        ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Статья не найдена',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: state.filteredCategories.length,
                          itemBuilder: (context, index) {
                            final category = state.filteredCategories[index];
                            return Column(
                              children: [
                                ItemCategory(
                                  icon: category.emoji,
                                  categoryTitle: category.name,
                                ),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: CustomAppTheme.figmaBgGrayColor,
                                ),
                              ],
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
