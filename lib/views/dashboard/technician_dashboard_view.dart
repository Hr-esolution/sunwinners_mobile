// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/core/constants/app_routes.dart';
import 'package:sunwinners/widgets/main_drawer.dart';
import 'package:sunwinners/widgets/sunwinners_app_bar.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/composant_controller.dart';
import '../../controllers/devis_controller.dart';

class TechnicianDashboardView extends StatelessWidget {
  const TechnicianDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ComposantController composantController =
        Get.find<ComposantController>();
    final DevisController devisController = Get.find<DevisController>();

    // Load assigned devis when the dashboard is built
    if (devisController.devisList.isEmpty) {
      Future.microtask(() => devisController.loadAssignedDevis());
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Tableau de bord Technicien', // 🔸 Correction du titre
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        iconColor: const Color(0xFFffd60a),
        actions: [
          IconButton(
            icon: Icon(Icons.person_rounded, color: const Color(0xFFffd60a)),
            onPressed: () {
              Get.toNamed(AppRoutes.profile);
            },
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1a1f2e),
              const Color(0xFF0f1419),
              const Color(0xFF051628),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Text(
                'Bonjour, ${authController.currentUser?.name ?? 'Technicien'}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Voici vos tâches du jour',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.5),
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 20),

              // Statistiques Rapides
              Text(
                'Statistiques Rapides',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),

              // Stats cards
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => _buildStatCard(
                        icon: Icons.assignment_outlined,
                        count: devisController.devisList.length,
                        label: 'Devis Assignés',
                        color: const Color(0xFFffd60a),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(
                      () => _buildStatCard(
                        icon: Icons.inventory_outlined,
                        count: composantController.composantList.length,
                        label: 'Composants',
                        color: const Color(0xFF00d4ff),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Obx(
                () => _buildStatCard(
                  icon: Icons.message_outlined,
                  count: devisController.devisList.length ~/ 3 + 1,
                  label: 'Réponses Envoyées',
                  color: const Color(0xFF00ff88),
                  isFullWidth: true,
                ),
              ),

              const SizedBox(height: 32),

              // Mes Tâches
              Text(
                'Mes Tâches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 16),

              // Task cards
              _buildTaskCard(
                onTap: () {
                  Get.toNamed('/technician/devis');
                },
                icon: Icons.assignment_outlined,
                title: 'Devis Assignés',
                subtitle:
                    '${devisController.devisList.length} devis en attente',
                color: const Color(0xFFffd60a),
              ),

              const SizedBox(height: 12),

              _buildTaskCard(
                onTap: () {
                  Get.toNamed(AppRoutes.technicianMyResponses);
                },
                icon: Icons.message_outlined,
                title: 'Mes Réponses',
                subtitle:
                    '${devisController.devisList.length ~/ 3 + 1} réponses envoyées',
                color: const Color(0xFF00ff88),
              ),

              const SizedBox(height: 12),

              _buildTaskCard(
                onTap: () {
                  Get.toNamed('/composant');
                },
                icon: Icons.inventory_outlined,
                title: 'Composants',
                subtitle:
                    '${composantController.composantList.length} composants',
                color: const Color(0xFF00d4ff),
              ),

              const SizedBox(height: 32),

              // Activité récente
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Activité récente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.technicianMyResponses);
                    },
                    child: Text(
                      'Voir tout',
                      style: const TextStyle(
                        color: Color(0xFFffd60a),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 2),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
