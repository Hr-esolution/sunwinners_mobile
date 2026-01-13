import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/views/auth/splash_view.dart';
import 'core/di/dependency_injection.dart';
import 'core/constants/app_routes.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  runApp(const SunwinnersApp());
}

class SunwinnersApp extends StatelessWidget {
  const SunwinnersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sunwinners',
      initialBinding: null, // Dependencies are initialized globally
      getPages: AppRoutes.routes,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Use system theme by default
      home: const SplashView(),
    );
  }
}
