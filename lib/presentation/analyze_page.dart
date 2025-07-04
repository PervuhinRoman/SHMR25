import 'dart:developer';
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/cubit/transactions/datepicker_cubit.dart';
import 'package:shmr_finance/domain/cubit/transactions/transaction_cubit.dart';
import 'package:shmr_finance/domain/models/category/combine_category.dart';
import 'package:shmr_finance/presentation/selected_category_page.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/presentation/widgets/item_analyze_category.dart';

class AnalyzePage extends StatefulWidget {
  final bool isIncome;

  const AnalyzePage({super.key, required this.isIncome});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  bool _isShowingTooltip = false;

  // Генератор случайных цветов
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Анимация исчезновения старого контента (0-50% времени)
    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    final datePickerCubit = context.read<DatePickerCubit>();
    final transactionCubit = context.read<TransactionCubit>();
    final startDate = datePickerCubit.state.startDate;
    final endDate = datePickerCubit.state.endDate;
    transactionCubit.fetchTransactions(
      isIncome: widget.isIncome,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  Color _getColorForIndex(int index, int totalCategories) {
    // Генерируем детерминированный цвет на основе индекса
    // чтобы цвета оставались постоянными для одной категории
    final hue = (index * 360.0 / totalCategories) % 360.0;
    final saturation = 0.7 + (_random.nextDouble() * 0.3); // 70-100%
    final lightness = 0.4 + (_random.nextDouble() * 0.3); // 40-70%

    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  Widget _buildPieChart(List<CombineCategory> categories, double totalSum) {
    // Отладочная информация
    log(
      "📊 График: количество категорий = ${categories.length}",
      name: 'PieChart',
    );
    log("📊 График: общая сумма = $totalSum", name: 'PieChart');
    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      log(
        "📊 Категория $i: ${category.category.name} - ${category.totalAmount}",
        name: 'PieChart',
      );
    }

    if (categories.isEmpty) {
      return SizedBox(
        height: 300,
        width: 300,
        child: Stack(
          children: [
            Center(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 1,
                      color: Colors.grey[300]!,
                      radius: 16,
                      title: '',
                    ),
                  ],
                  centerSpaceRadius: 100,
                  sectionsSpace: 0,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pie_chart, size: 32, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'Нет категорий',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Определяем, какой контент показывать
        final isNewContent = _animationController.value > 0.5;
        final fadeValue =
            isNewContent
                ? (_animationController.value - 0.5) *
                    2 // 0-1 для нового контента
                : 1 -
                    (_animationController.value *
                        2); // 1-0 для старого контента

        final sections =
            categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              final percentage = (category.totalAmount * 100 / totalSum);

              log(
                "📊 Сектор $index: ${category.category.name} - ${category.totalAmount} (${percentage.toStringAsFixed(1)}%)",
                name: 'PieChart',
              );

              return PieChartSectionData(
                value: category.totalAmount.toDouble(),
                color: _getColorForIndex(index, categories.length),
                radius: 16,
                title: '',
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                badgeWidget: null,
                badgePositionPercentageOffset: 1.2,
              );
            }).toList();

        log("📊 Создано секторов: ${sections.length}", name: 'PieChart');

        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: Opacity(
            opacity: fadeValue,
            child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                children: [
                  Center(
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 100,
                        sectionsSpace: 2,
                        pieTouchData: PieTouchData(
                          touchCallback: (
                            FlTouchEvent event,
                            pieTouchResponse,
                          ) {
                            if (event.isInterestedForInteractions &&
                                pieTouchResponse != null) {
                              final touchedSection =
                                  pieTouchResponse.touchedSection;
                              if (touchedSection != null) {
                                final category =
                                    categories[touchedSection
                                        .touchedSectionIndex];
                                _showTooltip(context, category);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  // Легенда внутри графика
                  // TODO: можно прикрутить сортировку по процентам
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 180,
                        maxHeight: 180,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                            categories.asMap().entries.map((entry) {
                              final index = entry.key;
                              final category = entry.value;
                              final percentage =
                                  (category.totalAmount * 100 / totalSum);

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 1,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Цветной кружок
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: _getColorForIndex(
                                          index,
                                          categories.length,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    // Процент и название
                                    Flexible(
                                      child: Text(
                                        '${percentage.toStringAsFixed(0)}% ${category.category.name}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTooltip(BuildContext context, dynamic category) {
    // Защита от повторных вызовов
    if (_isShowingTooltip) return;

    _isShowingTooltip = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(category.category.emoji),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.category.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Text(
            'Сумма: ${NumberFormat('#,##0.00', 'ru_RU').format(category.totalAmount)} ₽',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    ).then((_) {
      // Сбрасываем флаг когда диалог закрывается
      _isShowingTooltip = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    DatePickerCubit datePickerCubit = context.read<DatePickerCubit>();

    return BlocListener<DatePickerCubit, DatePickerState>(
      listener: (context, datePickerState) {
        final transactionCubit = context.read<TransactionCubit>();
        transactionCubit.fetchTransactions(
          isIncome: widget.isIncome,
          startDate: datePickerState.startDate,
          endDate: datePickerState.endDate,
        );
        // Запускаем анимацию при изменении данных
        _startAnimation();
      },
      child: BlocBuilder<DatePickerCubit, DatePickerState>(
        builder: (context, datePickerState) {
          return BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, transactionState) {
              final categories = transactionState.combineCategories;

              final totalSum = categories.fold<num>(
                0,
                (sum, item) => sum + item.totalAmount,
              );

              log(
                "📃 Все категории из транзакций в виджет анализа: $categories",
                name: 'Category',
              );
              return Scaffold(
                appBar: CustomAppBar(title: "Анализ", bgColor: Colors.white),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Период: начало"),
                          InputChip(
                            label: Text(
                              datePickerState.startDate != null
                                  ? DateFormat(
                                    'dd.MM.yyyy',
                                  ).format(datePickerState.startDate!)
                                  : "Выберите дату",
                              textAlign: TextAlign.end,
                            ),
                            backgroundColor: CustomAppTheme.figmaMainColor,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            onPressed: () async {
                              final DateTime? resultStartDate =
                                  await showDatePicker(
                                    context: context,
                                    initialDate:
                                        datePickerState.startDate ??
                                        DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    helpText: 'Выберите дату начала',
                                    cancelText: 'Отмена',
                                    confirmText: 'ОК',
                                  );
                              if (resultStartDate != null) {
                                datePickerCubit.setStartDate(resultStartDate);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: CustomAppTheme.figmaBgGrayColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 10,
                        top: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Период: конец"),
                          InputChip(
                            label: Text(
                              datePickerState.endDate != null
                                  ? DateFormat(
                                    'dd.MM.yyyy',
                                  ).format(datePickerState.endDate!)
                                  : "Выберите дату",
                              textAlign: TextAlign.end,
                            ),
                            backgroundColor: CustomAppTheme.figmaMainColor,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            onPressed: () async {
                              final DateTime? resultEndDate =
                                  await showDatePicker(
                                    context: context,
                                    initialDate:
                                        datePickerState.endDate ??
                                        DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    helpText: 'Выберите дату конца',
                                    cancelText: 'Отмена',
                                    confirmText: 'ОК',
                                  );
                              if (resultEndDate != null) {
                                datePickerCubit.setEndDate(resultEndDate);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: CustomAppTheme.figmaBgGrayColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Сумма"),
                          Text(
                            "${NumberFormat('#,##0.00', 'ru_RU').format(totalSum)} ₽",
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: CustomAppTheme.figmaBgGrayColor,
                    ),
                    // Круговой график
                    Center(
                      child: _buildPieChart(categories, totalSum.toDouble()),
                    ),
                    Expanded(
                      child: () {
                        if (transactionState.status ==
                            TransactionStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (transactionState.status ==
                            TransactionStatus.error) {
                          return Center(
                            child: Text('Ошибка: ${transactionState.error}'),
                          );
                        }
                        if (categories.isEmpty) {
                          return const Center(
                            child: Text('Нет данных за период'),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: categories.length * 2 + 1,
                            itemBuilder: (context, index) {
                              if (index.isEven) {
                                return const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: CustomAppTheme.figmaBgGrayColor,
                                );
                              } else {
                                final itemIndex = index ~/ 2;
                                if (itemIndex >= categories.length) {
                                  return const SizedBox.shrink();
                                }
                                final item = categories[itemIndex];
                                return ItemAnalyzeCategory(
                                  categoryTitle: item.category.name,
                                  icon: item.category.emoji,
                                  percent:
                                      (item.totalAmount * 100 / totalSum)
                                          .toStringAsFixed(2)
                                          .toString(),
                                  totalSum: item.totalAmount.toString(),
                                  lastTransaction:
                                      item.lastTransaction?.comment,
                                  categoryId: item.category.id,
                                  onTapFunc: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => BlocProvider(
                                              create:
                                                  (context) =>
                                                      DatePickerCubit(),
                                              child: SelectedCategoryPage(
                                                isIncome: widget.isIncome,
                                                selectedCategory: item.category,
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          );
                        }
                      }(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
