import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/controllers/auth_controller.dart';
import 'package:sunwinners/controllers/devis_controller.dart';
import 'package:sunwinners/core/constants/app_roles.dart';
import 'package:sunwinners/data/models/devis_model.dart';
import 'package:sunwinners/data/models/devis_response_model.dart';
import 'package:sunwinners/widgets/sunwinners_app_bar.dart';

class DevisDetailPage extends StatelessWidget {
  final int devisId;

  const DevisDetailPage({super.key, required this.devisId});

  @override
  Widget build(BuildContext context) {
    final DevisController controller = Get.find<DevisController>();
    final AuthController authController = Get.find<AuthController>();

    if (controller.currentDevis == null ||
        controller.currentDevis?.id != devisId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadDevisDetail(devisId);
      });
    }

    return Scaffold(
      appBar: const SunwinnersAppBar(
        title: 'Détails du devis',
        elevation: 0,
        iconColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF8F9FB),
      body: GetBuilder<DevisController>(
        builder: (_) {
          if (controller.isLoading && controller.currentDevis == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chargement...',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final DevisModel? devis = controller.currentDevis;

          if (devis == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun devis trouvé',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statusCard(devis),
                const SizedBox(height: 24),
                _infoCard(devis),
                const SizedBox(height: 24),
                if (devis.images != null && devis.images!.isNotEmpty) ...[
                  _imagesSection(devis.images!),
                  const SizedBox(height: 24),
                ],
                if (devis.responses != null && devis.responses!.isNotEmpty) ...[
                  _responsesSection(devis.responses!),
                  const SizedBox(height: 24),
                ],
                _roleBasedActions(controller, authController, devis),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // =========================
  // 🚦 STATUT (En premier pour visibilité)
  // =========================
  Widget _statusCard(DevisModel devis) {
    final (Color color, String label) = _getStatusInfo(devis.status);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withAlpha((0.1 * 255).toInt()),
            color.withAlpha((0.05 * 255).toInt()),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withAlpha((0.3 * 255).toInt()),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.check_circle, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statut du devis',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // 📦 INFOS DEVIS
  // =========================
  Widget _infoCard(DevisModel devis) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withAlpha((0.08 * 255).toInt()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations du devis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 16),
            _infoRow('Référence', devis.reference, Icons.numbers),
            _divider(),
            _infoRow('Type demande', devis.typeDemande, Icons.category),
            _divider(),
            _infoRow('Objectif', devis.objectif, Icons.hd),
            _divider(),
            _infoRow(
              'Installation',
              devis.typeInstallation,
              Icons.construction,
            ),
            _divider(),
            _infoRow(
              'Type utilisation',
              devis.typeUtilisation ?? '-',
              Icons.settings,
            ),
            _divider(),
            _infoRow('Type pompe', devis.typePompe ?? '-', Icons.water),
            _divider(),
            _infoRow(
              'Débit estimé',
              devis.debitEstime?.toString() ?? '-',
              Icons.speed,
            ),
            _divider(),
            _infoRow(
              'Profondeur forage',
              devis.profondeurForage?.toString() ?? '-',
              Icons.straighten,
            ),
            _divider(),
            _infoRow(
              'Capacité réservoir',
              devis.capaciteReservoir?.toString() ?? '-',
              Icons.storage,
            ),
            _divider(),
            _infoRow(
              'Adresse',
              devis.adresseComplete ?? '-',
              Icons.location_on,
            ),
            _divider(),
            _infoRow('Toit', devis.toitInstallation ?? '-', Icons.home),
          ],
        ),
      ),
    );
  }

  // =========================
  // 🖼️ IMAGES
  // =========================
  Widget _imagesSection(List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Galerie photos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.1 * 255).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[index],
                      width: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // =========================
  // 👷‍♂️ RÉPONSES TECHNICIENS
  // =========================
  Widget _responsesSection(List<DevisResponseModel> responses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Réponses des techniciens',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 12),
        ...responses.asMap().entries.map((entry) {
          final index = entry.key;
          final response = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < responses.length - 1 ? 12 : 0,
            ),
            child: Card(
              elevation: 2,
              shadowColor: Colors.black.withAlpha((0.08 * 255).toInt()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF2E7D32,
                              ).withAlpha((0.1 * 255).toInt()),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.engineering,
                              color: Color(0xFF2E7D32),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Technicien ID: ${response.technicianId ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Prix : ${response.prixTotal?.toStringAsFixed(2) ?? 'N/A'} DH',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (response.commentaire != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Commentaire',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                response.commentaire!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // =========================
  // ✅ ACTIONS BASED ON ROLE
  // =========================
  Widget _roleBasedActions(
    DevisController controller,
    AuthController authController,
    DevisModel devis,
  ) {
    final userRole = authController.userRole;

    // Admin/Owner actions
    if (userRole == AppRoles.owner || userRole == AppRoles.admin) {
      if (devis.status == 'en_cours_de_traitement') {
        // Show technician assignment button for admins when devis is in processing
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => _assignTechnicians(controller, devis.id),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_ind, size: 20),
                SizedBox(width: 8),
                Text(
                  'Assigner des techniciens',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      } else if (devis.status == 'accepte_par_client') {
        // Show project creation button when devis is accepted
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => controller.navigateToProjectCreation(devis.id),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_task, size: 20),
                SizedBox(width: 8),
                Text(
                  'Créer un projet à partir de ce devis',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      }
    }
    // Client actions
    else if (userRole == AppRoles.client) {
      if (devis.status == 'repondu_par_technicien' ||
          devis.status == 'en_attente_confirmation_technicien') {
        // Show accept/reject buttons when devis is responded to but not yet accepted
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => controller.validateDevis(devis.id),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Accepter',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[500],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => controller.rejectDevis(devis.id),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Rejeter',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    // Technician actions - none for now, but could be added later

    return const SizedBox();
  }

  // =========================
  // 🔹 HELPERS
  // =========================
  (Color, String) _getStatusInfo(String status) {
    switch (status) {
      case 'accepte_par_client':
        return (Colors.green, 'Accepté');
      case 'refuse_par_client':
        return (Colors.red, 'Refusé');
      case 'en_cours_de_traitement':
        return (Colors.blue, 'En cours de traitement');
      case 'en_attente_confirmation_technicien':
        return (Colors.orange, 'En attente confirmation');
      case 'repondu_par_technicien':
        return (Colors.purple, 'Répondu par technicien');
      case 'validé':
        return (Colors.green, 'Validé');
      case 'rejeté':
        return (Colors.red, 'Rejeté');
      default:
        return (
          Colors.grey,
          status
              .split('_')
              .map(
                (word) => word.isNotEmpty
                    ? word[0].toUpperCase() + word.substring(1)
                    : word,
              )
              .join(' '),
        );
    }
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Divider(height: 0, color: Colors.grey[200]),
  );

  // Method to assign technicians
  void _assignTechnicians(DevisController controller, int devisId) {
    // For now, show a dialog to select technicians
    // In a real implementation, this would navigate to a technician selection screen
    Get.defaultDialog(
      title: "Assigner des Techniciens",
      middleText:
          "Fonctionnalité de sélection des techniciens bientôt disponible",
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog
            // In a real implementation, you would navigate to a technician selection screen
            // where the user can select from available technicians
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
