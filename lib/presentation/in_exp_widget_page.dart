import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/models/transaction/transaction.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/presentation/widgets/item_inexp.dart';
import 'package:intl/intl.dart';

import '../domain/bloc/transaction_bloc.dart';

class InExpWidgetPage extends StatefulWidget {
  final bool isIncome;

  const InExpWidgetPage({super.key, required this.isIncome});

  @override
  State<InExpWidgetPage> createState() => _InExpWidgetPageState();
}

class _InExpWidgetPageState extends State<InExpWidgetPage> {
  late DateTime _startDate1;
  late DateTime _endDate1;

  DateTime addMonth(DateTime summand, int step) {
    late DateTime result;
    if (step.abs() >= summand.month) {
      result = DateTime(
        summand.year - 1,
        summand.month + step + 12,
        summand.day,
      );
    } else {
      result = DateTime(summand.year, summand.month + step, summand.day);
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    // Устанавливаем период по умолчанию: месяц назад - сегодня
    _endDate1 = DateTime.now();
    _startDate1 = DateTime(_endDate1.year, _endDate1.month - 1, _endDate1.day);
    // Корректировка если текущий месяц январь
    if (_startDate1.month == 0) {
      _startDate1 = DateTime(_endDate1.year - 1, 12, _endDate1.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isIncome ? "Доходы сегодня" : "Расходы сегодня",
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Placeholder(); // TODO: передавать с параметром isIncome
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          } else if (state is TransactionLoaded) {
            final rawResponses = state.transactions;
            final responses = <TransactionResponse>[];
            for (final response in rawResponses) {
              if (response.category.isIncome && widget.isIncome ||
                  !response.category.isIncome && !widget.isIncome) {
                // Если ДОХОД и ДОХОД или НЕДОХОД и НЕДОХОД
                responses.add(response);
                // print(response.toJson());
              }
            }
            final total = responses.fold<num>(
              0,
              (sum, item) => sum + double.parse(item.amount),
            );
            return Column(
              children: [
                // Начало
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      helpText: 'Выберите дату',
                      cancelText: 'Отмена',
                      confirmText: 'ОК',
                    ).then((result) {
                      setState(() {
                        _startDate1 = result!;
                      });
                    });
                  },
                  child: Container(
                    color: CustomAppTheme.figmaMainLightColor,
                    height: 56,
                    child: Row(
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text("Начало", textAlign: TextAlign.start),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Text(
                              // "${addMonth(_endDate, -1).day}.${addMonth(_endDate, -1).month}.${addMonth(_endDate, -1).year}",
                              "${_startDate1.day}.${_startDate1.month}.${_startDate1.year}",
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
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: _endDate1,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      helpText: 'Выберите дату',
                      cancelText: 'Отмена',
                      confirmText: 'ОК',
                    ).then((result) {
                      setState(() {
                        _endDate1 = result!;
                      });
                    });
                  },
                  child: Container(
                    color: CustomAppTheme.figmaMainLightColor,
                    height: 56,
                    child: Row(
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text("Конец", textAlign: TextAlign.start),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Text(
                              "${_endDate1.day}.${_endDate1.month}.${_endDate1.year}",
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
                          child: Text("Сумма", textAlign: TextAlign.start),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text("$total ₽", textAlign: TextAlign.end),
                        ),
                      ),
                    ],
                  ),
                ),
                // Список транзакций
                Expanded(
                  child: ListView.builder(
                    itemCount: responses.length * 2 + 1,
                    itemBuilder: (context, index) {
                      if (index.isEven) {
                        return const Divider(
                          height: 1,
                          thickness: 1,
                          color: CustomAppTheme.figmaBgGrayColor,
                        );
                      } else {
                        final itemIndex = index ~/ 2;
                        final item = responses[itemIndex];
                        return InExpItem(
                          category_title: item.category.name,
                          amount: item.amount,
                          icon: item.category.emoji,
                          comment: item.comment,
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
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
