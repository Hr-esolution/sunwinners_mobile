import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/controllers/devis_controller.dart';
import 'package:sunwinners/controllers/user_controller.dart';
import 'package:sunwinners/widgets/sunwinners_app_bar.dart';

class OwnerDevisDetailPage extends StatefulWidget {
  final int devisId;

  const OwnerDevisDetailPage({super.key, required this.devisId});

  @override
  State<OwnerDevisDetailPage> createState() => _OwnerDevisDetailPageState();
}

class _OwnerDevisDetailPageState extends State<OwnerDevisDetailPage> {
  final DevisController devisController = Get.find<DevisController>();
  final UserController userController = Get.find<UserController>();

  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();

    // Use Timer to delay the loading calls to avoid setState during build
    _loadingTimer = Timer(Duration(milliseconds: 100), () {
      devisController.loadDevisDetail(widget.devisId);
      userController.loadAllTechnicians();
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Détails du devis',
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
        child: GetBuilder<DevisController>(
          builder: (controller) {
            final devis = controller.currentDevis;

            if (controller.isLoading && devis == null) {
              return Center(
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
                      'Chargement du devis...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (devis == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFffd60a).withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.inbox,
                        size: 40,
                        color: const Color(0xFFffd60a).withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucun devis trouvé',
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

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Infos devis
                  _buildDevisInfo(devis),

                  const SizedBox(height: 20),

                  /// Liste des techniciens assignés ou bouton d'assignation
                  _buildTechniciansInfo(devis),

                  const SizedBox(height: 20),

                  /// Bouton assignation techniciens si le statut permet l'assignation
                  if (devis.status == 'en_cours_de_traitement')
                    _buildAssignTechniciansButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDevisInfo(devis) {
    return ClipRRect(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Référence : ${devis.reference}",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              _buildStatusInfo(devis.status),
              const SizedBox(height: 8),
              _buildInfoRow('Adresse', devis.adresseComplete ?? '-'),
              const SizedBox(height: 8),
              _buildInfoRow('Installation', devis.typeInstallation),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for status display
  Widget _buildStatusInfo(String status) {
    final (Color color, String label) = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.25),
            color.withOpacity(0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  // Helper method for info rows
  Widget _buildInfoRow(String label, String value) {
    return Row(
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
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  // Helper method for status colors
  (Color, String) _getStatusInfo(String status) {
    switch (status) {
      case 'accepte_par_client':
        return (const Color(0xFF00ff88), 'Accepté');
      case 'refuse_par_client':
        return (const Color(0xFFff6b6b), 'Refusé');
      case 'en_cours_de_traitement':
        return (const Color(0xFF00d4ff), 'En cours');
      case 'en_attente_confirmation_technicien':
        return (const Color(0xFFffd60a), 'En attente');
      case 'repondu_par_technicien':
        return (const Color(0xFF00ff88), 'Répondu');
      default:
        return (
          const Color(0xFF95A5A6),
          status
              .split('_')
              .map((word) => word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1)
                  : word)
              .join(' '),
        );
    }
  }

  Widget _buildTechniciansInfo(devis) {
    final assignedTechnicians = devis.technicians ?? [];

    if (assignedTechnicians.isEmpty) {
      // If no technicians assigned and status allows assignment, show the button
      if (devis.status == 'en_cours_de_traitement') {
        return Container(); // Button will be shown separately
      }
      // If no technicians assigned and status doesn't allow assignment, show info
      return ClipRRect(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Techniciens assignés",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Aucun technicien assigné à ce devis",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Show assigned technicians
    return ClipRRect(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Techniciens assignés",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  if (devis.status == 'en_cours_de_traitement')
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00d4ff), Color(0xFF00bfff)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF00d4ff),
                            blurRadius: 16,
                            spreadRadius: 0,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () async {
                          final result = await Get.toNamed('/owner/devis/assign-technicians', arguments: widget.devisId);
                          // Refresh the devis data after returning from assignment
                          if (result == true) {
                            await devisController.loadDevisDetail(widget.devisId);
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Text(
                            "Modifier",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: Color(0xFF1a1f2e),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ...assignedTechnicians.map((technician) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.engineering, size: 18, color: const Color(0xFF00d4ff)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              technician.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            if (technician.companyName != null && technician.companyName!.isNotEmpty)
                              Text(
                                technician.companyName!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignTechniciansButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFffd60a), Color(0xFFffc300)],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFffd60a),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            final result = await Get.toNamed('/owner/devis/assign-technicians', arguments: widget.devisId);
            // Refresh the devis data after returning from assignment
            if (result == true) {
              await devisController.loadDevisDetail(widget.devisId);
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.assignment_ind, size: 20, color: Color(0xFF1a1f2e)),
                SizedBox(width: 8),
                Text(
                  'Assigner des techniciens',
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
    );
  }

}
