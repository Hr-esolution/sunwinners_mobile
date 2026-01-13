import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
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
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Énergie solaire intelligente',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                _buildDrawerItem(
                  Icons.home_rounded,
                  'Accueil',
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  Icons.solar_power_rounded,
                  'Services',
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  Icons.info_rounded,
                  'À propos',
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  Icons.security_rounded,
                  'Politique de confidentialité',
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  Icons.description_rounded,
                  'Conditions d\'utilisation',
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  Icons.help_rounded,
                  'Support',
                  () => Navigator.pop(context),
                ),
                const Divider(),
                _buildDrawerItem(
                  Icons.logout_rounded,
                  'Déconnexion',
                  () => Navigator.pop(context),
                  color: Colors.red,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                const Text(
                  '© 2024 Sunwinners. Tous droits réservés.',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
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
    Color color = const Color(0xFF2ECC71),
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: onTap,
      selectedTileColor: const Color(0xFF2ECC71).withValues(alpha: 0.1),
    );
  }
}
