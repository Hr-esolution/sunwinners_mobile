import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color gold = Color(0xFFF59E0B); // #F59E0B (primaire)
  static const Color orange = Color(0xFFFF9500); // #FF9500 (accents)
  static const Color yellow = Color(0xFFFCD34D); // #FCD34D (highlights)

  // Secondary/Eco colors
  static const Color green = Color(0xFF10B981); // #10B981 (secondaire/eco)
  static const Color lightGreen = Color(0xFFD1FAE5); // #D1FAE5 (backgrounds)

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF); // #FFFFFF (surfaces)
  static const Color darkGray = Color(0xFF1F2937); // #1F2937 (texte)
  static const Color mediumGray = Color(0xFF6B7280); // #6B7280 (secondaire)
  static const Color lightGray = Color(0xFF9CA3AF); // #9CA3AF (muted)
  static const Color navyBlue = Color(0xFF0F172A); // #0F172A (dark bg)

  // Status colors
  static const Color red = Color(0xFFDC2626); // For errors
}

class AppTypography {
  // H1: 28px Bold, lh:1.2
  static const TextStyle h1 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.darkGray,
  );

  // H2: 20px SemiBold, lh:1.3
  static const TextStyle h2 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.darkGray,
  );

  // H3: 16px SemiBold, lh:1.3
  static const TextStyle h3 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.darkGray,
  );

  // Body: 14px Regular, lh:1.4
  static const TextStyle body = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.darkGray,
  );

  // Caption: 12px Regular, lh:1.3
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    height: 1.3,
    color: AppColors.mediumGray,
  );
}

class AppSpacing {
  // Espacements Compact Mobile
  static const double xs = 4.0; // XS : 4px
  static const double s = 6.0; // S : 6px
  static const double m = 8.0; // M : 8px
  static const double l = 12.0; // L : 12px
  static const double xl = 16.0; // XL : 16px

  // Common gaps
  static const double sectionGap = 12.0; // Gap entre sections : 12px
  static const double itemGap = 8.0; // Gap entre items : 8px
  static const double screenPadding = 12.0; // Padding écran : 12px
}

class AppBorderRadius {
  static const double xs = 3.0; // XS : 3px
  static const double s = 5.0; // S : 5px
  static const double m = 8.0; // M : 8px
  static const double l = 10.0; // L : 10px
  static const double xl = 12.0; // XL : 12px
  static const double full = 100.0; // Full : 100%
}

class AppAnimations {
  static const Duration standard = Duration(milliseconds: 150);
  static const Duration expandable = Duration(milliseconds: 150);
  static const Duration pageTransition = Duration(milliseconds: 250);
  static const Duration loader = Duration(seconds: 1, milliseconds: 200);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    // Primary colors
    primarySwatch: _createMaterialColor(AppColors.gold),
    primaryColor: AppColors.gold,

    // Color scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.gold,
      secondary: AppColors.green,
      surface: AppColors.white,
      error: AppColors.red,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.darkGray,
      onError: AppColors.white,
    ).copyWith(brightness: Brightness.light),

    // Typography
    textTheme: _buildTextTheme(),

    // Button themes
    elevatedButtonTheme: _buildElevatedButtonTheme(),
    outlinedButtonTheme: _buildOutlinedButtonTheme(),
    textButtonTheme: _buildTextButtonTheme(),

    // Input decoration theme
    inputDecorationTheme: _buildInputDecorationTheme(),

    // Card theme
    cardTheme: _buildCardTheme(),

    // Divider theme
    dividerTheme: _buildDividerTheme(),

    // Chip theme
    chipTheme: _buildChipTheme(),

    // Bottom sheet theme
    bottomSheetTheme: _buildBottomSheetTheme(),

    // Dialog theme
    dialogTheme: _buildDialogTheme(),

    // SnackBar theme
    snackBarTheme: _buildSnackBarTheme(),

    // Use Material 3
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    // Primary colors
    primarySwatch: _createMaterialColor(AppColors.gold),
    primaryColor: AppColors.gold,

    // Color scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.gold,
      secondary: AppColors.green,
      surface: AppColors.navyBlue,
      error: AppColors.red,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.white,
      onError: AppColors.white,
    ).copyWith(brightness: Brightness.dark),

    // Typography
    textTheme: _buildTextTheme(isDark: true),

    // Button themes
    elevatedButtonTheme: _buildElevatedButtonTheme(isDark: true),
    outlinedButtonTheme: _buildOutlinedButtonTheme(isDark: true),
    textButtonTheme: _buildTextButtonTheme(isDark: true),

    // Input decoration theme
    inputDecorationTheme: _buildInputDecorationTheme(isDark: true),

    // Card theme
    cardTheme: _buildCardTheme(isDark: true),

    // Divider theme
    dividerTheme: _buildDividerTheme(isDark: true),

    // Chip theme
    chipTheme: _buildChipTheme(isDark: true),

    // Bottom sheet theme
    bottomSheetTheme: _buildBottomSheetTheme(isDark: true),

    // Dialog theme
    dialogTheme: _buildDialogTheme(isDark: true),

    // SnackBar theme
    snackBarTheme: _buildSnackBarTheme(isDark: true),

    // Use Material 3
    useMaterial3: true,
  );

  // Helper methods to build theme components
  static TextTheme _buildTextTheme({bool isDark = false}) {
    final textColor = isDark ? AppColors.white : AppColors.darkGray;
    return TextTheme(
      headlineLarge: AppTypography.h1.copyWith(color: textColor),
      headlineMedium: AppTypography.h2.copyWith(color: textColor),
      headlineSmall: AppTypography.h3.copyWith(color: textColor),
      bodyLarge: AppTypography.body.copyWith(color: textColor),
      bodyMedium: AppTypography.caption.copyWith(
        color: isDark ? AppColors.lightGray : AppColors.mediumGray,
      ),
      bodySmall: AppTypography.caption.copyWith(
        color: isDark ? AppColors.lightGray : AppColors.mediumGray,
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    bool isDark = false,
  }) {
    return ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.l),
            ),
            side: BorderSide.none,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            textStyle: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.orange.withValues(alpha: 0.2);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.orange.withValues(alpha: 0.1);
              }
              return null;
            }),
          ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme({
    bool isDark = false,
  }) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.gold,
        minimumSize: const Size(double.infinity, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.l),
          side: BorderSide(width: 1.5, color: AppColors.gold),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        textStyle: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme({bool isDark = false}) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.gold,
        textStyle: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme({
    bool isDark = false,
  }) {
    final bgColor = isDark ? AppColors.navyBlue : AppColors.white;
    final borderColor = isDark ? AppColors.lightGray : AppColors.lightGray;
    final focusBorderColor = AppColors.gold;

    return InputDecorationTheme(
      filled: true,
      fillColor: bgColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.m),
        borderSide: BorderSide(width: 1, color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.m),
        borderSide: BorderSide(width: 1, color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.m),
        borderSide: BorderSide(width: 2, color: focusBorderColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
    );
  }

  static CardThemeData _buildCardTheme({bool isDark = false}) {
    final bgColor = isDark ? AppColors.darkGray : AppColors.white;
    final borderColor = isDark ? AppColors.mediumGray : AppColors.lightGray;

    return CardThemeData(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        side: BorderSide(width: 0.5, color: borderColor),
      ),
      elevation: 2,
      margin: const EdgeInsets.all(AppSpacing.m),
    );
  }

  static DividerThemeData _buildDividerTheme({bool isDark = false}) {
    final color = isDark ? AppColors.mediumGray : AppColors.lightGray;

    return DividerThemeData(color: color, thickness: 0.5, space: 8);
  }

  static ChipThemeData _buildChipTheme({bool isDark = false}) {
    final bgColor = isDark ? AppColors.navyBlue : AppColors.white;
    final borderColor = isDark ? AppColors.mediumGray : AppColors.lightGray;
    final selectedBgColor = AppColors.gold;
    final selectedTextColor = AppColors.white;

    return ChipThemeData(
      backgroundColor: bgColor,
      selectedColor: selectedBgColor,
      disabledColor: bgColor,
      labelStyle: AppTypography.caption,
      secondaryLabelStyle: AppTypography.caption.copyWith(
        color: selectedTextColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: StadiumBorder(side: BorderSide(width: 1, color: borderColor)),
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme({bool isDark = false}) {
    final bgColor = isDark ? AppColors.darkGray : AppColors.white;

    return BottomSheetThemeData(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    );
  }

  static DialogThemeData _buildDialogTheme({bool isDark = false}) {
    final bgColor = isDark ? AppColors.darkGray : AppColors.white;

    return DialogThemeData(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
      ),
      titleTextStyle: AppTypography.h3.copyWith(
        color: isDark ? AppColors.white : AppColors.darkGray,
      ),
      contentTextStyle: AppTypography.body.copyWith(
        color: isDark ? AppColors.white : AppColors.darkGray,
      ),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme({bool isDark = false}) {
    final bgColor = isDark
        ? AppColors.darkGray.withValues(alpha: 0.95)
        : AppColors.darkGray.withValues(alpha: 0.95);

    return SnackBarThemeData(
      backgroundColor: bgColor,
      contentTextStyle: AppTypography.body.copyWith(
        color: AppColors.white,
        fontSize: 13,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      elevation: 6,
    );
  }

  // Helper method to create MaterialColor from Color
  static MaterialColor _createMaterialColor(Color color) {
    List<double> strengths = <double>[0.05];
    Map<int, Color> swatch = {};

    final int r = (color.r * 255.0).round() & 0xff;
    final int g = (color.g * 255.0).round() & 0xff;
    final int b = (color.b * 255.0).round() & 0xff;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    // Pour le MaterialColor, tu peux utiliser color.toARGB32 pour éviter les dépréciations
    return MaterialColor(color.toARGB32(), swatch);
  }
}
