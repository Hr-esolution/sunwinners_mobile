import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/widgets/sunwinners_app_bar.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Nos Services',
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        iconColor: const Color(0xFFffd60a),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFFffd60a)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1f2e), Color(0xFF0f1419), Color(0xFF051628)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFffd60a).withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.solar_power_rounded,
                        size: 40,
                        color: const Color(0xFFffd60a).withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Notre Plateforme Intermédiaire',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Sunwinners connecte clients, techniciens et entreprises dans le domaine de l\'énergie solaire au Maroc.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Workflow en 5 étapes
              Text(
                'Comment ça marche ?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              _buildWorkflowStep(
                step: 1,
                title: 'Client crée un devis',
                description:
                    'Le client soumet une demande détaillée via notre plateforme pour un projet solaire.',
                color: const Color(0xFFffd60a),
              ),
              _buildWorkflowStep(
                step: 2,
                title: 'Devis partagé avec techniciens',
                description:
                    'Sunwinners présente automatiquement le devis aux techniciens qualifiés disponibles.',
                color: const Color(0xFF00d4ff),
              ),
              _buildWorkflowStep(
                step: 3,
                title: 'Techniciens répondent',
                description:
                    'Les techniciens envoient leurs offres personnalisées avec prix, composants et délais.',
                color: const Color(0xFF00ff88),
              ),
              _buildWorkflowStep(
                step: 4,
                title: 'Client choisit et signe',
                description:
                    'Le client sélectionne la meilleure offre, signe le contrat électronique et valide le projet.',
                color: const Color(0xFF00ff88),
              ),
              _buildWorkflowStep(
                step: 5,
                title: 'Projet suivi + Subvention',
                description:
                    'Sunwinners accompagne le projet jusqu’à sa fin et aide à la demande de subventions publiques.',
                color: const Color(0xFFffd60a),
              ),

              const SizedBox(height: 32),

              // Boutons d'action
              Text(
                'Découvrez plus',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              _buildActionCard(
                icon: Icons.engineering_rounded,
                title: 'Pour les Techniciens',
                description:
                    'Rejoignez notre réseau et développez votre activité solaire.',
                color: const Color(0xFF00d4ff),
                onTap: () => Get.toNamed('/for-technicians'),
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                icon: Icons.person_rounded,
                title: 'Pour les Clients',
                description:
                    'Trouvez le meilleur technicien pour votre projet solaire.',
                color: const Color(0xFF00ff88),
                onTap: () => Get.toNamed('/for-clients'),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkflowStep({
    required int step,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(255, 255, 255, 0.08),
                  Color.fromRGBO(255, 255, 255, 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFffd60a).withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: color.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$step',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: color,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.08),
                    Color.fromRGBO(255, 255, 255, 0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFffd60a).withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
