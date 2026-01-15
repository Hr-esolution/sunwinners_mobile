import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../core/constants/app_routes.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/sunwinners_app_bar.dart';
import '../../widgets/main_drawer.dart';

class OwnerDashboardView extends StatelessWidget {
  const OwnerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final UserController userController = Get.find<UserController>();
    final isMobile = MediaQuery.of(context).size.width < 600;

    // Load technicians if not already loaded
    if (userController.technicians.isEmpty) {
      userController.loadAllTechnicians();
    }

    // Get pending technicians (those not approved) and update in reactive way
    userController.technicians.where((tech) => !tech.approved).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Tableau de bord Propriétaire',
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1f2e), Color(0xFF0f1419), Color(0xFF051628)],
          ),
        ),
        child: Obx(
          () => // Use Obx to rebuild when technicians list changes
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✨ Welcome section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF00ff88), Color(0xFF00cc66)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF00ff88,
                              ).withValues(alpha: 0.3),
                              blurRadius: 16,
                              spreadRadius: 0,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bienvenue,',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: const Color(
                                            0xFF0f1419,
                                          ).withValues(alpha: 0.9),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${authController.currentUser?.name ?? 'Propriétaire'}!',
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF0f1419),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF0f1419,
                                    ).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.wb_sunny_rounded,
                                    color: Color(0xFF0f1419),
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Gérez votre entreprise d\'installation solaire',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(
                                  0xFF0f1419,
                                ).withValues(alpha: 0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // 🎯 Quick actions section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Actions rapides',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFffd60a).withValues(alpha: 0.2),
                                Color(0xFFffc300).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(
                                0xFFffd60a,
                              ).withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            '4 actions',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFffd60a),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Grid des actions
                  GridView.count(
                    crossAxisCount: isMobile
                        ? 2
                        : 3, // Changed from 4 to 3 to accommodate 5 items better
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isMobile ? 1.0 : 0.95,
                    children: [
                      _buildActionGridItem(
                        icon: Icons.list_alt_rounded,
                        title: 'Tous les Devis',
                        subtitle: 'Examiner les demandes',
                        color: const Color(0xFF00d4ff), // Cyan
                        onTap: () => Get.toNamed(AppRoutes.ownerDevisList),
                      ),
                      _buildActionGridItem(
                        icon: Icons.work_rounded,
                        title: 'Tous les Projets',
                        subtitle: 'Projets en cours',
                        color: const Color(
                          0xFF9B59B6,
                        ), // Violet (gardé car spécifique)
                        onTap: () => Get.toNamed(AppRoutes.projectList),
                      ),
                      _buildActionGridItem(
                        icon: Icons.engineering_rounded,
                        title: 'Gérer les Techniciens',
                        subtitle: 'Approuver/refuser',
                        color: const Color(0xFF4ECDC4), // Turquoise
                        onTap: () => Get.toNamed(AppRoutes.technicianApproval),
                      ),
                      _buildActionGridItem(
                        icon: Icons.people_rounded,
                        title: 'Gérer les Utilisateurs',
                        subtitle: 'Gestion d\'équipe',
                        color: const Color(0xFFff6b6b), // Rouge erreur
                        onTap: () => Get.toNamed(AppRoutes.userManagement),
                      ),
                      _buildActionGridItem(
                        icon: Icons.money_rounded,
                        title: 'Gérer les Subventions',
                        subtitle: 'Suivi des aides',
                        color: const Color(0xFF2ECC71), // Green
                        onTap: () => Get.toNamed(AppRoutes.subventionList),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // 🛠️ Technician approval section - always show with count
                  Column(
                    children: [
                      TechnicianApprovalCard(
                        pendingTechnicians: userController.technicians
                            .where((tech) => !tech.approved)
                            .toList(),
                        userController: userController,
                        onRefresh: () {
                          userController.loadAllTechnicians();
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),

                  // 💰 Subvention statistics section
                  Column(
                    children: [
                      SubventionStatsCard(),
                      const SizedBox(height: 24),
                    ],
                  ),

                  // 📊 Recent activity section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Activité récente',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 255, 255, 0.08),
                              Color.fromRGBO(255, 255, 255, 0.03),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(
                              0xFFffd60a,
                            ).withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              height: 28,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00ff88),
                                    Color(0xFF00cc66),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Aucune activité récente',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Vos activités récentes apparaîtront ici',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionGridItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 0.08),
                Color.fromRGBO(255, 255, 255, 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFffd60a).withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Subvention Statistics Card Widget
class SubventionStatsCard extends StatelessWidget {
  const SubventionStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, we'll create a static card since we don't have the controller in scope
    // In a real implementation, you would pass the controller as a parameter
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 0.08),
                Color.fromRGBO(255, 255, 255, 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFffd60a).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF2ECC71).withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.money_rounded,
                      color: Color(0xFF2ECC71),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subventions',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Suivi des subventions',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2ECC71).withValues(alpha: 0.25),
                          const Color(0xFF2ECC71).withValues(alpha: 0.12),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF2ECC71).withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: const Text(
                      'Voir',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2ECC71),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.pending_actions_rounded,
                    label: 'En attente',
                    value: '0',
                    color: const Color(0xFFFF9800),
                  ),
                  _buildStatItem(
                    icon: Icons.check_circle_rounded,
                    label: 'Confirmées',
                    value: '0',
                    color: const Color(0xFF4CAF50),
                  ),
                  _buildStatItem(
                    icon: Icons.attach_money_rounded,
                    label: 'Terminees',
                    value: '0',
                    color: const Color(0xFF2196F3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
