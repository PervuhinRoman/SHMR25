import 'package:flutter/material.dart';

import '../../app_theme.dart';

class ItemAnalyzeCategory extends StatelessWidget {
  final String categoryTitle;
  final String icon;
  final String? lastTransaction;
  final String percent;
  final String totalSum;
  const ItemAnalyzeCategory({
    super.key,
    required this.categoryTitle,
    required this.icon,
    this.lastTransaction,
    required this.percent,
    required this.totalSum,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(icon),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lastTransaction ?? "",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: CustomAppTheme.figmaDarkGrayColor,
            ),
          ),
          Text("${totalSum} ₽"), // TODO: добавить форматирование
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(categoryTitle, textAlign: TextAlign.start),
          Text("$percent%"),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: CustomAppTheme.figmaBgGrayColor,),
    );
  }
}
