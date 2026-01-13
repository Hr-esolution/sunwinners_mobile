// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/composant_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';

class TechnicianDashboardView extends StatelessWidget {
  const TechnicianDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ComposantController composantController = Get.find<ComposantController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord Technicien', style: AppTypography.h2.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: () {
              Get.toNamed('/profile');
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.green, Color(0xFF27AE60)], // Using design system green
                  ),
                  borderRadius: BorderRadius.circular(AppBorderRadius.xl), // Using design system border radius
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour, ${authController.currentUser?.name ?? 'Technicien'}',
                      style: AppTypography.h2.copyWith(color: AppColors.white), // Using design system typography
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Voici vos composants solaires',
                      style: AppTypography.body.copyWith(color: AppColors.white.withOpacity(0.8)), // Using design system typography
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sectionGap), // Using design system spacing

              // Stats cards
              Row(
                children: [
                  Expanded(
                    child: CustomCard( // Using design system card
                      child: Column(
                        children: [
                          Icon(Icons.inventory_outlined, color: AppColors.gold, size: 32), // Using design system colors
                          const SizedBox(height: 8),
                          Obx(
                            () => Text(
                              '${composantController.composantList.length}',
                              style: AppTypography.h2.copyWith(color: AppColors.gold), // Using design system typography
                            ),
                          ),
                          Text(
                            'Composants',
                            style: AppTypography.caption.copyWith(color: AppColors.mediumGray), // Using design system typography
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemGap), // Using design system spacing
                  Expanded(
                    child: CustomCard( // Using design system card
                      child: Column(
                        children: [
                          Icon(Icons.check_circle_outline, color: AppColors.green, size: 32), // Using design system colors
                          const SizedBox(height: 8),
                          Obx(
                            () => Text(
                              '${composantController.composantList.length}',
                              style: AppTypography.h2.copyWith(color: AppColors.green), // Using design system typography
                            ),
                          ),
                          Text(
                            'Actifs',
                            style: AppTypography.caption.copyWith(color: AppColors.mediumGray), // Using design system typography
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sectionGap), // Using design system spacing

              // Recent activity header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Composants récents',
                    style: AppTypography.h3, // Using design system typography
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/composant/list');
                    },
                    child: Text(
                      'Voir tous',
                      style: AppTypography.caption.copyWith(color: AppColors.gold), // Using design system typography
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.itemGap), // Using design system spacing

              // Recent composants list
              Obx(
                () => composantController.composantList.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Aucun composant trouvé',
                          style: AppTypography.body.copyWith(color: AppColors.mediumGray),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: composantController.composantList.length > 3
                            ? 3
                            : composantController.composantList.length,
                        itemBuilder: (context, index) {
                          final composant = composantController.composantList[index];
                          return CustomListItem( // Using design system list item
                            leading: CustomAvatar( // Using design system avatar
                              initials: composant.name.substring(0, 1).toUpperCase(),
                              radius: 20,
                            ),
                            title: Text(
                              composant.name,
                              style: AppTypography.body, // Using design system typography
                            ),
                            subtitle: Text(
                              composant.manufacturer ?? 'Fabricant non spécifié',
                              style: AppTypography.caption.copyWith(color: AppColors.mediumGray), // Using design system typography
                            ),
                            trailing: Text(
                              composant.reference ?? 'Réf: ${composant.id}',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.mediumGray, // Using design system colors
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: AppSpacing.sectionGap), // Using design system spacing

              // Quick actions
              Text(
                'Actions rapides',
                style: AppTypography.h3, // Using design system typography
              ),

              const SizedBox(height: AppSpacing.itemGap), // Using design system spacing

              Row(
                children: [
                  Expanded(
                    child: SecondaryButton( // Using design system button
                      text: 'Nouveau devis',
                      onPressed: () {
                        Get.toNamed('/technician/respond-to-devis');
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemGap), // Using design system spacing
                  Expanded(
                    child: SecondaryButton( // Using design system button
                      text: 'Mes devis',
                      onPressed: () {
                        Get.toNamed('/technician/my-responses');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}