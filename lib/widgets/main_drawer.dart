import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/core/constants/app_routes.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0f1419),
      child: Column(
        children: [
          // Header avec logo
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(195, 24, 46, 35),
                  Color.fromARGB(255, 19, 32, 25),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/sunwinners_logo.png', width: 60),
                const SizedBox(height: 10),
                const Text(
                  'Sunwinners',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 215, 172, 18),
                  ),
                ),
                const Text(
                  'Énergie solaire intelligente',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 215, 172, 18),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                _buildDrawerItem(
                  Icons.solar_power_rounded,
                  'Services',
                  () => Get.toNamed('/services'),
                ),
                _buildDrawerItem(
                  Icons.engineering_rounded,
                  'Pour les Techniciens',
                  () => Get.toNamed('/for-technicians'),
                ),
                _buildDrawerItem(
                  Icons.person_rounded,
                  'Pour les Clients',
                  () => Get.toNamed('/for-clients'),
                ),
                _buildDrawerItem(Icons.info_rounded, 'À propos', () {
                  Navigator.pop(context); // Close the drawer
                  Get.toNamed(AppRoutes.about); // Navigate to the about page
                }),
                _buildDrawerItem(
                  Icons.security_rounded,
                  'Politique de confidentialité',
                  () {
                    Navigator.pop(context); // Close the drawer
                    Get.toNamed(
                      AppRoutes.privacyPolicy,
                    ); // Navigate to the privacy policy page
                  },
                ),
                _buildDrawerItem(
                  Icons.description_rounded,
                  'Conditions d\'utilisation',
                  () {
                    Navigator.pop(context); // Close the drawer
                    Get.toNamed(
                      AppRoutes.termsOfUse,
                    ); // Navigate to the terms of use page
                  },
                ),
                _buildDrawerItem(Icons.help_rounded, 'Support', () {
                  Navigator.pop(context); // Close the drawer
                  Get.toNamed(
                    AppRoutes.support,
                  ); // Navigate to the support page
                }),
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      color: Colors.white.withOpacity(0.05),
                      height: 1,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  Icons.logout_rounded,
                  'Déconnexion',
                  () => Navigator.pop(context),
                  color: const Color(0xFFff6b6b),
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '© 2024 Sunwinners. Tous droits réservés.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = const Color(0xFFffd60a),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: ListTile(
          leading: Icon(icon, color: color, size: 22),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          onTap: onTap,
          splashColor: color.withOpacity(0.2),
          hoverColor: color.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
