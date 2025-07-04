import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shmr_finance/app_theme.dart';

class InExpItem extends StatelessWidget {
  final String categoryTitle;
  final String amount;
  final String icon;
  final DateTime time;
  final String? comment;
  final VoidCallback? onTap;
  
  const InExpItem({
    super.key,
    required this.categoryTitle,
    required this.amount,
    required this.icon,
    required this.time,
    this.comment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(icon),
      title: Row(
        children: [
          Expanded(child: Text(categoryTitle, textAlign: TextAlign.start)),
          Expanded(
            child: Text(
              NumberFormat('#,##0.00', 'ru_RU').format(double.tryParse(amount)),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(child: Text(comment ?? "", textAlign: TextAlign.start)),
          Expanded(
            child: Text(
              DateFormat("dd.MM hh:mm").format(time),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: CustomAppTheme.figmaDarkGrayColor,
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}
