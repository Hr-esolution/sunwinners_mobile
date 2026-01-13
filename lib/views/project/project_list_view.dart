import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/project_controller.dart';
import '../../data/models/project_model.dart';
import '../../widgets/sunwinners_app_bar.dart';

class ProjectListView extends StatelessWidget {
  const ProjectListView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectController controller = Get.put(
      ProjectController(projectRepo: Get.find()),
    );

    controller.loadMyProjects();

    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Projets',
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
                )
              : controller.projectList.isEmpty
              ? Center(
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
                          Icons.work_outline,
                          size: 40,
                          color: const Color(0xFFffd60a).withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Aucun projet trouvé',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : _buildProjectList(controller.projectList),
        ),
      ),
    );
  }

  Widget _buildProjectList(List<ProjectModel> projectList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ListView.builder(
        itemCount: projectList.length,
        itemBuilder: (context, index) {
          final project = projectList[index];
          return _buildProjectCard(project);
        },
      ),
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
    final statusColor = _getStatusColor(project.status);
    final statusIcon = _getStatusIcon(project.status);

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
                color: const Color(0xFFffd60a).withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFffd60a).withOpacity(0.1),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.toNamed('/project/detail', arguments: project.id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: statusColor.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              statusIcon,
                              color: statusColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Projet #${project.id}',
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
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _formatStatus(project.status),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: const Color(0xFF00ff88),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            project.isActive == true ? 'Actif' : 'Inactif',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.work_rounded,
                            size: 16,
                            color: const Color(0xFF00d4ff),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              project.contratSignedFile ?? 'Aucun contrat',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13,
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
        ),
      ),
    );
  }

  // === Couleurs sémantiques Sunwinners ===
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'd_accord':
        return const Color(0xFFffd60a); // En attente → Gold
      case 'en_cours':
        return const Color(0xFF00d4ff); // En cours → Cyan
      case 'termine':
        return const Color(0xFF00ff88); // Terminé → Vert fluo
      default:
        return const Color(0xFF95A5A6); // Neutre → Gris
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'd_accord':
        return Icons.pending_actions_rounded;
      case 'en_cours':
        return Icons.work_rounded;
      case 'termine':
        return Icons.check_circle_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'd_accord':
        return 'D\'accord';
      case 'en_cours':
        return 'En cours';
      case 'termine':
        return 'Terminé';
      default:
        return status;
    }
  }
}
