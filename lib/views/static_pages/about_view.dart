import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/widgets/sunwinners_app_bar.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'À Propos',
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
                        color: const Color(0xFFffd60a).withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.info_rounded,
                        size: 40,
                        color: const Color(0xFFffd60a).withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Sunwinners',
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
                        'Énergie solaire intelligente pour particuliers et professionnels',
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

              // Mission
              _buildSection(
                title: 'Notre Mission',
                content:
                    'Faciliter la transition énergétique au Maroc et en Europe en rendant l’énergie solaire accessible, fiable et abordable pour tous.',
                icon: Icons.eco_rounded,
                color: const Color(0xFF00ff88),
              ),

              const SizedBox(height: 24),

              // Technologie
              _buildSection(
                title: 'Technologie de Pointe',
                content:
                    'Nous utilisons la dernière technologie pour garantir des installations solaires fiables, efficaces et connectées, adaptées à chaque besoin local.',
                icon: Icons.settings_rounded,
                color: const Color(0xFF00d4ff),
              ),

              const SizedBox(height: 24),

              // Approche
              _buildSection(
                title: 'Approche Client-Centric',
                content:
                    'Chez Sunwinners, chaque projet est unique. Nous accompagnons nos clients de la demande initiale jusqu’à la mise en service complète, avec transparence et professionnalisme.',
                icon: Icons.handshake_rounded,
                color: const Color(0xFFffd60a),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
                      const SizedBox(height: 8),
                      Text(
                        content,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.4,
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
