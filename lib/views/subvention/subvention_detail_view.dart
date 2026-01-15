import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/subvention_controller.dart';
import '../../data/models/subvention_model.dart';
import '../../widgets/sunwinners_app_bar.dart';

class SubventionDetailView extends StatelessWidget {
  const SubventionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final SubventionController controller = Get.find<SubventionController>();
    final int? subventionId = Get.arguments;

    if (subventionId != null) {
      controller.loadSubventionDetail(subventionId);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Détail de la Subvention',
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        iconColor: const Color(0xFFffd60a),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1f2e), Color(0xFF0f1419), Color(0xFF051628)],
          ),
        ),
        child: Obx(
          () => controller.isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF0f1419),
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chargement de la subvention...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                )
              : controller.currentSubvention != null
              ? _buildSubventionDetail(context, controller.currentSubvention!)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFffd60a).withValues(alpha: 0.1),
                        ),
                        child: Icon(
                          Icons.money,
                          size: 40,
                          color: const Color(0xFFffd60a).withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Subvention non trouvée',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSubventionDetail(
    BuildContext context,
    SubventionModel subvention,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getStatusColor(
                      subvention.statut ?? '',
                    ).withValues(alpha: 0.25),
                    _getStatusColor(
                      subvention.statut ?? '',
                    ).withValues(alpha: 0.12),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getStatusColor(
                    subvention.statut ?? '',
                  ).withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Text(
                (subvention.statut ?? '').toUpperCase(),
                style: TextStyle(
                  color: _getStatusColor(subvention.statut ?? ''),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Project Type
            Text(
              subvention.typeProjet ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              subvention.descriptionProjet ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 24),

            // Details section
            ClipRRect(
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
                      color: const Color(0xFFffd60a).withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informations du projet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2ECC71),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'ID Projet',
                        subvention.projectId?.toString() ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Référence Projet',
                        subvention.project?.devis?.reference ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Nom Projet',
                        subvention.nomProjet ?? 'N/A',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            ClipRRect(
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
                      color: const Color(0xFFffd60a).withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Détails de la subvention',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2ECC71),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow('Type', subvention.typeProjet ?? 'N/A'),
                      _buildDetailRow(
                        'Représentant',
                        subvention.representant ?? 'N/A',
                      ),
                      _buildDetailRow('Email', subvention.email ?? 'N/A'),
                      _buildDetailRow(
                        'Téléphone',
                        subvention.telephone ?? 'N/A',
                      ),
                      _buildDetailRow('Adresse', subvention.adresse ?? 'N/A'),
                      _buildDetailRow(
                        'Description du projet',
                        subvention.descriptionProjet ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Adresse du projet',
                        subvention.adresseProjet ?? 'N/A',
                      ),
                      _buildDetailRow('Secteur', subvention.secteur ?? 'N/A'),
                      _buildDetailRow(
                        'Type d\'entreprise',
                        subvention.typeEntreprise ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Taille de l\'entreprise',
                        subvention.tailleEntreprise ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Date de début',
                        subvention.dateDebut?.toString() ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Éligibilité',
                        subvention.eligibilite != null
                            ? subvention.eligibilite!.join(', ')
                            : 'N/A',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons based on status and role
            _buildActionButtons(context, subvention),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: const Color(0xFFffd60a)),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, SubventionModel subvention) {
    //  Implement role-based actions
    // For now, showing basic actions
    return Column(
      children: [
        if (subvention.statut == 'en_attente')
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF4CAF50),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                //  Implement approve subvention functionality
                Get.snackbar(
                  'Info',
                  'Fonctionnalité d\'approbation de subvention bientôt disponible',
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check, size: 20, color: Color(0xFF1a1f2e)),
                    SizedBox(width: 8),
                    Text(
                      'Approuver la subvention',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF1a1f2e),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (subvention.statut == 'confirmee')
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF2196F3),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                //  Implement mark as paid functionality
                Get.snackbar(
                  'Info',
                  'Fonctionnalité de marquage comme payé bientôt disponible',
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.attach_money,
                      size: 20,
                      color: Color(0xFF1a1f2e),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Marquer comme payé',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF1a1f2e),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF2ECC71),
                blurRadius: 16,
                spreadRadius: 0,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              //  Implement edit subvention functionality
              Get.snackbar(
                'Info',
                'Fonctionnalité de modification de subvention bientôt disponible',
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit, size: 20, color: Color(0xFF1a1f2e)),
                  SizedBox(width: 8),
                  Text(
                    'Modifier la subvention',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF1a1f2e),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'en_attente':
        return const Color(0xFFFF9800);
      case 'confirmee':
        return const Color(0xFF4CAF50);
      case 'refusee':
        return const Color(0xFFF44336);
      case 'paid': // Keep English for paid if needed in the future
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}
