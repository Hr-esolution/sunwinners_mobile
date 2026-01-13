import 'dart:io';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunwinners/core/constants/app_constants.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/devis_controller.dart';
import '../../widgets/sunwinners_app_bar.dart';

class DevisCreateView extends StatefulWidget {
  const DevisCreateView({super.key});

  @override
  State<DevisCreateView> createState() => _DevisCreateViewState();
}

class _DevisCreateViewState extends State<DevisCreateView> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();

  // Controllers
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _toitController = TextEditingController();
  final TextEditingController _debitController = TextEditingController();
  final TextEditingController _profondeurController = TextEditingController();
  final TextEditingController _capaciteController = TextEditingController();

  // Observables
  final RxString _typeDemandeur = 'personne'.obs;
  final RxString _typeDemande = 'nouvelle_installation'.obs;
  final RxString _objectif = 'reduction_consommation'.obs;
  final RxString _typeInstallation = 'autoconsommation_injection_surplus'.obs;
  final RxString _typeUtilisation = 'domestique'.obs;
  final RxBool showPompageOptions = false.obs;
  final RxString _typePompe = ''.obs;
  final RxList<String> _selectedImages = <String>[].obs;

  DevisController? controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _checkAuthentication();
  }

  void _initializeController() {
    controller = Get.find<DevisController>();
  }

  Future<void> _checkAuthentication() async {
    bool isAuthenticated = await authController.checkAuthStatus();
    if (!isAuthenticated) {
      Get.offAllNamed('/login');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: SunwinnersAppBar(
        title: 'Créer un Devis',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF00ff88), Color(0xFF00cc66)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00ff88).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nouveau Devis',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0f1419),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Veuillez remplir les informations de votre projet',
                            style: TextStyle(
                              fontSize: 13,
                              color: const Color(0xFF0f1419).withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Type Demandeur
                _buildSectionTitle('Type de Demandeur'),
                const SizedBox(height: 6),
                _buildCardContainer(
                  child: Obx(
                    () => SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'personne',
                          label: Text('Personne'),
                        ),
                        ButtonSegment(value: 'societe', label: Text('Société')),
                      ],
                      selected: {_typeDemandeur.value},
                      onSelectionChanged: (Set<String> newSelection) {
                        _typeDemandeur.value = newSelection.first;
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return const Color(0xFFffd60a);
                            }
                            return Colors.white.withOpacity(0.05);
                          },
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return const Color(0xFF1a1f2e);
                            }
                            return Colors.black;
                          },
                        ),
                        side: WidgetStateProperty.all(
                          BorderSide(
                            color: const Color(0xFFffd60a).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Type de Demande
                _buildSectionTitle('Type de Demande'),
                const SizedBox(height: 6),
                _buildCardContainer(
                  child: Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          [
                                'nouvelle_installation',
                                'extension_mise_a_niveau',
                                'entretien_reparation',
                              ]
                              .map(
                                (type) => _buildStyledChip(
                                  label: type.replaceAll('_', ' '),
                                  isSelected: _typeDemande.value == type,
                                  onSelected: (_) => _typeDemande.value = type,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Objectif
                _buildSectionTitle('Objectif'),
                const SizedBox(height: 6),
                _buildCardContainer(
                  child: Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          [
                                'reduction_consommation',
                                'stockage_energie',
                                'extension_future_prevue',
                              ]
                              .map(
                                (obj) => _buildStyledChip(
                                  label: obj.replaceAll('_', ' '),
                                  isSelected: _objectif.value == obj,
                                  onSelected: (_) => _objectif.value = obj,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Type d'Installation
                _buildSectionTitle('Type d\'Installation'),
                const SizedBox(height: 6),
                _buildCardContainer(
                  child: Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          [
                                'autoconsommation_injection_surplus',
                                'autoconsommation_sans_injection',
                                'installation_autonome_offgrid',
                                'pompage_solaire',
                              ]
                              .map(
                                (type) => _buildStyledChip(
                                  label: type.replaceAll('_', ' '),
                                  isSelected: _typeInstallation.value == type,
                                  onSelected: (_) {
                                    _typeInstallation.value = type;
                                    showPompageOptions.value =
                                        type == 'pompage_solaire';
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Type d'Utilisation
                _buildSectionTitle('Type d\'Utilisation'),
                const SizedBox(height: 6),
                _buildCardContainer(
                  child: Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['domestique', 'industriel', 'agricole']
                          .map(
                            (type) => _buildStyledChip(
                              label: type,
                              isSelected: _typeUtilisation.value == type,
                              onSelected: (_) => _typeUtilisation.value = type,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Pompage Options (conditionnel)
                Obx(
                  () => showPompageOptions.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Type de Pompe'),
                            const SizedBox(height: 6),
                            _buildCardContainer(
                              child: Obx(
                                () => SegmentedButton<String>(
                                  segments: const [
                                    ButtonSegment(
                                      value: 'surface',
                                      label: Text('Surface'),
                                    ),
                                    ButtonSegment(
                                      value: 'immergee',
                                      label: Text('Immergée'),
                                    ),
                                  ],
                                  selected: {_typePompe.value},
                                  onSelectionChanged:
                                      (Set<String> newSelection) {
                                        _typePompe.value = newSelection.first;
                                      },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith<Color>((
                                          Set<WidgetState> states,
                                        ) {
                                          if (states.contains(
                                            WidgetState.selected,
                                          )) {
                                            return const Color(0xFFffd60a);
                                          }
                                          return Colors.white.withOpacity(0.05);
                                        }),
                                    foregroundColor:
                                        WidgetStateProperty.resolveWith<Color>((
                                          Set<WidgetState> states,
                                        ) {
                                          if (states.contains(
                                            WidgetState.selected,
                                          )) {
                                            return const Color(0xFF1a1f2e);
                                          }
                                          return Colors.black;
                                        }),
                                    side: WidgetStateProperty.all(
                                      BorderSide(
                                        color: const Color(
                                          0xFFffd60a,
                                        ).withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildTextFormField(
                              controller: _debitController,
                              labelText: 'Débit Estimé (m³/h)',
                              icon: Icons.speed_rounded,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (showPompageOptions.value &&
                                    (value == null || value.isEmpty)) {
                                  return 'Débit estimé requis pour pompage solaire';
                                }
                                if (value != null && value.isNotEmpty) {
                                  final number = double.tryParse(value);
                                  if (number == null || number <= 0) {
                                    return 'Veuillez entrer un nombre valide';
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildTextFormField(
                              controller: _profondeurController,
                              labelText: 'Profondeur du Forage (m)',
                              icon: Icons.height_rounded,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (showPompageOptions.value &&
                                    (value == null || value.isEmpty)) {
                                  return 'Profondeur requise pour pompage solaire';
                                }
                                if (value != null && value.isNotEmpty) {
                                  final number = int.tryParse(value);
                                  if (number == null || number <= 0) {
                                    return 'Veuillez entrer un nombre valide';
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildTextFormField(
                              controller: _capaciteController,
                              labelText: 'Capacité du Réservoir (L)',
                              icon: Icons.water_rounded,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (showPompageOptions.value &&
                                    (value == null || value.isEmpty)) {
                                  return 'Capacité requise pour pompage solaire';
                                }
                                if (value != null && value.isNotEmpty) {
                                  final number = int.tryParse(value);
                                  if (number == null || number <= 0) {
                                    return 'Veuillez entrer un nombre valide';
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      : const SizedBox(),
                ),

                // Adresse et Toit
                _buildTextFormField(
                  controller: _toitController,
                  labelText: 'Toit d\'Installation (si applicable)',
                  icon: Icons.roofing_rounded,
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: _adresseController,
                  labelText: 'Adresse Complète *',
                  icon: Icons.location_on_rounded,
                  hintText: 'Entrez l\'adresse complète',
                  maxLines: 2,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Adresse requise' : null,
                ),
                const SizedBox(height: 16),

                // Images Section
                _buildSectionTitle('Images du Projet'),
                const SizedBox(height: 6),
                _buildCardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ajouter des images de votre projet (facultatif)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => _selectedImages.isEmpty
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(
                                      0xFFffd60a,
                                    ).withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white.withOpacity(0.05),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 48,
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Aucune image sélectionnée',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedImages.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child:
                                                _selectedImages[index]
                                                    .startsWith('http')
                                                ? Image.network(
                                                    _selectedImages[index],
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Container(
                                                            width: 100,
                                                            height: 100,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                  0.2,
                                                                ),
                                                            child: Icon(
                                                              Icons
                                                                  .broken_image,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                    0.3,
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                  )
                                                : Image.file(
                                                    File(
                                                      _selectedImages[index],
                                                    ),
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Container(
                                                            width: 100,
                                                            height: 100,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                  0.2,
                                                                ),
                                                            child: Icon(
                                                              Icons
                                                                  .broken_image,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                    0.3,
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                  ),
                                          ),
                                          Positioned(
                                            top: 2,
                                            right: 2,
                                            child: GestureDetector(
                                              onTap: () {
                                                _selectedImages.removeAt(index);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFff6b6b,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _selectImages,
                          icon: Icon(
                            Icons.add_photo_alternate,
                            color: Colors.white,
                          ),
                          label: Text('Ajouter des Images'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFffd60a),
                            foregroundColor: const Color(0xFF1a1f2e),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Submit Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFffd60a), Color(0xFFffc300)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFffd60a).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller?.isLoading == true
                          ? null
                          : _submitDevis,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide.none,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: controller?.isLoading == true
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Soumettre le Devis',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1a1f2e),
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget: Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0.3,
      ),
    );
  }

  // Helper widget: Card Container
  Widget _buildCardContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFffd60a).withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Padding(padding: const EdgeInsets.all(14), child: child),
        ),
      ),
    );
  }

  // Helper widget: Styled Chip
  Widget _buildStyledChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF1a1f2e) : Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.white.withOpacity(isSelected ? 0.2 : 0.05),
      selectedColor: const Color(0xFFffd60a),
      checkmarkColor: const Color(0xFF1a1f2e),
      side: BorderSide(
        color: isSelected
            ? const Color(0xFFffd60a)
            : const Color(0xFFffd60a).withOpacity(0.2),
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Helper widget: Text Form Field
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        prefixIcon: Icon(icon, color: const Color(0xFFffd60a)),
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFffd60a), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFff6b6b), width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFff6b6b), width: 2),
        ),
      ),
      validator: validator,
    );
  }

  // === TOUTE LA LOGIQUE MÉTIER EST PRÉSERVÉE CI-DESSOUS ===


  void _selectImages() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      _selectedImages.add(image.path);
    }
  }

  void _submitDevis() async {
    if (_formKey.currentState!.validate() && controller != null) {
      controller!.setLoading(true);
      try {
        final Map<String, dynamic> devisData = {
          'type_demandeur': _typeDemandeur.value,
          'date': DateTime.now().toIso8601String(), // Add required date field
          'type_demande': _typeDemande.value,
          'objectif': _objectif.value,
          'type_installation': _typeInstallation.value,
          'type_utilisation': _typeUtilisation.value,
          'adresse_complete': _adresseController.text.trim(),
          'toit_installation': _toitController.text.trim(),
          'type_pompe': _typePompe.value.isNotEmpty ? _typePompe.value : null,
          'debit_estime': _debitController.text.isNotEmpty
              ? double.tryParse(_debitController.text)
              : null,
          'profondeur_forage': _profondeurController.text.isNotEmpty
              ? int.tryParse(_profondeurController.text)
              : null,
          'capacite_reservoir': _capaciteController.text.isNotEmpty
              ? int.tryParse(_capaciteController.text)
              : null,
        };

        if (_selectedImages.isNotEmpty) {
          // Pass the image file paths directly to be sent as multipart data
          List<String> imagePaths = [];
          for (String imagePath in _selectedImages) {
            if (!imagePath.startsWith('http')) {
              imagePaths.add(imagePath);
            }
          }
          if (imagePaths.isNotEmpty) {
            devisData['images'] = imagePaths;
          }
        }

        await controller!.createDevis(devisData);
      } catch (e) {
        Get.snackbar(
          'Erreur',
          'Une erreur est survenue lors de la création du devis',
        );
      } finally {
        controller!.setLoading(false);
      }
    }
  }

  @override
  void dispose() {
    _adresseController.dispose();
    _toitController.dispose();
    _debitController.dispose();
    _profondeurController.dispose();
    _capaciteController.dispose();
    super.dispose();
  }
}
