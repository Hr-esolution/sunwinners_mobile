import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/composant_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../data/models/composant_model.dart';

class ComposantFormView extends StatefulWidget {
  final ComposantModel? composant;
  final int? composantId;
  final bool isEditing;

  const ComposantFormView({
    super.key,
    this.composant,
    this.composantId,
    this.isEditing = false,
  });

  @override
  State<ComposantFormView> createState() => _ComposantFormViewState();
}

class _ComposantFormViewState extends State<ComposantFormView> {
  final ComposantController controller = Get.find<ComposantController>();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _referenceController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _warrantyPeriodController = TextEditingController();
  final _certificationsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      if (widget.composant != null) {
        _populateFields(widget.composant!);
      } else if (widget.composantId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fetchAndPopulateComposant();
        });
      }
    }
  }

  void _populateFields(ComposantModel composant) {
    _nameController.text = composant.name;
    _referenceController.text = composant.reference ?? '';
    _unitPriceController.text = composant.unitPrice.toString();
    _manufacturerController.text = composant.manufacturer ?? '';
    _warrantyPeriodController.text = composant.warrantyPeriod?.toString() ?? '';
    _certificationsController.text = composant.certifications ?? '';
  }

  Future<void> _fetchAndPopulateComposant() async {
    final composantId = widget.composantId ?? Get.arguments as int?;
    if (composantId != null) {
      await controller.loadComposantById(composantId);
      if (controller.selectedComposant != null) {
        _populateFields(controller.selectedComposant!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _referenceController.dispose();
    _unitPriceController.dispose();
    _manufacturerController.dispose();
    _warrantyPeriodController.dispose();
    _certificationsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final authController = Get.find<AuthController>();
      int technicianId = 0;

      if (authController.userRole == 'technician') {
        final currentUser = authController.currentUser;
        if (currentUser != null &&
            currentUser.isTechnician &&
            currentUser.technician != null &&
            currentUser.technician!.id != 0) {
          technicianId = currentUser.technician!.id;
        } else {
          authController.loadUserProfile();
          final updatedUser = authController.currentUser;
          if (updatedUser != null &&
              updatedUser.isTechnician &&
              updatedUser.technician != null &&
              updatedUser.technician!.id != 0) {
            technicianId = updatedUser.technician!.id;
          } else {
            technicianId = currentUser?.id ?? 0;
          }
        }
      } else if (authController.userRole == 'admin') {
        technicianId = widget.composant?.technicianId ?? 0;
      }

      final composant = ComposantModel(
        id: widget.isEditing ? widget.composant!.id : 0,
        name: _nameController.text.trim(),
        reference: _referenceController.text.trim().isEmpty
            ? null
            : _referenceController.text.trim(),
        unitPrice: double.tryParse(_unitPriceController.text) ?? 0.0,
        technicianId: widget.isEditing
            ? widget.composant!.technicianId
            : technicianId,
        manufacturer: _manufacturerController.text.trim().isEmpty
            ? null
            : _manufacturerController.text.trim(),
        warrantyPeriod: _warrantyPeriodController.text.trim().isEmpty
            ? null
            : int.tryParse(_warrantyPeriodController.text),
        certifications: _certificationsController.text.trim().isEmpty
            ? null
            : _certificationsController.text.trim(),
        createdAt: widget.isEditing
            ? widget.composant!.createdAt
            : DateTime.now(),
        updatedAt: DateTime.now(),
        technician: widget.composant?.technician,
        devis: widget.composant?.devis,
      );

      if (widget.isEditing) {
        controller.updateComposant(composant);
      } else {
        controller.createComposant(composant);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1419),
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Modifier le Composant' : 'Nouveau Composant',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFFffd60a)),
          onPressed: () => Get.back(),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFffd60a)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1f2e), Color(0xFF0f1419), Color(0xFF051628)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Nom du composant
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer un nom pour le composant';
                      }
                      return null;
                    },
                    decoration: _buildInputDecoration(
                      labelText: 'Nom du composant *',
                      icon: Icons.label_outlined,
                      hintText: 'Entrez le nom du composant',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Référence
                  TextFormField(
                    controller: _referenceController,
                    decoration: _buildInputDecoration(
                      labelText: 'Référence',
                      icon: Icons.tag_outlined,
                      hintText: 'Entrez la référence (optionnel)',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Prix unitaire
                  TextFormField(
                    controller: _unitPriceController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer un prix unitaire';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Veuillez entrer un prix valide';
                      }
                      return null;
                    },
                    decoration: _buildInputDecoration(
                      labelText: 'Prix unitaire (€) *',
                      icon: Icons.euro_outlined,
                      hintText: 'Entrez le prix unitaire',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fabricant
                  TextFormField(
                    controller: _manufacturerController,
                    decoration: _buildInputDecoration(
                      labelText: 'Fabricant',
                      icon: Icons.business_outlined,
                      hintText: 'Entrez le fabricant (optionnel)',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Garantie
                  TextFormField(
                    controller: _warrantyPeriodController,
                    keyboardType: TextInputType.number,
                    decoration: _buildInputDecoration(
                      labelText: 'Période de garantie (mois)',
                      icon: Icons.shield_outlined,
                      hintText:
                          'Entrez la période de garantie en mois (optionnel)',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Certifications
                  TextFormField(
                    controller: _certificationsController,
                    decoration: _buildInputDecoration(
                      labelText: 'Certifications',
                      icon: Icons.verified_outlined,
                      hintText: 'Entrez les certifications (optionnel)',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bouton de soumission
                  Container(
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
                      onTap: _submitForm,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            widget.isEditing
                                ? 'Mettre à jour'
                                : 'Créer le composant',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1a1f2e),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData icon,
    required String hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.white, fontSize: 18),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white, fontSize: 18),
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
}
