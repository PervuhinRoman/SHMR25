import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/models/transaction/transaction.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/data/repositories/transaction_repo_imp.dart';
import 'package:shmr_finance/data/repositories/account_repo_imp.dart';
import 'package:shmr_finance/data/repositories/category_repo_imp.dart';
import 'package:shmr_finance/presentation/widgets/item_inexp.dart';

import '../domain/bloc/transaction_bloc.dart';

class InExpWidgetPage extends StatefulWidget {
  final bool isIncome;

  const InExpWidgetPage({super.key, required this.isIncome});

  @override
  State<InExpWidgetPage> createState() => _InExpWidgetPageState();
}

class _InExpWidgetPageState extends State<InExpWidgetPage> {
  Future<List<TransactionResponse>> _fetchAndPrintTransactions(
    bool isIncome,
  ) async {
    final responses = <TransactionResponse>[];

    final AccountRepoImp accountRepo = AccountRepoImp();
    final CategoryRepoImpl categoryRepo = CategoryRepoImpl();
    final TransactionRepoImp transactionRepo = TransactionRepoImp(
      accountRepo,
      categoryRepo,
    );

    final List<TransactionResponse> rawResponses = await transactionRepo
        .getPeriodTransactionsByAccount(
          1,
          startDate: DateTime(2025, DateTime.june, 20),
          endDate: DateTime(2025, DateTime.june, 21),
        );

    for (final response in rawResponses) {
      if (response.category.isIncome && isIncome ||
          !response.category.isIncome && !isIncome) {
        // Если ДОХОД и ДОХОД или НЕДОХОД и НЕДОХОД
        responses.add(response);
        // print(response.toJson());
      }
    }

    return responses;
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
            final responses = state.transactions;
            final total = responses.fold<num>(0, (sum, item) => sum + double.parse(item.amount) ?? 0);
            return Column(
              children: [
                // "Всего"
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
                            "$total ₽",
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Список с Divider
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
