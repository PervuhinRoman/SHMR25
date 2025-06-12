import 'package:flutter/material.dart';

import 'history_page.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Доходы сегодня"),
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
      body: Center(
        child: Text("Доходы"),
      ),
    );
  }
}
