import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final double height;


  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.height = 116,
  });

  @override
  Size get preferredSize => const Size.fromHeight(116);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      toolbarHeight: height,
      actions: actions,
    );
  }
}
