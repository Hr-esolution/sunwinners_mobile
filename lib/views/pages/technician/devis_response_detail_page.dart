import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../../../controllers/devis_controller.dart';
import '../../../data/models/devis_response_model.dart';
import '../../../widgets/sunwinners_app_bar.dart';

class DevisResponseDetailPage extends StatefulWidget {
  const DevisResponseDetailPage({super.key});

  @override
  State<DevisResponseDetailPage> createState() =>
      _DevisResponseDetailPageState();
}

class _DevisResponseDetailPageState extends State<DevisResponseDetailPage> {
  final DevisController devisController = Get.find<DevisController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int devisId = 0;
      if (Get.arguments is Map<String, dynamic>) {
        Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
        devisId = args['devisId'] ?? 0;
      } else if (Get.arguments is List) {
        List args = Get.arguments as List;
        devisId = args.isNotEmpty ? (args[0] as int?) ?? 0 : 0;
      }

      if (devisId != 0) {
        devisController.loadTechnicianResponseDetails(devisId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Détails de la Réponse',
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
          builder: (controller) {
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
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF0f1419),
                    ),
                    strokeWidth: 3,
                  ),
                ),
              );
            }

            final response = controller.currentResponse;
            if (response == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFffd60a).withAlpha(200),
                      ),
                      child: Icon(
                        Icons.sentiment_dissatisfied,
                        size: 40,
                        color: const Color(0xFFffd60a).withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucune réponse trouvée',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vous n\'avez pas encore répondu à ce devis',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.5),
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
                  // Résumé de la réponse
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Résumé de la Réponse',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Statut',
                          _formatStatus(response.statut ?? ''),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'Prix Total',
                          response.prixTotal != null
                              ? '${response.prixTotal!.toStringAsFixed(2)} €'
                              : 'Non spécifié',
                        ),
                        if (response.commentaire != null &&
                            response.commentaire!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Commentaire:',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            response.commentaire!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Composants sous forme de tableau facture
                  if ((response.composants != null &&
                          response.composants!.isNotEmpty) ||
                      (response.components != null &&
                          response.components!.isNotEmpty))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Composants Utilisés',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildComponentsTable(response),
                      ],
                    )
                  else
                    _buildGlassCard(
                      child: Text(
                        'Aucun composant spécifié dans cette réponse',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.5),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
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
              color: const Color(0xFFffd60a).withAlpha(200),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFffd60a).withAlpha(200),
                blurRadius: 12,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
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
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withAlpha(200),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // ✨ Tableau facture moderne pour les composants
  Widget _buildComponentsTable(DevisResponseModel response) {
    final components = response.composants ?? response.components ?? [];
    if (components.isEmpty) return const SizedBox();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 0.06),
                Color.fromRGBO(255, 255, 255, 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFffd60a).withAlpha(200),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              // En-tête
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(200),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Composant',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Qté',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'P.U.',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Total',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Lignes
              ...components.map((comp) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          comp.composantName ??
                              'Composant #${comp.composantId}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withAlpha(200),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          comp.quantity.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${comp.unitPrice.toStringAsFixed(2)} €',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${comp.totalPrice.toStringAsFixed(2)} €',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _formatStatus(String status) {
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
      case 'repondu':
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
}
