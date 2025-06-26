import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/presentation/widgets/item_inexp.dart';

import '../app_theme.dart';
import '../domain/cubit/datepicker_cubit.dart';
import '../domain/cubit/transaction_cubit.dart';
import 'in_exp_history_widget.dart';

class InExpWidget extends StatefulWidget {
  final bool isIncome;
  const InExpWidget({super.key, required this.isIncome});

  @override
  State<InExpWidget> createState() => _InExpWidgetState();
}

class _InExpWidgetState extends State<InExpWidget> {
  @override
  Widget build(BuildContext context) {
    TransactionCubit transactionCubit = context.read<TransactionCubit>();

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
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<DatePickerCubit>(
                          create: (context) => DatePickerCubit(),
                        ),
                        BlocProvider<TransactionCubit>(
                          create: (context) => TransactionCubit(),
                        ),
                      ],
                      child: InExpHistoryWidget(isIncome: widget.isIncome),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          transactionCubit.fetchTransactions(
            startDate: DateTime.now().copyWith(hour: 0, minute: 0),
            endDate: DateTime.now().copyWith(hour: 23, minute: 59),
            isIncome: widget.isIncome,
          );
          final transactions = state.transactions;
          final totalSum = transactions.fold<num>(
            0,
            (sum, item) => sum + double.parse(item.amount),
          );
          return Column(
            children: [
              Container(
                color: CustomAppTheme.figmaMainLightColor,
                height: 56,
                child: Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text("Всего", textAlign: TextAlign.start),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          "${NumberFormat("0.00").format(totalSum)} ₽",
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: () {
                  if (state.status == TransactionStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == TransactionStatus.error) {
                    return Center(child: Text('Ошибка: ${state.error}'));
                  }
                  if (transactions.isEmpty) {
                    return const Center(child: Text('Нет данных за период'));
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
      ),
    );
  }
}
