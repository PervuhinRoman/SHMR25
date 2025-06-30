import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/cubit/datepicker_cubit.dart';
import 'package:shmr_finance/domain/cubit/transaction_cubit.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/presentation/widgets/item_analyze_category.dart';

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
    final startDate = datePickerCubit.state.startDate;
    final endDate = datePickerCubit.state.endDate;
    transactionCubit.fetchTransactions(
      isIncome: widget.isIncome,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    DatePickerCubit datePickerCubit = context.read<DatePickerCubit>();
    TransactionCubit transactionCubit = context.read<TransactionCubit>();

    return BlocListener<DatePickerCubit, DatePickerState>(
      listener: (context, datePickerState) {
        final transactionCubit = context.read<TransactionCubit>();
        transactionCubit.fetchTransactions(
          isIncome: widget.isIncome,
          startDate: datePickerState.startDate,
          endDate: datePickerState.endDate,
        );
      },
      child: BlocBuilder<DatePickerCubit, DatePickerState>(
        builder: (context, datePickerState) {
          return BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, transactionState) {
              // final categories = transactionState.transactionsCategories;
              final categories = transactionState.combineCategories;

              final totalSum = categories.fold<num>(
                0,
                    (sum, item) => sum + item.totalAmount,
              );
              
              print("📃 Все категории из транзакций в виджете анализа: $categories");
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
                          Text("Период: начало"),
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
                                        datePickerState.startDate ??
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
                        children: [Text("Сумма"), Text("${totalSum} ₽")],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: CustomAppTheme.figmaBgGrayColor,
                    ),
                    Text("ГРАФИК", textAlign: TextAlign.center),
                    Expanded(
                      child: () {
                        if (transactionState.status ==
                            TransactionStatus.loading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (transactionState.status == TransactionStatus.error) {
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
                                  percent: (item.totalAmount * 100 / totalSum).toStringAsFixed(2).toString(),
                                  totalSum: item.totalAmount.toString(),
                                  lastTransaction: item.lastTransaction?.comment,
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
