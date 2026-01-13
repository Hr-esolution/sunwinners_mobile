import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/devis_controller.dart';
import '../../../controllers/composant_controller.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/composant_model.dart';

class RespondToDevisView extends StatefulWidget {
  final int devisId;

  const RespondToDevisView({Key? key, required this.devisId}) : super(key: key);

  @override
  State<RespondToDevisView> createState() => _RespondToDevisViewState();
}

class _RespondToDevisViewState extends State<RespondToDevisView> {
  final AuthController authController = Get.find<AuthController>();
  final DevisController devisController = Get.find<DevisController>();
  final ComposantController composantController =
      Get.find<ComposantController>();
  final _commentController = TextEditingController();
  final Map<int, int> _selectedComposants = {};
  List<ComposantModel> _composants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    bool isAuthenticated = await authController.checkAuthStatus();
    if (!isAuthenticated) {
      Get.offAllNamed('/login');
      return;
    }
    _loadComposants();
  }

  Future<void> _loadComposants() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration.zero);
    await composantController.loadComposants();

    if (mounted) {
      Timer(Duration.zero, () {
        if (mounted) {
          setState(() {
            _composants = List.from(composantController.composantList);
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _updateQuantity(int composantId, int quantity) {
    if (quantity > 0) {
      _selectedComposants[composantId] = quantity;
    } else {
      _selectedComposants.remove(composantId);
    }
    setState(() {});
  }

  Future<void> _addNewComposant() async {
    // Show the enhanced component creation popup
    final TextEditingController nameController = TextEditingController();
    final TextEditingController referenceController = TextEditingController();
    final TextEditingController unitPriceController = TextEditingController();
    final TextEditingController manufacturerController = TextEditingController();
    final TextEditingController warrantyPeriodController = TextEditingController();
    final TextEditingController certificationsController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1a1f2e),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: const Color(0xFFffd60a).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nouveau Composant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nom du composant
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer un nom pour le composant';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration(
                      labelText: 'Nom du composant *',
                      icon: Icons.label_outlined,
                      hintText: 'Entrez le nom du composant',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Référence
                  TextFormField(
                    controller: referenceController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration(
                      labelText: 'Référence',
                      icon: Icons.tag_outlined,
                      hintText: 'Entrez la référence (optionnel)',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Prix unitaire
                  TextFormField(
                    controller: unitPriceController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer un prix unitaire';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Veuillez entrer un prix valide';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration(
                      labelText: 'Prix unitaire (€) *',
                      icon: Icons.euro_outlined,
                      hintText: 'Entrez le prix unitaire',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fabricant
                  TextFormField(
                    controller: manufacturerController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration(
                      labelText: 'Fabricant',
                      icon: Icons.business_outlined,
                      hintText: 'Entrez le fabricant (optionnel)',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Garantie
                  TextFormField(
                    controller: warrantyPeriodController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration(
                      labelText: 'Période de garantie (mois)',
                      icon: Icons.shield_outlined,
                      hintText: 'Entrez la période de garantie en mois (optionnel)',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Certifications
                  TextFormField(
                    controller: certificationsController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration(
                      labelText: 'Certifications',
                      icon: Icons.verified_outlined,
                      hintText: 'Entrez les certifications (optionnel)',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Boutons d'action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            color: const Color(0xFFff6b6b),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [const Color(0xFFffd60a), const Color(0xFFffc300)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                double unitPrice = double.parse(unitPriceController.text.trim());

                                final newComposant = {
                                  'name': nameController.text.trim(),
                                  'reference': referenceController.text.trim().isNotEmpty
                                      ? referenceController.text.trim()
                                      : null,
                                  'unit_price': unitPrice,
                                  'manufacturer': manufacturerController.text.trim().isNotEmpty
                                      ? manufacturerController.text.trim()
                                      : null,
                                  'warranty_period': warrantyPeriodController.text.trim().isNotEmpty
                                      ? int.tryParse(warrantyPeriodController.text.trim())
                                      : null,
                                  'certifications': certificationsController.text.trim().isNotEmpty
                                      ? certificationsController.text.trim()
                                      : null,
                                };

                                await composantController.createComposantFromData(newComposant);

                                await _loadComposants();

                                Get.snackbar(
                                  'Succès',
                                  'Composant ajouté avec succès',
                                  backgroundColor: const Color(0xFF00ff88),
                                  colorText: Colors.white,
                                );

                                Navigator.of(context).pop();
                              } catch (e) {
                                Get.snackbar(
                                  'Erreur',
                                  'Échec de l\'ajout du composant: ${e.toString()}',
                                  backgroundColor: const Color(0xFFff6b6b),
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
                          child: Text(
                            'Créer le composant',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1a1f2e),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData icon,
    required String hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFFffd60a).withOpacity(0.6),
        size: 20,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.1),
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
    );
  }

  Future<void> _submitResponse() async {
    if (_selectedComposants.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner au moins un composant',
        backgroundColor: const Color(0xFFff6b6b),
        colorText: Colors.white,
      );
      return;
    }

    final responseData = {
      'commentaire': _commentController.text.trim(),
      'composants': _selectedComposants.entries
          .map((entry) => {'id': entry.key, 'quantity': entry.value})
          .toList(),
    };

    await devisController.respondToDevis(widget.devisId, responseData);

    if (!mounted) return;

    Timer(Duration.zero, () {
      if (mounted) {
        Get.offAllNamed(AppRoutes.technicianDevisList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Répondre au Devis',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFffd60a).withValues(alpha: 0.15),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFFffd60a),
                size: 20,
              ),
            ),
          ),
        ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Devis info header
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFffd60a).withValues(alpha: 0.12),
                            const Color(0xFFffc300).withValues(alpha: 0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(
                            0xFFffd60a,
                          ).withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFffd60a,
                            ).withValues(alpha: 0.1),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFffd60a),
                                      Color(0xFFffc300),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.assignment_outlined,
                                  color: Color(0xFF0f1419),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Devis #${widget.devisId}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFffd60a),
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Sélectionnez les composants',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Comment section
                Text(
                  'Commentaire (optionnel)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.9),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _commentController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Ajoutez un commentaire pour le client...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFffd60a),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),

                const SizedBox(height: 24),

                // Available composants header
                Text(
                  'Composants Disponibles',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.9),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 12),

                // Composants list
                _isLoading
                    ? Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
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
                            const SizedBox(height: 16),
                            Text(
                              'Chargement des composants...',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _composants.isEmpty
                    ? Stack(
                        children: [
                          Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(
                                      0xFFffd60a,
                                    ).withValues(alpha: 0.1),
                                  ),
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    size: 40,
                                    color: const Color(
                                      0xFFffd60a,
                                    ).withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucun composant disponible',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Ajoutez des composants pour répondre',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: FloatingActionButton(
                              onPressed: () => _addNewComposant(),
                              backgroundColor: const Color(0xFFffd60a),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF0f1419),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _composants.length,
                        itemBuilder: (context, index) {
                          final composant = _composants[index];
                          final isSelected = _selectedComposants.containsKey(
                            composant.id,
                          );
                          final quantity =
                              _selectedComposants[composant.id] ?? 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withValues(alpha: 0.08),
                                        Colors.white.withValues(alpha: 0.03),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFffd60a,
                                      ).withValues(alpha: 0.2),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFffd60a,
                                        ).withValues(alpha: 0.1),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    composant.name,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                      letterSpacing: 0.2,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  if (composant.reference !=
                                                          null &&
                                                      composant
                                                          .reference!
                                                          .isNotEmpty)
                                                    Text(
                                                      'Réf: ${composant.reference}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.5,
                                                            ),
                                                      ),
                                                    ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Prix: ${composant.unitPrice.toStringAsFixed(2)} €',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color(0xFF00ff88),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (isSelected) {
                                                      _updateQuantity(
                                                        composant.id,
                                                        0,
                                                      );
                                                    } else {
                                                      _updateQuantity(
                                                        composant.id,
                                                        1,
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: isSelected
                                                          ? const Color(
                                                              0xFFffd60a,
                                                            )
                                                          : Colors.white
                                                                .withValues(
                                                                  alpha: 0.1,
                                                                ),
                                                    ),
                                                    child: Icon(
                                                      isSelected
                                                          ? Icons.check_rounded
                                                          : Icons.add_rounded,
                                                      color: isSelected
                                                          ? const Color(
                                                              0xFF0f1419,
                                                            )
                                                          : const Color(
                                                              0xFFffd60a,
                                                            ),
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (isSelected) ...[
                                          const SizedBox(height: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFFffd60a,
                                              ).withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: const Color(
                                                  0xFFffd60a,
                                                ).withValues(alpha: 0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    int newQuantity =
                                                        quantity - 1;
                                                    if (newQuantity <= 0) {
                                                      _updateQuantity(
                                                        composant.id,
                                                        0,
                                                      );
                                                    } else {
                                                      _updateQuantity(
                                                        composant.id,
                                                        newQuantity,
                                                      );
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.remove_rounded,
                                                    size: 18,
                                                    color: const Color(
                                                      0xFFffd60a,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  quantity.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFFffd60a),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                GestureDetector(
                                                  onTap: () {
                                                    _updateQuantity(
                                                      composant.id,
                                                      quantity + 1,
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.add_rounded,
                                                    size: 18,
                                                    color: const Color(
                                                      0xFFffd60a,
                                                    ),
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
                          );
                        },
                      ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0f1419),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFffd60a), Color(0xFFffc300)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFffd60a).withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _submitResponse,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Envoyer la Réponse',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0f1419),
                      letterSpacing: 0.5,
                    ),
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
