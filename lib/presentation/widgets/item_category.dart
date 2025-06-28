import 'package:flutter/material.dart';

class ItemCategory extends StatelessWidget {
  final String categoryTitle;
  final String icon;
  const ItemCategory({
    super.key,
    required this.categoryTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(icon),
      title: Text(categoryTitle, textAlign: TextAlign.start),
    );
  }
}
