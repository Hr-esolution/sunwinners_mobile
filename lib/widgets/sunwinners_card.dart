import 'package:flutter/material.dart';

class SunwinnersCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final BoxShadow? shadow;

  const SunwinnersCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFE8EEF7),
    this.borderRadius = 12,
    this.onTap,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          if (shadow != null) shadow!,
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: const Color(0xFF2ECC71).withValues(alpha: 0.1),
        highlightColor: const Color(0xFF2ECC71).withValues(alpha: 0.05),
        child: card,
      );
    }

    return card;
  }
}
