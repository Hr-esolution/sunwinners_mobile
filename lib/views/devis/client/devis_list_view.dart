import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/devis_controller.dart';
import '../../../core/constants/app_routes.dart';
import '../../../widgets/sunwinners_app_bar.dart';

class ClientDevisListView extends StatefulWidget {
  const ClientDevisListView({super.key});

  @override
  State<ClientDevisListView> createState() => _ClientDevisListViewState();
}

class _ClientDevisListViewState extends State<ClientDevisListView> {
  late final DevisController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<DevisController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadClientDevis();
    });
  }

  void _loadClientDevis() async {
    await controller.loadMyDevis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Mes Devis',
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
          builder: (_) {
            if (controller.isLoading) {
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
                      'Chargement de vos devis...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (controller.devisList.isEmpty) {
              return Center(
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
                        Icons.assignment_outlined,
                        size: 40,
                        color: const Color(0xFFffd60a).withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucun devis disponible',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vos devis apparaîtront ici',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _loadClientDevis(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: ListView.builder(
                  itemCount: controller.devisList.length,
                  itemBuilder: (context, index) {
                    final devis = controller.devisList[index];
                    return _buildDevisCard(devis);
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFffd60a), Color(0xFFffc300)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFffd60a),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AppRoutes.devisCreate);
          },
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF1a1f2e),
          heroTag: 'devis_list_fab',
          elevation: 0,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildDevisCard(devis) {
    String formattedStatus = _formatStatus(devis.status);
    Color statusColor = _getStatusColor(devis.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
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
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFffd60a).withValues(alpha: 0.1),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.toNamed(AppRoutes.clientDevisDetail, arguments: devis.id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Réf: ${devis.reference}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  statusColor.withValues(alpha: 0.25),
                                  statusColor.withValues(alpha: 0.12),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              formattedStatus,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Type: ${_formatTypeDemande(devis.typeDemande)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Objectif: ${_formatObjectif(devis.objectif)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            devis.date != null
                                ? '${devis.date!.day}/${devis.date!.month}/${devis.date!.year}'
                                : 'Date non spécifiée',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // === Couleurs de statut selon le design system Sunwinners ===
  Color _getStatusColor(String status) {
    switch (status) {
      case 'en_cours_de_traitement':
        return const Color(0xFF00d4ff); // Cyan → En cours
      case 'en_attente_confirmation_technicien':
        return const Color(0xFFffd60a); // Gold → En attente
      case 'repondu_par_technicien':
        return const Color(0xFF00ff88); // Vert fluo → Répondu
      case 'accepte_par_client':
        return const Color(0xFF00ff88); // Vert fluo → Accepté
      case 'refuse_par_client':
        return const Color(0xFFff6b6b); // Rouge → Refusé
      default:
        return const Color(0xFF95A5A6); // Gris neutre
    }
  }

  // === Formattage inchangé ===
  String _formatStatus(String status) {
    switch (status) {
      case 'en_cours_de_traitement':
        return 'En cours';
      case 'en_attente_confirmation_technicien':
        return 'En attente';
      case 'repondu_par_technicien':
        return 'Répondu';
      case 'accepte_par_client':
        return 'Accepté';
      case 'refuse_par_client':
        return 'Refusé';
      default:
        return status
            .split('_')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
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
}
