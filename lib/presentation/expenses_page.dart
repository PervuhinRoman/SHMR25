import 'package:flutter/material.dart';
import 'package:shmr_finance/presentation/history_page.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Расходы сегодня"),
        centerTitle: true,
        toolbarHeight: 116,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return HistoryPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Center(child: Text("Расходы")),
    );
  }
}
