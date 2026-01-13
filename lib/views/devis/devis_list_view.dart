import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/controllers/auth_controller.dart';
import 'package:sunwinners/controllers/devis_controller.dart';
import 'package:sunwinners/core/constants/app_routes.dart';
import 'package:sunwinners/core/constants/app_roles.dart';
import '../../widgets/sunwinners_app_bar.dart';

class DevisListView extends StatefulWidget {
  const DevisListView({super.key});

  @override
  State<DevisListView> createState() => _DevisListViewState();
}

class _DevisListViewState extends State<DevisListView> {
  late final DevisController controller;
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    controller = Get.find<DevisController>();
    // Redirect to role-specific view based on user role
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirectToRoleSpecificView();
    });
  }

  void _redirectToRoleSpecificView() {
    final userRole = authController.userRole;

    switch (userRole) {
      case AppRoles.client:
        Get.offAndToNamed(AppRoutes.clientDevisList);
        break;
      case AppRoles.technician:
        Get.offAndToNamed(AppRoutes.technicianDevisList);
        break;
      case AppRoles.owner:
      case AppRoles.admin:
        Get.offAndToNamed(AppRoutes.ownerDevisList);
        break;
      default:
        // If role is unknown, redirect to client view as fallback
        Get.offAndToNamed(AppRoutes.clientDevisList);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This widget will redirect immediately, so we just show a loading indicator
    return Scaffold(
      appBar: SunwinnersAppBar(
        title: 'Redirection...',
        backgroundColor: const Color(0xFF2ECC71),
        foregroundColor: Colors.white,
        elevation: 0,
        iconColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2ECC71)),
            ),
            SizedBox(height: 16),
            Text(
              'Chargement de votre espace devis...',
              style: TextStyle(fontSize: 16, color: Color(0xFF7F8C8D)),
            ),
          ],
        ),
      ),
    );
  }
}
