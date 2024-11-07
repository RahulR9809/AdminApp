import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onLeadingPressed;
  final Color backgroundColor;
final Icon icons;
  const CustomAppBar({
    super.key,
    required this.title,
    required this.onLeadingPressed,
    required this.backgroundColor, 
    required this.icons
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onLeadingPressed,
        icon: icons
      ),
      title: Text(title),
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
