import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/composant_controller.dart';
import 'composant_detail_view.dart';

class ComposantListView extends StatelessWidget {
  const ComposantListView({super.key});

  @override
  Widget build(BuildContext context) {
    final ComposantController controller = Get.find<ComposantController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: AppBar(
        title: const Text(
          'Mes Composants',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFffd60a)),
        actions: const [],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1f2e), Color(0xFF0f1419), Color(0xFF051628)],
          ),
        ),
        child: Obx(() {
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
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0f1419)),
                  strokeWidth: 3,
                ),
              ),
            );
          }

          if (controller.composantList.isEmpty) {
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
                      Icons.inventory_2_outlined,
                      size: 40,
                      color: const Color(0xFFffd60a).withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Aucun composant trouvé',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Commencez par ajouter votre premier composant',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: controller.composantList.length,
            itemBuilder: (context, index) {
              final composant = controller.composantList[index];
              return _buildComposantCard(composant);
            },
          );
        }),
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
            Get.toNamed('/composant/create');
          },
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF1a1f2e),
          heroTag: 'composant_list_fab',
          elevation: 0,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildComposantCard(dynamic composant) {
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
                  final controller = Get.find<ComposantController>();
                  controller.selectComposant(composant);
                  Get.to(() => ComposantDetailView(composantId: composant.id));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFffd60a).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(
                              0xFFffd60a,
                            ).withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: const Color(0xFFffd60a),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              composant.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            if (composant.reference != null &&
                                composant.reference!.isNotEmpty)
                              Text(
                                'Référence: ${composant.reference}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                            const SizedBox(height: 2),
                            Text(
                              'Prix unitaire: ${composant.unitPrice.toStringAsFixed(2)} €',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(
                                  0xFF00ff88,
                                ), // Vert fluo pour le prix
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.5),
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
}
