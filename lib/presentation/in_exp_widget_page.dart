import 'package:flutter/material.dart';
import 'package:shmr_finance/app_theme.dart';

import 'history_page.dart';

class InExpWidgetPage extends StatelessWidget {
  const InExpWidgetPage({super.key});

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
            child: ListView(
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: CustomAppTheme.figmaBgGrayColor,
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text("Продукты", textAlign: TextAlign.start),
                      ),
                      Expanded(
                        child: Text("100 000 ₽", textAlign: TextAlign.end),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: CustomAppTheme.figmaBgGrayColor,
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text("Продукты", textAlign: TextAlign.start),
                      ),
                      Expanded(
                        child: Text("100 000 ₽", textAlign: TextAlign.end),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: CustomAppTheme.figmaBgGrayColor,
                ),
              ],
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
