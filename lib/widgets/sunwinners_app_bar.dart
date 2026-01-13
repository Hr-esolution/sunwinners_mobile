import 'package:flutter/material.dart';

class SunwinnersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onLeadingPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final Color? iconColor;

  const SunwinnersAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.onLeadingPressed,
    this.backgroundColor = const Color(0xFF2ECC71),
    this.foregroundColor = Colors.white,
    this.elevation = 0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      iconTheme: IconThemeData(color: iconColor),
      actions: actions,
      leading: leading != null
          ? IconButton(icon: leading!, onPressed: onLeadingPressed)
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
