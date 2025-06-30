import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/presentation/widgets/item_inexp.dart';

import '../app_theme.dart';
import '../domain/cubit/datepicker_cubit.dart';
import '../domain/cubit/transaction_cubit.dart';
import '../domain/models/category/category.dart';

class SelectedCategoryPage extends StatefulWidget {
  final Category selectedCategory;
  final bool isIncome;
  const SelectedCategoryPage({
    super.key,
    required this.isIncome,
    required this.selectedCategory,
  });

  @override
  State<SelectedCategoryPage> createState() => _SelectedCategoryPageState();
}

class _SelectedCategoryPageState extends State<SelectedCategoryPage> {
  @override
  void initState() {
    super.initState();
    print(
      '🚀 SelectedCategoryPage initState вызван для ${widget.isIncome ? "доходов" : "расходов"}',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔄 SelectedCategoryPage: вызываю fetchTransactions');
      final transactionCubit = context.read<TransactionCubit>();
      final datePickerCubit = context.read<DatePickerCubit>();

      transactionCubit.fetchTransactions(
        startDate: datePickerCubit.state.startDate,
        endDate: datePickerCubit.state.endDate,
        isIncome: widget.isIncome,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:
            "Категория: ${widget.selectedCategory.emoji} ${widget.selectedCategory.name}",
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, transactionState) {
          final transactions =
              transactionState.transactions
                  .where((t) => t.category.id == widget.selectedCategory.id)
                  .toList();

          print(transactions);
          return Column(
            children: [
              Expanded(
                child: () {
                  if (transactionState.status == TransactionStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (transactionState.status == TransactionStatus.error) {
                    return Center(
                      child: Text('Ошибка: ${transactionState.error}'),
                    );
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
