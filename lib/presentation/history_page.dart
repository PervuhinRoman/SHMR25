// Экран-заглушка
// TODO: экран должен быть встроен в общую навигацию либо контент должен меняться на той де странице расходов

import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Моя история"),
        centerTitle: true,
        toolbarHeight: 116,
      ),
      body: const Center(
        child: Text('История', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
