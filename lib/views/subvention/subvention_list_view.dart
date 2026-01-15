import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/subvention_controller.dart';
import '../../data/models/subvention_model.dart';
import '../../widgets/sunwinners_app_bar.dart';

class SubventionListView extends StatelessWidget {
  const SubventionListView({super.key});

  @override
  Widget build(BuildContext context) {
    final SubventionController controller = Get.put(
      SubventionController(subventionRepo: Get.find()),
    );

    // Load subventions when the view is first built
    controller.loadMySubventions();

    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Subventions',
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
                        'Chargement des subventions...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                )
              : controller.subventionList.isEmpty
              ? Center(
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
                        'Aucune subvention trouvée',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Les subventions apparaîtront ici',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                )
              : _buildSubventionList(controller.subventionList),
        ),
      ),
    );
  }

  Widget _buildSubventionList(List<SubventionModel> subventionList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: ListView.builder(
        itemCount: subventionList.length,
        itemBuilder: (context, index) {
          final subvention = subventionList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: ClipRRect(
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
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(
                        '/subvention/detail',
                        arguments: subvention.id,
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  subvention.statut ?? 'en_attente',
                                ).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getStatusColor(
                                    subvention.statut ?? 'en_attente',
                                  ).withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                _getStatusIcon(
                                  subvention.statut ?? 'en_attente',
                                ),
                                color: _getStatusColor(
                                  subvention.statut ?? 'en_attente',
                                ),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                subvention.nomProjet ??
                                    'Subvention #${subvention.id}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: const Color(0xFF2ECC71),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          subvention.typeProjet ?? 'N/A',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person_rounded,
                              size: 16,
                              color: const Color(0xFF2ECC71),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              subvention.nom ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2ECC71),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.info_rounded,
                              size: 16,
                              color: const Color(0xFF2ECC71),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Statut: ${subvention.statut ?? 'en_attente'}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
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
          );
        },
      ),
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
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'en_attente':
        return Icons.pending_actions_rounded;
      case 'confirmee':
        return Icons.check_circle_rounded;
      case 'refusee':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}
