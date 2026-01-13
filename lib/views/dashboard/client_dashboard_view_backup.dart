import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';

class ClientDashboardView extends StatelessWidget {
  const ClientDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord', style: AppTypography.h2.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Get.toNamed(AppRoutes.profile);
            },
          ),
        ],
      ),
      backgroundColor: AppColors.lightGreen, // Using design system background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding), // Using design system spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.green, Color(0xFF27AE60)], // Using design system green
                  ),
                  borderRadius: BorderRadius.circular(AppBorderRadius.xl), // Using design system border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ], // Using design system shadows
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenue, ${authController.currentUser?.name ?? 'Client'}!',
                      style: AppTypography.h1.copyWith( // Using design system typography
                        color: AppColors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gérez vos projets solaires et demandes',
                      style: AppTypography.body.copyWith( // Using design system typography
                        color: AppColors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sectionGap), // Using design system spacing

              // Quick actions section
              Text(
                'Actions rapides',
                style: AppTypography.h3, // Using design system typography
              ),
              const SizedBox(height: AppSpacing.m), // Using design system spacing

              Wrap(
                spacing: AppSpacing.s, // Using design system spacing
                runSpacing: AppSpacing.s, // Using design system spacing
                children: [
                  _buildActionCard(
                    context,
                    Icons.add_box_rounded,
                    'Créer Devis',
                    'Nouvelle demande',
                    () {
                      Get.toNamed(AppRoutes.devisCreate);
                    },
                  ),
                  _buildActionCard(
                    context,
                    Icons.list_alt_rounded,
                    'Mes Devis',
                    'Voir demandes',
                    () {
                      Get.toNamed(AppRoutes.clientDevisList);
                    },
                  ),
                  _buildActionCard(
                    context,
                    Icons.work_rounded,
                    'Mes Projets',
                    'Suivi en cours',
                    () {
                      Get.toNamed(AppRoutes.projectList);
                    },
                  ),
                  _buildActionCard(
                    context,
                    Icons.monetization_on_rounded,
                    'Subventions',
                    'Aides financières',
                    () {
                      Get.toNamed(AppRoutes.subventionList);
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sectionGap), // Using design system spacing

              // Recent activity section
              Text(
                'Activité récente',
                style: AppTypography.h3, // Using design system typography
              ),
              const SizedBox(height: AppSpacing.m), // Using design system spacing

              CustomCard( // Using design system card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.green, // Using design system color
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Pas d\'activité récente',
                          style: AppTypography.body.copyWith( // Using design system typography
                            color: AppColors.mediumGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vos activités récentes apparaîtront ici',
                      style: AppTypography.caption.copyWith( // Using design system typography
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.m), // Using design system spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppBorderRadius.m), // Using design system border radius
          splashColor: AppColors.green.withValues(alpha: 0.1), // Using design system color
          highlightColor: AppColors.green.withValues(alpha: 0.05), // Using design system color
          child: CustomCard( // Using design system card
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.1), // Using design system color
                    borderRadius: BorderRadius.circular(AppBorderRadius.s), // Using design system border radius
                  ),
                  child: Icon(icon, size: 28, color: AppColors.green), // Using design system color
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTypography.body.copyWith( // Using design system typography
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray, // Using design system color
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith( // Using design system typography
                    color: AppColors.mediumGray, // Using design system color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}