import 'package:flutter/material.dart';

class InExpItem extends StatelessWidget {
  final String category_title;
  final String amount;
  final String icon;
  final String? comment;
  const InExpItem({
    super.key,
    required this.category_title,
    required this.amount,
    required this.icon,
    this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(icon),
      title: Row(
        children: [
          Expanded(
            child: Text(category_title, textAlign: TextAlign.start),
          ),
          Expanded(
            child: Text(amount, textAlign: TextAlign.end),
          ),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
    );
  }
}
