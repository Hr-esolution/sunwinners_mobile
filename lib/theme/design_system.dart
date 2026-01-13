import 'package:flutter/material.dart';

/// Design System Constants for Sunwinners Énergie Solaire Mobile
/// Implements the compact mobile-first design system with the specified color palette and components
class DesignSystem {
  // Singleton pattern to ensure consistent values across the app
  static final DesignSystem _instance = DesignSystem._internal();
  factory DesignSystem() => _instance;
  DesignSystem._internal();

  /// Color Palette
  static const Color gold = Color(0xFFF59E0B);           // #F59E0B (primaire)
  static const Color orange = Color(0xFFFF9500);         // #FF9500 (accents)
  static const Color yellow = Color(0xFFFCD34D);         // #FCD34D (highlights)
  static const Color green = Color(0xFF10B981);          // #10B981 (secondaire/eco)
  static const Color lightGreen = Color(0xFFD1FAE5);     // #D1FAE5 (backgrounds)
  static const Color white = Color(0xFFFFFFFF);          // #FFFFFF (surfaces)
  static const Color darkGray = Color(0xFF1F2937);       // #1F2937 (texte)
  static const Color mediumGray = Color(0xFF6B7280);     // #6B7280 (secondaire)
  static const Color lightGray = Color(0xFF9CA3AF);      // #9CA3AF (muted)
  static const Color navyBlue = Color(0xFF0F172A);       // #0F172A (dark bg)
  static const Color red = Color(0xFFDC2626);            // For errors

  /// Typography Styles
  static const TextStyle h1 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: darkGray,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: darkGray,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: darkGray,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: darkGray,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    height: 1.3,
    color: mediumGray,
  );

  /// Spacing System
  static const double xs = 4.0;    // XS : 4px
  static const double s = 6.0;     // S : 6px
  static const double m = 8.0;     // M : 8px
  static const double l = 12.0;    // L : 12px
  static const double xl = 16.0;   // XL : 16px
  
  // Common gaps
  static const double sectionGap = 12.0;  // Gap entre sections : 12px
  static const double itemGap = 8.0;      // Gap entre items : 8px
  static const double screenPadding = 12.0; // Padding écran : 12px

  /// Border Radius System
  static const double borderRadiusXs = 3.0;    // XS : 3px
  static const double borderRadiusS = 5.0;     // S : 5px
  static const double borderRadiusM = 8.0;     // M : 8px
  static const double borderRadiusL = 10.0;    // L : 10px
  static const double borderRadiusXl = 12.0;   // XL : 12px
  static const double borderRadiusFull = 100.0; // Full : 100%

  /// Animation Durations
  static const Duration standardTransition = Duration(milliseconds: 150);
  static const Duration expandableTransition = Duration(milliseconds: 150);
  static const Duration pageTransition = Duration(milliseconds: 250);
  static const Duration loaderDuration = Duration(seconds: 1, milliseconds: 200);

  /// Component Dimensions
  static const Size buttonSize = Size(double.infinity, 44); // Button height: 44px
  static const Size iconButtonSize = Size.square(40);       // Icon button: 40x40px
  static const Size inputFieldSize = Size(double.infinity, 40); // Input height: 40px
  static const Size avatarSmall = Size.square(32);          // Small avatar: 32px
  static const Size avatarMedium = Size.square(40);         // Medium avatar: 40px
  static const Size avatarLarge = Size.square(48);          // Large avatar: 48px

  /// Shadow Elevation
  static const List<BoxShadow> lightShadow = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity black
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity black
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];

  /// Gradient Definitions
  static const LinearGradient goldToOrangeGradient = LinearGradient(
    colors: [gold, orange],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Theme Mode Support
  ThemeData createLightTheme() {
    return ThemeData(
      primarySwatch: _createMaterialColor(gold),
      primaryColor: gold,
      colorScheme: const ColorScheme.light(
        primary: gold,
        secondary: green,
        surface: white,
        background: lightGreen,
        error: red,
        onPrimary: white,
        onSecondary: white,
        onSurface: darkGray,
        onBackground: darkGray,
        onError: white,
      ),
      useMaterial3: true,
    );
  }

  ThemeData createDarkTheme() {
    return ThemeData(
      primarySwatch: _createMaterialColor(gold),
      primaryColor: gold,
      colorScheme: ColorScheme.dark(
        primary: gold,
        secondary: green,
        surface: navyBlue,
        background: navyBlue,
        error: red,
        onPrimary: white,
        onSecondary: white,
        onSurface: white,
        onBackground: white,
        onError: white,
      ),
      useMaterial3: true,
    );
  }

  // Helper method to create MaterialColor from Color
  MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}