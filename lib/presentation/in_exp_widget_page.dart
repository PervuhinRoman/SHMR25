import 'package:flutter/material.dart';
import 'package:shmr_finance/app_theme.dart';
import 'package:shmr_finance/domain/models/transaction/transaction.dart';
import 'package:shmr_finance/presentation/widgets/custom_appbar.dart';
import 'package:shmr_finance/data/repositories/transaction_repo_imp.dart';
import 'package:shmr_finance/data/repositories/account_repo_imp.dart';
import 'package:shmr_finance/data/repositories/category_repo_imp.dart';
import 'package:shmr_finance/presentation/widgets/item_inexp.dart';

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
      body: Column(
        children: [
          Container(
            color: CustomAppTheme.figmaMainLightColor,
            height: 56,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text("Всего", textAlign: TextAlign.start),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text("400 000 ₽", textAlign: TextAlign.end),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TransactionResponse>>(
              future: _fetchAndPrintTransactions(widget.isIncome),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Нет данных'));
                }
                final responses = snapshot.data!;
                return ListView.builder(
                  itemCount:
                      responses.length * 2 +
                      1, // Для добавления Divider до, после и между item
                  itemBuilder: (context, index) {
                    if (index.isEven) {
                      return const Divider(
                        height: 1,
                        thickness: 1,
                        color: CustomAppTheme.figmaBgGrayColor,
                      );
                    } else {
                      final itemIndex =
                          index ~/ 2; // Т.к. теперь index учитывает и Divder()
                      return InExpItem(
                        category_title: responses[itemIndex].category.name,
                        amount: responses[itemIndex].amount,
                        icon: responses[itemIndex].category.emoji,
                        comment: responses[itemIndex].comment,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
