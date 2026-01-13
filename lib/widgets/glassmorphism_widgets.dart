import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlassmorphismContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final double blurSigma;
  final Color borderColor;
  final Color backgroundColor;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;

  const GlassmorphismContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.blurSigma = 10,
    this.borderColor = const Color(0xFFFFFFFF),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.shadows,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient:
                gradient ??
                LinearGradient(
                  colors: [
                    backgroundColor.withValues(alpha: 0.1),
                    backgroundColor.withValues(alpha: 0.05),
                  ],
                ),
            borderRadius: borderRadius,
            border: Border.all(
              color: borderColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: shadows,
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassmorphismButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isPrimary;
  final bool isLogout;
  final bool isSecondary;

  const GlassmorphismButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isPrimary = false,
    this.isLogout = false,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    Gradient getButtonGradient() {
      if (isPrimary) {
        return LinearGradient(
          colors: [
            const Color(0xFFFFA500).withValues(alpha: 0.6),
            const Color(0xFFFFD700).withValues(alpha: 0.4),
          ],
        );
      } else if (isLogout) {
        return LinearGradient(
          colors: [
            const Color(0xFFFF6B6B).withValues(alpha: 0.3),
            const Color(0xFFFF6B6B).withValues(alpha: 0.2),
          ],
        );
      } else if (isSecondary) {
        return LinearGradient(
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.1),
            const Color(0xFFFFFFFF).withValues(alpha: 0.05),
          ],
        );
      } else {
        return LinearGradient(
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.1),
            const Color(0xFFFFFFFF).withValues(alpha: 0.05),
          ],
        );
      }
    }

    Color getTextColor() {
      if (isLogout) {
        return const Color(0xFFFF6B6B);
      } else {
        return Colors.white;
      }
    }

    Color getBorderColor() {
      if (isLogout) {
        return const Color(0xFFFF6B6B);
      } else {
        return const Color(0xFFFFFFFF);
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: getButtonGradient(),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: getBorderColor().withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: getTextColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassmorphismTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final TextInputType keyboardType;
  final String? hintText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPasswordField;
  final bool obscureText;
  final Widget? suffixIcon;

  const GlassmorphismTextField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.validator,
    this.inputFormatters,
    this.isPasswordField = false,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphismContainer(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(
                255,
                255,
                255,
                255,
              ).withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            obscureText: isPasswordField ? obscureText : false,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: hintText ?? 'Entrez $label',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              filled: false,
              suffixIcon: suffixIcon,
            ),
            validator: validator,
            inputFormatters: inputFormatters,
          ),
        ],
      ),
    );
  }
}

class GlassmorphismCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;

  const GlassmorphismCard({
    super.key,
    required this.label,
    required this.value,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphismContainer(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

extension ColorExtension on Color {
  Color withValues({double alpha = 1.0}) {
    return Color.fromRGBO(red, green, blue, alpha);
  }
}
