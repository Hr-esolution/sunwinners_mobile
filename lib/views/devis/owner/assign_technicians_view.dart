import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/controllers/devis_controller.dart';
import 'package:sunwinners/controllers/user_controller.dart';
import 'package:sunwinners/widgets/sunwinners_app_bar.dart';

class AssignTechniciansPage extends StatefulWidget {
  final int devisId;

  const AssignTechniciansPage({super.key, required this.devisId});

  @override
  State<AssignTechniciansPage> createState() => _AssignTechniciansPageState();
}

class _AssignTechniciansPageState extends State<AssignTechniciansPage> {
  final DevisController devisController = Get.find<DevisController>();
  final UserController userController = Get.find<UserController>();

  final RxList<int> selectedTechnicians = <int>[].obs;
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();

    // Use Timer to delay the loading calls to avoid setState during build
    _loadingTimer = Timer(Duration(milliseconds: 100), () {
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
        title: 'Assigner des Techniciens',
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
        child: GetBuilder<UserController>(
          builder: (userCtrl) {
            if (userCtrl.isLoading) {
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
                      'Chargement des techniciens...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            final technicians = userCtrl.technicians;

            // Debug logging
            print("DEBUG: Total technicians loaded: ${technicians.length}");
            for (int i = 0; i < technicians.length; i++) {
              final tech = technicians[i];
              print(
                "DEBUG: Technician[$i] - Name: ${tech.name}, Role: ${tech.role}",
              );
              print(
                "DEBUG: Technician[$i] - Has technician obj: ${tech.technician != null}",
              );
              if (tech.technician != null) {
                print(
                  "DEBUG: Technician[$i] - Tech ID: ${tech.technician?.id}, Company: ${tech.technician?.companyName}",
                );
              }
            }

            if (technicians.isEmpty) {
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
                        Icons.engineering,
                        size: 40,
                        color: const Color(0xFFffd60a).withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucun technicien disponible',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les techniciens apparaîtront ici',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Selected technicians counter
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(255, 255, 255, 0.08),
                                Color.fromRGBO(255, 255, 255, 0.03),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(
                                0xFFffd60a,
                              ).withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "${selectedTechnicians.length} technicien(s) sélectionné(s)",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                // Technician list
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: technicians.length,
                      itemBuilder: (context, index) {
                        final technician = technicians[index];
                        print(
                          "DEBUG: Building technician at index $index: ${technician.name}, role: ${technician.role}",
                        );

                        // Check if this user is actually a technician
                        if (technician.role != 'technician') {
                          print(
                            "DEBUG: Skipping user ${technician.name} - not a technician, role: ${technician.role}",
                          );
                          return const SizedBox.shrink();
                        }

                        // Try to get technician data from the nested technician object
                        var techObj = technician.technician;

                        // If the technician object exists and has an ID, use it
                        if (techObj != null) {
                          print(
                            // ignore: unnecessary_null_comparison
                            "DEBUG: Technician[${technician.name}] - Has technician obj: ${techObj != null}",
                          );

                          final techId = techObj.id;
                          final companyName =
                              techObj.companyName ?? "Entreprise inconnue";
                          print(
                            "DEBUG: Technician[${technician.name}] - ID: $techId, Company: $companyName",
                          );

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
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
                                      color: const Color(
                                        0xFFffd60a,
                                      ).withValues(alpha: 0.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Obx(
                                    () => CheckboxListTile(
                                      secondary: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFFffd60a),
                                              Color(0xFFffc300),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFffd60a,
                                              ).withValues(alpha: 0.3),
                                              spreadRadius: 1,
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: ClipOval(
                                          child:
                                              techObj.logo != null &&
                                                  techObj.logo!.isNotEmpty
                                              ? Image.network(
                                                  techObj.logo!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return const Icon(
                                                          Icons.business,
                                                          size: 20,
                                                          color: Color(
                                                            0xFF0f1419,
                                                          ),
                                                        );
                                                      },
                                                )
                                              : const Icon(
                                                  Icons.business,
                                                  size: 20,
                                                  color: Color(0xFF0f1419),
                                                ),
                                        ),
                                      ),
                                      title: Text(
                                        technician.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        companyName,
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                      value: selectedTechnicians.contains(
                                        techId,
                                      ),
                                      onChanged: (value) {
                                        if (value == true) {
                                          selectedTechnicians.add(techId);
                                        } else {
                                          selectedTechnicians.remove(techId);
                                        }
                                      },
                                      activeColor: const Color(0xFFffd60a),
                                      checkColor: const Color(0xFF0f1419),
                                      tileColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          // If the technician object is null or doesn't have an ID,
                          // we need to determine if we should use the user ID as the technician ID
                          // This depends on how the API expects the IDs to be structured
                          print(
                            "DEBUG: Technician[${technician.name}] - Main technician obj is null or missing ID, checking alternatives",
                          );

                          // Based on the API response, we need to use the actual technician ID
                          // If we don't have the technician object, we might need to fetch it separately
                          // For now, let's try to use the user ID as the technician ID as a fallback
                          final techId = technician
                              .id; // Use user ID as technician ID (fallback)
                          final companyName =
                              "Company inconnue"; // Default value

                          print(
                            "DEBUG: Technician[${technician.name}] - Using user ID as tech ID (fallback): $techId",
                          );

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
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
                                      color: const Color(
                                        0xFFffd60a,
                                      ).withValues(alpha: 0.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Obx(
                                    () => CheckboxListTile(
                                      secondary: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFFffd60a),
                                              Color(0xFFffc300),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFffd60a,
                                              ).withValues(alpha: 0.3),
                                              spreadRadius: 1,
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          size: 20,
                                          color: Color(0xFF0f1419),
                                        ),
                                      ),
                                      title: Text(
                                        technician.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        companyName,
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                      value: selectedTechnicians.contains(
                                        techId,
                                      ),
                                      onChanged: (value) {
                                        if (value == true) {
                                          selectedTechnicians.add(techId);
                                        } else {
                                          selectedTechnicians.remove(techId);
                                        }
                                      },
                                      activeColor: const Color(0xFFffd60a),
                                      checkColor: const Color(0xFF0f1419),
                                      tileColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }),
                ),

                // Assign button
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Obx(() {
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
                        onTap: selectedTechnicians.isEmpty
                            ? null
                            : () async {
                                await _assignTechnicians();
                              },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.assignment_ind,
                                size: 20,
                                color: Color(0xFF1a1f2e),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Assigner les techniciens',
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
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _assignTechnicians() async {
    try {
      // Show loading indicator
      Get.snackbar(
        "En cours...",
        "Assignation des techniciens en cours...",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF00d4ff),
        colorText: Colors.white,
      );

      print(
        "DEBUG: Attempting to assign technicians: ${selectedTechnicians.toList()} to devis: ${widget.devisId}",
      );

      await devisController.assignTechnicians(
        widget.devisId,
        selectedTechnicians.toList(),
      );

      Get.snackbar(
        "Succès",
        "Techniciens assignés avec succès",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF00ff88),
        colorText: Colors.white,
      );

      // Go back to the devis list page after successful assignment
      Get.offAllNamed(
        '/owner/devis',
      ); // Navigate back to the devis list to see the updated status
    } catch (e) {
      print("DEBUG: Error assigning technicians: $e");
      Get.snackbar(
        "Erreur",
        "Échec de l'assignation des techniciens: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
