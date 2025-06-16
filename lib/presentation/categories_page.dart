import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Мои статьи"),
        centerTitle: true,
        toolbarHeight: 116,
      ),
      body: Center(
        child: Text("Статьи"),
      ),
    );
  }
}
