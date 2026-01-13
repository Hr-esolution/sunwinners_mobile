import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/controllers/auth_controller.dart';
import 'package:sunwinners/controllers/devis_controller.dart';
import 'package:sunwinners/core/constants/app_routes.dart';
import 'package:sunwinners/data/models/devis_model.dart';
import 'package:sunwinners/widgets/sunwinners_app_bar.dart';

class TechnicianDevisDetailPage extends StatefulWidget {
  final int devisId;

  const TechnicianDevisDetailPage({super.key, required this.devisId});

  @override
  State<TechnicianDevisDetailPage> createState() =>
      _TechnicianDevisDetailPageState();
}

class _TechnicianDevisDetailPageState extends State<TechnicianDevisDetailPage> {
  final AuthController authController = Get.find<AuthController>();
  final DevisController controller = Get.find<DevisController>();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    bool isAuthenticated = await authController.checkAuthStatus();
    if (!isAuthenticated) {
      Get.offAllNamed('/login');
      return;
    }

    if (controller.currentDevis == null ||
        controller.currentDevis?.id != widget.devisId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadDevisDetail(widget.devisId);
      });
    }
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
        iconColor: Colors.white,
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
          builder: (_) {
            if (controller.isLoading && controller.currentDevis == null) {
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

            final DevisModel? devis = controller.currentDevis;
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
                  _statusCard(devis),
                  const SizedBox(height: 24),
                  _infoCard(devis),
                  if (devis.images != null && devis.images!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _imagesSection(devis.images!),
                  ],
                  const SizedBox(height: 24),
                  _technicianActions(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================
  // 🚦 STATUT
  // =========================
  Widget _statusCard(DevisModel devis) {
    final (Color color, String label) = _getStatusInfo(devis.status);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.4), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.check_circle, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statut du devis',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // 📦 INFOS DEVIS
  // =========================
  Widget _infoCard(DevisModel devis) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
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
                'Informations du devis',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _infoRow('Référence', devis.reference, Icons.numbers),
              _divider(),
              _infoRow(
                'Type demande',
                _formatTypeDemande(devis.typeDemande),
                Icons.category,
              ),
              _divider(),
              _infoRow('Objectif', _formatObjectif(devis.objectif), Icons.hd),
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFffd60a).withOpacity(0.2),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
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
                          color: Colors.grey.withOpacity(0.1),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white.withOpacity(0.3),
                            size: 32,
                          ),
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
  // ✅ ACTIONS TECHNICIEN
  // =========================
  Widget _technicianActions() {
    if (controller.currentDevis?.status == 'en_cours_de_traitement') {
      return Container(
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
          onTap: () {
            Timer(Duration.zero, () {
              Get.toNamed(
                AppRoutes.technicianRespondToDevis,
                arguments: widget.devisId,
              );
            });
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.send, size: 20, color: Color(0xFF1a1f2e)),
                SizedBox(width: 8),
                Text(
                  'Soumettre un devis',
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
      );
    } else if (controller.currentDevis?.status == 'repondu_par_technicien' ||
        controller.currentDevis?.status ==
            'en_attente_confirmation_technicien') {
      return Column(
        children: [
          // Voir mes réponses
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFffd60a), Color(0xFFffc300)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFffd60a),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => Get.toNamed(AppRoutes.technicianMyResponses),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.visibility, size: 20, color: Color(0xFF1a1f2e)),
                    SizedBox(width: 8),
                    Text(
                      'Voir mes réponses',
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
          // Voir les détails de ma réponse
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
                final response = await controller.getMyResponseForDevis(
                  widget.devisId,
                );
                if (response != null) {
                  controller.navigateToResponseDetail(
                    widget.devisId,
                    responseId: response.id,
                  );
                } else {
                  Get.snackbar(
                    'Aucune réponse',
                    'Vous n\'avez pas encore répondu à ce devis.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFFffd60a),
                    colorText: const Color(0xFF1a1f2e),
                  );
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.description, size: 20, color: Color(0xFF1a1f2e)),
                    SizedBox(width: 8),
                    Text(
                      'Voir les détails de ma réponse',
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

    return const SizedBox();
  }

  // =========================
  // 🔹 HELPERS
  // =========================
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
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' '),
        );
    }
  }

  String _formatTypeDemande(String type) {
    switch (type) {
      case 'nouvelle_installation':
        return 'Nouvelle Installation';
      case 'extension_mise_a_niveau':
        return 'Extension/Mise à Niveau';
      case 'entretien_reparation':
        return 'Entretien/Réparation';
      default:
        return type
            .split('_')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }

  String _formatObjectif(String objectif) {
    switch (objectif) {
      case 'reduction_consommation':
        return 'Réduction Consommation';
      case 'stockage_energie':
        return 'Stockage Énergie';
      case 'extension_future_prevue':
        return 'Extension Future Prévue';
      default:
        return objectif
            .split('_')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFffd60a)),
          const SizedBox(width: 12),
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
      ),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Divider(height: 0, color: Colors.white.withOpacity(0.1)),
  );
}
