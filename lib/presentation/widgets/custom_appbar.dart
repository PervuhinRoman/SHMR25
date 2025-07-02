import 'package:flutter/material.dart';

import 'package:shmr_finance/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final double height;
  final double? uiHeight;
  final Color bgColor;
  final bool defaultLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.height = 116,
    this.uiHeight = 24,
    this.bgColor = CustomAppTheme.figmaMainColor,
    this.defaultLeading = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(116 - (uiHeight ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      toolbarHeight: height - (uiHeight ?? 0),
      actions: actions,
      backgroundColor: bgColor,
      automaticallyImplyLeading: defaultLeading,
      leading: leading,
    );
  }
}
