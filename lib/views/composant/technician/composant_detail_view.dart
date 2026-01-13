import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/composant_controller.dart';

class ComposantDetailView extends StatelessWidget {
  final int composantId;

  const ComposantDetailView({super.key, required this.composantId});

  @override
  Widget build(BuildContext context) {
    final ComposantController controller = Get.find<ComposantController>();

    if (controller.selectedComposant == null ||
        controller.selectedComposant!.id != composantId) {
      controller.loadComposantById(composantId);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: AppBar(
        title: const Text(
          'Détail du Composant',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFFffd60a)),
          onPressed: () => Get.back(),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFffd60a)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1f2e), Color(0xFF0f1419), Color(0xFF051628)],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading) {
            return Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFffd60a), Color(0xFFffc300)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFffd60a),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0f1419)),
                  strokeWidth: 3,
                ),
              ),
            );
          }

          final composant = controller.selectedComposant;
          if (composant == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFff6b6b).withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 40,
                      color: const Color(0xFFff6b6b).withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Composant non trouvé',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image / Icon container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 255, 255, 0.06),
                              Color.fromRGBO(255, 255, 255, 0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFffd60a).withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Color(0xFFffd60a),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Component Name
                  Text(
                    composant.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Détails
                  if (composant.reference != null &&
                      composant.reference!.isNotEmpty)
                    _buildDetailItem(
                      icon: Icons.label_outlined,
                      label: 'Référence',
                      value: composant.reference!,
                    ),
                  _buildDetailItem(
                    icon: Icons.euro_outlined,
                    label: 'Prix unitaire',
                    value: '${composant.unitPrice.toStringAsFixed(2)} €',
                    isPrice: true,
                  ),
                  if (composant.manufacturer != null &&
                      composant.manufacturer!.isNotEmpty)
                    _buildDetailItem(
                      icon: Icons.business_outlined,
                      label: 'Fabricant',
                      value: composant.manufacturer!,
                    ),
                  if (composant.warrantyPeriod != null &&
                      composant.warrantyPeriod! > 0)
                    _buildDetailItem(
                      icon: Icons.shield_outlined,
                      label: 'Période de garantie',
                      value: '${composant.warrantyPeriod} mois',
                    ),
                  if (composant.certifications != null &&
                      composant.certifications!.isNotEmpty)
                    _buildDetailItem(
                      icon: Icons.verified_outlined,
                      label: 'Certifications',
                      value: composant.certifications!,
                    ),
                  if (composant.createdAt != null)
                    _buildDetailItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date de création',
                      value: composant.createdAt!.toString().split(' ')[0],
                    ),
                  if (composant.updatedAt != null)
                    _buildDetailItem(
                      icon: Icons.update_outlined,
                      label: 'Dernière mise à jour',
                      value: composant.updatedAt!.toString().split(' ')[0],
                    ),
                  if (composant.technician != null &&
                      composant.technician!.name != null)
                    _buildDetailItem(
                      icon: Icons.person_outline,
                      label: 'Technicien',
                      value: composant.technician!.name!,
                    ),
                ],
              ),
            ),
          );
        }),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Bouton Modifier
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFffd60a), Color(0xFFffc300)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFffd60a),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: () {
                Get.toNamed('/composant/edit', arguments: composantId);
              },
              backgroundColor: Colors.transparent,
              foregroundColor: const Color(0xFF1a1f2e),
              heroTag: 'composant_edit_fab',
              elevation: 0,
              icon: const Icon(Icons.edit_outlined, size: 20),
              label: const Text(
                'Modifier',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
          // Bouton Supprimer
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFff6b6b), Color(0xFFff4d4d)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFff6b6b),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: () async {
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xFF1a1f2e),
                      title: Text(
                        'Confirmer la suppression',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      content: Text(
                        'Êtes-vous sûr de vouloir supprimer ce composant ? Cette action est irréversible.',
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(
                            'Annuler',
                            style: TextStyle(color: Color(0xFF95A5A6)),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Supprimer',
                            style: TextStyle(color: Color(0xFFff6b6b)),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  await controller.deleteComposant(composantId);
                  if (!context.mounted) return;
                  Get.toNamed('/composant');
                }
              },
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              heroTag: 'composant_delete_fab',
              elevation: 0,
              icon: const Icon(Icons.delete_outline, size: 20),
              label: const Text(
                'Supprimer',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isPrice = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFffd60a), size: 20),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              '$label :',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isPrice ? FontWeight.w700 : FontWeight.normal,
                color: isPrice
                    ? const Color(0xFF00ff88)
                    : Colors.white, // Vert fluo pour le prix
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
