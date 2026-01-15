import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/project_controller.dart';
import '../../data/models/project_model.dart';
import '../../widgets/sunwinners_app_bar.dart';
import '../../widgets/sunwinners_card.dart';

class ProjectDetailView extends StatelessWidget {
  const ProjectDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectController controller = Get.find<ProjectController>();
    final int? projectId = Get.arguments;

    if (projectId != null) {
      controller.loadProjectDetail(projectId);
    }

    return Scaffold(
      appBar: SunwinnersAppBar(
        title: 'Détail du Projet',
        backgroundColor: const Color(0xFF2ECC71),
        foregroundColor: Colors.white,
        elevation: 0,
        iconColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(
        () => controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.currentProject != null
            ? _buildProjectDetail(context, controller.currentProject!)
            : const Center(child: Text('Projet non trouvé')),
      ),
    );
  }

  Widget _buildProjectDetail(BuildContext context, ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(project.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                project.status.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Project ID
            Text(
              'Projet #${project.id}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),

            // Status
            Text(
              'Statut: ${project.status}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Details section
            SunwinnersCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations du projet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2ECC71),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Actif',
                    project.isActive == true ? 'Oui' : 'Non',
                  ),
                  _buildDetailRow(
                    'Fichier contrat',
                    project.contratSignedFile ?? 'Aucun contrat',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SunwinnersCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations du devis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2ECC71),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'ID Devis',
                    project.devis?.id.toString() ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Référence Devis',
                    project.devis?.reference ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Statut Devis',
                    project.devis?.status ?? 'N/A',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SunwinnersCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations du technicien',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2ECC71),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'ID Technicien',
                    project.technician?.id.toString() ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Nom Technicien',
                    project.technician?.companyName ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Téléphone Technicien',
                    project.technician?.phone ?? 'N/A',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SunwinnersCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations de subvention',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2ECC71),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'ID Subvention',
                    project.subvention?.id.toString() ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Statut Subvention',
                    project.subvention?.statut ?? 'N/A',
                  ),
                  _buildDetailRow(
                    'Projet Subvention',
                    project.subvention?.nomProjet ?? 'N/A',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons based on status and role
            _buildActionButtons(context, project),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ProjectModel project) {
    final ProjectController controller = Get.find<ProjectController>();

    //  Implement role-based actions
    // For now, showing basic actions
    return Column(
      children: [
        if (project.status == 'd_accord')
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Activate the project
                controller.updateProjectStatus(project.id, 'en_cours');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Activer le projet'),
            ),
          ),
        if (project.status == 'd_accord') const SizedBox(height: 10),
        if (project.status == 'en_cours')
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Complete the project
                controller.updateProjectStatus(project.id, 'termine');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Compléter le projet'),
            ),
          ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2ECC71).withValues(alpha: 0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: OutlinedButton(
            onPressed: () {
              //  Implement edit project functionality
              Get.snackbar(
                'Info',
                'Fonctionnalité de modification du projet bientôt disponible',
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF2ECC71)),
              foregroundColor: const Color(0xFF2ECC71),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Modifier le projet'),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'd_accord':
        return Colors.orange;
      case 'en_cours':
        return const Color(0xFF2ECC71);
      case 'termine':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
