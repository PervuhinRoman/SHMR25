import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/cubit/transactions/datepicker_cubit.dart';
import 'package:shmr_finance/domain/cubit/transactions/transaction_cubit.dart';
import 'package:shmr_finance/domain/models/category/combine_category.dart';
import 'package:shmr_finance/presentation/selected_category_page.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/presentation/widgets/item_analyze_category.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pie_chart_widget/pie_chart_widget.dart';
import 'package:shmr_finance/domain/cubit/account/account_cubit.dart';

class AnalyzePage extends StatefulWidget {
  final bool isIncome;

  const AnalyzePage({super.key, required this.isIncome});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  @override
  void initState() {
    super.initState();

    final datePickerCubit = context.read<DatePickerCubit>();
    final transactionCubit = context.read<TransactionCubit>();
    final accountState = context.read<MyAccountCubit>().state;
    final startDate = datePickerCubit.state.startDate;
    final endDate = datePickerCubit.state.endDate;
    final accountId = accountState.accountId ?? 1;
    transactionCubit.fetchTransactions(
      accountId: accountId,
      isIncome: widget.isIncome,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Widget _buildPieChart(List<CombineCategory> categories, double totalSum) {
    // Отладочная информация
    log(
      "�� График: количество категорий = ${categories.length}",
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

    // Конвертируем данные в формат для пакета
    final chartSections =
        categories.map((category) {
          return ChartSection.fromData(
            id: category.category.id.toString(),
            name: category.category.name,
            emoji: category.category.emoji,
            value: category.totalAmount.toDouble(),
            totalValue: totalSum,
            additionalInfo: category.lastTransaction?.comment,
          );
        }).toList();

    // Конфигурация графика
    final config = PieChartConfig(
      size: 300.0,
      sectionRadius: 16.0,
      centerSpaceRadius: 100.0,
      legendDotSize: 12.0,
      legendFontSize: 12.0,
      maxLegendWidth: 180.0,
      maxLegendHeight: 180.0,
      legendRowSpacing: 1.0,
      enableAnimation: true,
      animationDuration: const Duration(milliseconds: 1500),
      enableTooltips: true,
      showLegend: true,
      showPercentages: true,
      numberFormat: '#,##0.00',
    );

    return Center(
      child: PieChartWidget(
        sections: chartSections,
        config: config,
        onSectionTap: (section) {
          log("📊 Нажата секция: ${section.name}", name: 'PieChart');
        },
        onLegendTap: (section) {
          log("📊 Нажата легенда: ${section.name}", name: 'PieChart');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DatePickerCubit datePickerCubit = context.read<DatePickerCubit>();

    return BlocListener<DatePickerCubit, DatePickerState>(
      listener: (context, datePickerState) {
        final transactionCubit = context.read<TransactionCubit>();
        final accountState = context.read<MyAccountCubit>().state;
        final accountId = accountState.accountId ?? 1;
        transactionCubit.fetchTransactions(
          accountId: accountId,
          isIncome: widget.isIncome,
          startDate: datePickerState.startDate,
          endDate: datePickerState.endDate,
        );
      },
      child: BlocBuilder<DatePickerCubit, DatePickerState>(
        builder: (context, datePickerState) {
          final l10n = AppLocalizations.of(context)!;
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
                appBar: CustomAppBar(
                  title: l10n.analysis,
                  bgColor: Colors.white,
                ),
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
                          Text(l10n.periodStart),
                          InputChip(
                            label: Text(
                              datePickerState.startDate != null
                                  ? DateFormat(
                                    'dd.MM.yyyy',
                                  ).format(datePickerState.startDate!)
                                  : l10n.selectDate,
                              textAlign: TextAlign.end,
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
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
                                    helpText: l10n.selectStartDate,
                                    cancelText: l10n.cancel,
                                    confirmText: l10n.ok,
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
                          Text(l10n.periodEnd),
                          InputChip(
                            label: Text(
                              datePickerState.endDate != null
                                  ? DateFormat(
                                    'dd.MM.yyyy',
                                  ).format(datePickerState.endDate!)
                                  : l10n.selectDate,
                              textAlign: TextAlign.end,
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
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
                                    helpText: l10n.selectEndDate,
                                    cancelText: l10n.cancel,
                                    confirmText: l10n.ok,
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
                          Text(l10n.transactionAmount),
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
                            child: Text(
                              '${l10n.error}: ${transactionState.error}',
                            ),
                          );
                        }
                        if (categories.isEmpty) {
                          return Center(child: Text(l10n.noDataForPeriod));
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
