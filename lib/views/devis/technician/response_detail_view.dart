import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/devis_controller.dart';
import '../../../data/models/devis_response_model.dart';
import '../../../widgets/sunwinners_app_bar.dart';

class ResponseDetailView extends StatefulWidget {
  final int devisId;
  final int? responseId;

  const ResponseDetailView({super.key, required this.devisId, this.responseId});

  @override
  State<ResponseDetailView> createState() => _ResponseDetailViewState();
}

class _ResponseDetailViewState extends State<ResponseDetailView> {
  final DevisController devisController = Get.find<DevisController>();
  final AuthController authController = Get.find<AuthController>();
  DevisResponseModel? response;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print('ResponseDetailView initState appelé');
    print('Devis ID: ${widget.devisId}');
    print('Response ID: ${widget.responseId}');
    _loadResponse();
  }

  void _loadResponse() async {
    try {
      print('Chargement de la réponse pour devis ID: ${widget.devisId}');
      print('Recherche de la réponse avec ID: ${widget.responseId}');

      // Charger la réponse spécifique du technicien pour ce devis
      // Peu importe si un responseId est fourni ou non, on utilise la même méthode
      // car la route backend nous donne la réponse spécifique
      final myResponse = await devisController.getMyResponseForDevis(
        widget.devisId,
      );

      if (myResponse != null) {
        print('Réponse trouvée avec ID: ${myResponse.id}');
        setState(() {
          response = myResponse;
          isLoading = false;
        });
      } else {
        print('Aucune réponse trouvée pour ce technicien pour ce devis');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading response: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: SunwinnersAppBar(
          title: 'Détails de la Réponse',
          backgroundColor: const Color(0xFFFFA500),
          foregroundColor: Colors.white,
          elevation: 0,
          iconColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1a1a2e).withValues(alpha: 0.95),
                const Color(0xFF16213e).withValues(alpha: 0.95),
                const Color(0xFF0f3460).withValues(alpha: 0.95),
              ],
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFFA500),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: SunwinnersAppBar(
        title: 'Détails de la Réponse',
        backgroundColor: const Color(0xFFFFA500),
        foregroundColor: Colors.white,
        elevation: 0,
        iconColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e).withValues(alpha: 0.95),
              const Color(0xFF16213e).withValues(alpha: 0.95),
              const Color(0xFF0f3460).withValues(alpha: 0.95),
            ],
          ),
        ),
        child: response == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune réponse trouvée',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.8),
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
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Résumé de la réponse
                    _buildGlassmorphicContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Résumé de la Réponse',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            'Statut',
                            _formatStatus(response!.statut ?? ''),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Prix Total',
                            response!.prixTotal != null
                                ? '${response!.prixTotal!.toStringAsFixed(2)} €'
                                : 'Non spécifié',
                          ),
                          const SizedBox(height: 8),
                          if (response!.commentaire != null &&
                              response!.commentaire!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Commentaire: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    response!.commentaire!,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Composants de la réponse
                    if ((response!.composants != null &&
                            response!.composants!.isNotEmpty) ||
                        (response!.components != null &&
                            response!.components!.isNotEmpty)) ...[
                      Text(
                        'Composants Utilisés',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...((response!.composants ?? response!.components) ?? [])
                          .map((component) => _buildComponentCard(component)),
                    ] else ...[
                      _buildGlassmorphicContainer(
                        child: Text(
                          'Aucun composant spécifié dans cette réponse',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildGlassmorphicContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFFFFF).withValues(alpha: 0.1),
                const Color(0xFFFFFFFF).withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFA500).withValues(alpha: 0.15),
                spreadRadius: 2,
                blurRadius: 12,
                offset: const Offset(0, 4),
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
          flex: 3,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 0.3,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComponentCard(DevisResponseComponent component) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFFFFF).withValues(alpha: 0.1),
                  const Color(0xFFFFFFFF).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFA500).withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFA500).withValues(alpha: 0.2),
                        const Color(0xFFFFD700).withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFFFA500).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    component.composantName ??
                        'Composant #${component.composantId}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Quantité', component.quantity.toString()),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Prix unitaire',
                  '${component.unitPrice.toStringAsFixed(2)} €',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Prix total',
                  '${component.totalPrice.toStringAsFixed(2)} €',
                ),
              ],
            ),
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
      default:
        return status
            .split('_')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }
}
