import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/devis_controller.dart';
import '../../../core/constants/app_routes.dart';

class TechnicianDevisListView extends StatefulWidget {
  const TechnicianDevisListView({super.key});

  @override
  State<TechnicianDevisListView> createState() =>
      _TechnicianDevisListViewState();
}

class _TechnicianDevisListViewState extends State<TechnicianDevisListView> {
  final AuthController authController = Get.find<AuthController>();
  late final DevisController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<DevisController>();

    // Check authentication status before proceeding
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    bool isAuthenticated = await authController.checkAuthStatus();
    if (!isAuthenticated) {
      Get.offAllNamed('/login');
      return;
    }

    // Load technician-specific devis
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTechnicianDevis();
    });
  }

  void _loadTechnicianDevis() async {
    await controller
        .loadDevisForTechnician(); // Load only assigned devis for technician
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Devis Assignés',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFffd60a).withValues(alpha: 0.15),
                const Color(0xFFffc300).withValues(alpha: 0.08),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1a1f2e),
              const Color(0xFF0f1419),
              const Color(0xFF051628),
            ],
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
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFffd60a), Color(0xFFffc300)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFffd60a,
                            ).withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
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
                    const SizedBox(height: 24),
                    Text(
                      'Chargement des devis assignés...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 0.3,
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
                        Icons.assignment_ind_outlined,
                        size: 40,
                        color: const Color(0xFFffd60a).withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucun devis assigné',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les devis qui vous sont assignés',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      'apparaîtront ici',
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
              onRefresh: () async => _loadTechnicianDevis(),
              color: const Color(0xFFffd60a),
              backgroundColor: const Color(0xFF1a1f2e),
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
    );
  }

  Widget _buildDevisCard(devis) {
    String formattedStatus = _formatStatus(devis.status);
    Color statusColor = _getStatusColor(devis.status);

    bool canRespond =
        devis.status == 'en_cours_de_traitement' ||
        devis.status == 'en_attente_confirmation_technicien';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFffd60a).withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFffd60a).withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  if (devis.status == 'repondu_par_technicien') {
                    final response = await controller.getMyResponseForDevis(
                      devis.id,
                    );
                    if (response != null) {
                      controller.navigateToResponseDetail(
                        devis.id,
                        responseId: response.id,
                      );
                    } else {
                      Get.toNamed(
                        AppRoutes.technicianDevisDetail,
                        arguments: devis.id,
                      );
                    }
                  } else {
                    Get.toNamed(
                      AppRoutes.technicianDevisDetail,
                      arguments: devis.id,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                                letterSpacing: 0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
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
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDevisInfo(
                        icon: Icons.assignment_outlined,
                        label: 'Type',
                        value: _formatTypeDemande(devis.typeDemande),
                      ),
                      const SizedBox(height: 8),
                      _buildDevisInfo(
                        icon: Icons.traffic_rounded,
                        label: 'Objectif',
                        value: _formatObjectif(devis.objectif),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: const Color(
                              0xFFffd60a,
                            ).withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            devis.date != null
                                ? '${devis.date!.day}/${devis.date!.month}/${devis.date!.year}'
                                : 'Date non spécifiée',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      if (canRespond) ...[
                        const SizedBox(height: 12),
                        _buildActionButton(
                          onPressed: () {
                            Get.toNamed(
                              AppRoutes.technicianRespondToDevis,
                              arguments: devis.id,
                            );
                          },
                          icon: Icons.send_outlined,
                          label: 'Répondre',
                          color: const Color(0xFFffd60a),
                        ),
                      ] else if (devis.status == 'repondu_par_technicien') ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF00ff88).withValues(alpha: 0.2),
                                const Color(0xFF00ff88).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(
                                0xFF00ff88,
                              ).withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outlined,
                                color: const Color(
                                  0xFF00ff88,
                                ).withValues(alpha: 0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Réponse soumise',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(
                                    0xFF00ff88,
                                  ).withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
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
          ),
        ),
      ),
    );
  }

  Widget _buildDevisInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: const Color(0xFFffd60a).withValues(alpha: 0.6),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.3),
                color.withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 16, color: color),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'en_cours_de_traitement':
        return const Color(0xFF00d4ff); // Cyan
      case 'en_attente_confirmation_technicien':
        return const Color(0xFFffd60a); // Gold
      case 'repondu_par_technicien':
        return const Color(0xFF00ff88); // Green
      case 'accepte_par_client':
        return const Color(0xFF00ff88); // Green
      case 'refuse_par_client':
        return const Color(0xFFff6b6b); // Red
      default:
        return const Color(0xFF95A5A6); // Grey
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
