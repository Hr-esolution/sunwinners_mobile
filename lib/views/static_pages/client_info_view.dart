// views/pages/client_info_view.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/widgets/sunwinners_app_bar.dart';

class ClientInfoView extends StatelessWidget {
  const ClientInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Pour les Clients',
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
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF00ff88).withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: const Color(0xFF00ff88).withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Votre Projet Solaire Simplifié',
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
                        'Obtenez plusieurs offres compétitives, comparez et choisissez le meilleur technicien en toute transparence.',
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

              Text(
                'Vos Garanties',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              _buildGuaranteeCard(
                icon: Icons.compare_arrows_rounded,
                title: 'Comparaison Facile',
                description:
                    'Recevez plusieurs devis détaillés pour comparer prix, matériel et délais en un seul endroit.',
                color: const Color(0xFF00d4ff),
              ),
              _buildGuaranteeCard(
                icon: Icons.lock_rounded,
                title: 'Sécurité Contractuelle',
                description:
                    'Contrat électronique signé via la plateforme avec clauses de protection du client.',
                color: const Color(0xFFff6b6b),
              ),
              _buildGuaranteeCard(
                icon: Icons.euro_rounded,
                title: 'Aide aux Subventions',
                description:
                    'Sunwinners vous accompagne dans les démarches pour obtenir les aides publiques marocaines.',
                color: const Color(0xFFffd60a),
              ),
              _buildGuaranteeCard(
                icon: Icons.visibility_rounded,
                title: 'Suivi en Temps Réel',
                description:
                    'Tableau de bord dédié pour suivre l’avancement de votre projet à chaque étape.',
                color: const Color(0xFF00ff88),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuaranteeCard({
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
