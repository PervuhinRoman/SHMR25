import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Настройки"),
        centerTitle: true,
        toolbarHeight: 116,
      ),
      body: Center(
        child: Text("Настройки"),
      ),
    );
  }
}
