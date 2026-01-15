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

      final currentUser = authController.currentUser;

      if (authController.userRole == 'technician') {
        technicianId = currentUser?.technician?.id ?? currentUser?.id ?? 0;
      } else if (authController.userRole == 'admin') {
        technicianId =
            widget.composant?.technicianId ??
            controller.selectedComposant?.technicianId ??
            0;
      }

      final composantId = widget.isEditing
          ? widget.composant?.id ?? controller.selectedComposant?.id ?? 0
          : 0;

      final composant = ComposantModel(
        id: composantId,
        name: _nameController.text.trim(),
        reference: _referenceController.text.trim().isEmpty
            ? null
            : _referenceController.text.trim(),
        unitPrice: double.tryParse(_unitPriceController.text) ?? 0.0,
        technicianId: technicianId,
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
            ? widget.composant?.createdAt ??
                  controller.selectedComposant?.createdAt ??
                  DateTime.now()
            : DateTime.now(),
        updatedAt: DateTime.now(),
        technician:
            widget.composant?.technician ??
            controller.selectedComposant?.technician,
        devis: widget.composant?.devis ?? controller.selectedComposant?.devis,
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
                  _buildTextField(
                    controller: _nameController,
                    label: 'Nom du composant *',
                    icon: Icons.label_outlined,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Veuillez entrer un nom'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _referenceController,
                    label: 'Référence',
                    icon: Icons.tag_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _unitPriceController,
                    label: 'Prix unitaire (€) *',
                    icon: Icons.euro_outlined,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Veuillez entrer un prix';
                      if (double.tryParse(v) == null) return 'Prix invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _manufacturerController,
                    label: 'Fabricant',
                    icon: Icons.business_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _warrantyPeriodController,
                    label: 'Période de garantie (mois)',
                    icon: Icons.shield_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _certificationsController,
                    label: 'Certifications',
                    icon: Icons.verified_outlined,
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: _submitForm,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFffd60a), Color(0xFFffc300)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFffd60a),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFffd60a).withValues(alpha: 0.6),
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
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFFffd60a), width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFFff6b6b), width: 2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFFff6b6b), width: 2),
        ),
      ),
    );
  }
}
