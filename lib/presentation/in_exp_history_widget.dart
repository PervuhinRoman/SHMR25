import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/cubit/datepicker_cubit.dart';
import 'package:shmr_finance/domain/cubit/sort_type_cubit.dart';
import 'package:shmr_finance/domain/cubit/transaction_cubit.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/presentation/widgets/item_inexp.dart';

class InExpHistoryWidget extends StatefulWidget {
  final bool isIncome;

  const InExpHistoryWidget({super.key, required this.isIncome});

  @override
  State<InExpHistoryWidget> createState() => _InExpHistoryWidgetState();
}

class _InExpHistoryWidgetState extends State<InExpHistoryWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final datePickerState = context.read<DatePickerCubit>().state;
      context.read<TransactionCubit>().fetchTransactions(
        startDate: datePickerState.startDate!,
        endDate: datePickerState.endDate!,
        isIncome: widget.isIncome,
      );
    });
  }

  @override
  void didUpdateWidget(covariant InExpHistoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isIncome != widget.isIncome) {
      final datePickerState = context.read<DatePickerCubit>().state;
      context.read<TransactionCubit>().fetchTransactions(
        startDate: datePickerState.startDate!,
        endDate: datePickerState.endDate!,
        isIncome: widget.isIncome,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    DatePickerCubit datePickerCubit = context.read<DatePickerCubit>();
    TransactionCubit transactionCubit = context.read<TransactionCubit>();
    SortTypeCubit sortTypeCubit = context.read<SortTypeCubit>();

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isIncome ? "История доходов" : "История расходов",
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Placeholder();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SortTypeCubit, SortTypeState>(
        builder: (context, sortState) {
          return BlocBuilder<DatePickerCubit, DatePickerState>(
            builder: (context, datePickerState) {
              return BlocBuilder<TransactionCubit, TransactionState>(
                builder: (context, transactionState) {
                  final transactions = transactionState.transactions;
                  final totalSum = transactions.fold<num>(
                    0,
                    (sum, item) => sum + double.parse(item.amount),
                  );
                  return Column(
                    children: [
                      // Начало
                      GestureDetector(
                        onTap: () async {
                          final DateTime? resultStartDate =
                              await showDatePicker(
                                context: context,
                                initialDate:
                                    datePickerState.startDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                helpText: 'Выберите дату начала',
                                cancelText: 'Отмена',
                                confirmText: 'ОК',
                              );
                          if (resultStartDate != null) {
                            datePickerCubit.setStartDate(resultStartDate);
                            transactionCubit.fetchTransactions(
                              startDate: resultStartDate,
                              endDate: datePickerState.endDate,
                              isIncome: widget.isIncome,
                            );
                          }
                        },
                        child: Container(
                          color: CustomAppTheme.figmaMainLightColor,
                          height: 56,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                    "Начало",
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Text(
                                    datePickerState.startDate != null
                                        ? DateFormat(
                                          'dd.MM.yyyy',
                                        ).format(datePickerState.startDate!)
                                        : "Выберите дату",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: CustomAppTheme.figmaBgGrayColor,
                      ),
                      // Конец
                      GestureDetector(
                        onTap: () async {
                          final DateTime? resultEndDate = await showDatePicker(
                            context: context,
                            initialDate:
                                datePickerState.endDate ?? DateTime.now(),
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
                        child: Container(
                          color: CustomAppTheme.figmaMainLightColor,
                          height: 56,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                    "Конец",
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Text(
                                    datePickerState.endDate != null
                                        ? DateFormat(
                                          'dd.MM.yyyy',
                                        ).format(datePickerState.endDate!)
                                        : "Выберите дату",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: CustomAppTheme.figmaBgGrayColor,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final result = await showModalBottomSheet(
                            context: context,
                            builder:
                                (ctx) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Text('По дате'),
                                      trailing: const Icon(Icons.date_range),
                                      onTap: () {
                                        sortTypeCubit.changeSortType(
                                          SortType.date,
                                        );
                                        transactionCubit.sort(SortType.date);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('По сумме'),
                                      trailing: const Icon(Icons.attach_money),
                                      onTap: () {
                                        sortTypeCubit.changeSortType(
                                          SortType.amount,
                                        );
                                        transactionCubit.sort(SortType.amount);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                          );
                        },
                        child: Container(
                          color: CustomAppTheme.figmaMainLightColor,
                          height: 56,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                    "Сортировка",
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Text(
                                    sortState.sortType == SortType.date
                                        ? "По дате"
                                        : "По сумме",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: CustomAppTheme.figmaBgGrayColor,
                      ),
                      // Сумма
                      Container(
                        color: CustomAppTheme.figmaMainLightColor,
                        height: 56,
                        child: Row(
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "Сумма",
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Text(
                                  "$totalSum ₽", // TODO: добавить форматирование вывода суммы по разрядам и кол-во символов после точки
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Список транзакций
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
                          if (transactions.isEmpty) {
                            return const Center(
                              child: Text('Нет данных за период'),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: transactions.length * 2 + 1,
                              itemBuilder: (context, index) {
                                if (index.isEven) {
                                  return const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: CustomAppTheme.figmaBgGrayColor,
                                  );
                                } else {
                                  final itemIndex = index ~/ 2;
                                  if (itemIndex >= transactions.length) {
                                    return const SizedBox.shrink();
                                  }
                                  final item = transactions[itemIndex];
                                  return InExpItem(
                                    categoryTitle: item.category.name,
                                    amount: item.amount,
                                    icon: item.category.emoji,
                                    time: item.transactionDate,
                                    comment: item.comment,
                                  );
                                }
                              },
                            );
                          }
                        }(),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
