import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Мой счёт"),
        centerTitle: true,
        toolbarHeight: 116,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.mode_edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Счёт"),
      ),
    );
  }
}

