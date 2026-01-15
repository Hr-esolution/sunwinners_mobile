import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/devis_controller.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/devis_response_model.dart';
import '../../../widgets/sunwinners_app_bar.dart';

class MyResponsesView extends StatefulWidget {
  const MyResponsesView({super.key});

  @override
  State<MyResponsesView> createState() => _MyResponsesViewState();
}

class _MyResponsesViewState extends State<MyResponsesView> {
  final DevisController controller = Get.find<DevisController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMyResponses();
    });
  }

  Future<void> _loadMyResponses() async {
    await controller.loadAssignedDevis();
  }

  // Couleurs de statut selon le nouveau design system
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Mes Réponses',
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
                      'Chargement de vos réponses...',
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
                        Icons.chat_bubble_outline,
                        size: 40,
                        color: const Color(0xFFffd60a).withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucune réponse envoyée',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vous n\'avez pas encore répondu à des devis',
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
              onRefresh: () async => _loadMyResponses(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: ListView.builder(
                  itemCount: controller.devisList.length,
                  itemBuilder: (context, index) {
                    final devis = controller.devisList[index];
                    return _buildResponseCard(devis);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResponseCard(dynamic devis) {
    String formattedStatus = _formatStatus(devis.status);
    Color statusColor = _getStatusColor(devis.status);

    final authController = Get.find<AuthController>();
    final response = _findResponseForTechnician(
      devis.responses,
      authController.currentUser?.id,
    );

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
            child: InkWell(
              onTap: () async {
                final controller = Get.find<DevisController>();
                final myResponse = await controller.getMyResponseForDevis(
                  devis.id,
                );

                if (myResponse != null) {
                  Get.toNamed(
                    AppRoutes.technicianResponseDetail,
                    arguments: {
                      'devisId': devis.id,
                      'responseId': myResponse.id,
                    },
                  );
                } else {
                  Get.toNamed(
                    AppRoutes.technicianDevisDetail,
                    arguments: devis.id,
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),
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
                              fontSize: 18,
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
                              fontSize: 13,
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
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Objectif: ${_formatObjectif(devis.objectif)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          devis.date != null
                              ? '${devis.date!.day}/${devis.date!.month}/${devis.date!.year}'
                              : 'Date non spécifiée',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Indicateur "Réponse envoyée" - only show if the current technician has responded
                    if (response != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(
                              0xFF00ff88,
                            ).withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: const Text(
                          '✓ Réponse envoyée',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00ff88),
                          ),
                        ),
                      ),

                    // Détails de la réponse
                    if (response != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromRGBO(255, 255, 255, 0.06),
                                  Color.fromRGBO(255, 255, 255, 0.02),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(
                                  0xFF00d4ff,
                                ).withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ma Réponse:',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF00d4ff),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (response.commentaire != null &&
                                    response.commentaire!.isNotEmpty)
                                  Text(
                                    'Commentaire: ${response.commentaire}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  'Prix Total: ${response.prixTotal != null ? '${response.prixTotal!.toStringAsFixed(2)} €' : 'Non spécifié'}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Statut: ${_formatResponseStatus(response.statut ?? '')}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Composants: ${(response.composants ?? response.components)?.length ?? 0}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper methods (inchangés, sauf couleurs si nécessaire) ---

  DevisResponseModel? _findResponseForTechnician(
    List<DevisResponseModel>? responses,
    int? technicianId,
  ) {
    if (responses == null || technicianId == null) return null;
    for (final response in responses) {
      if (response.technicianId == technicianId) return response;
    }
    return null;
  }

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

  String _formatResponseStatus(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'accepted':
        return 'Accepté';
      case 'rejected':
        return 'Refusé';
      case 'in_progress':
        return 'En cours';
      case 'completed':
        return 'Complété';
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
