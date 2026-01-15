import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/widgets/sunwinners_app_bar.dart';

class TechnicianInfoView extends StatelessWidget {
  const TechnicianInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Pour les Techniciens',
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
                        color: const Color(0xFF00d4ff).withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.engineering_rounded,
                        size: 40,
                        color: const Color(0xFF00d4ff).withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Rejoignez la Plateforme Sunwinners',
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
                        'Accédez à des devis qualifiés, gérez vos projets et développez votre activité solaire au Maroc.',
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

              // Bénéfices clés
              Text(
                'Vos Avantages',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              _buildBenefitCard(
                icon: Icons.assignment_turned_in_rounded,
                title: 'Devis Qualifiés',
                description:
                    'Recevez uniquement des demandes vérifiées avec toutes les informations techniques nécessaires.',
                color: const Color(0xFF00d4ff),
              ),
              _buildBenefitCard(
                icon: Icons.monetization_on_rounded,
                title: 'Paiement Sécurisé',
                description:
                    'Sunwinners garantit le paiement à l’achèvement des travaux conformément au contrat signé.',
                color: const Color(0xFF00ff88),
              ),
              _buildBenefitCard(
                icon: Icons.auto_stories_rounded,
                title: 'Visibilité & Réputation',
                description:
                    'Construisez votre profil professionnel et recevez des évaluations clients pour booster votre crédibilité.',
                color: const Color(0xFFffd60a),
              ),
              _buildBenefitCard(
                icon: Icons.handshake_rounded,
                title: 'Support Administratif',
                description:
                    'Nous vous accompagnons dans les démarches de subvention et la gestion contractuelle.',
                color: const Color(0xFF00d4ff),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
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
}
