import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunwinners/controllers/project_controller.dart';
import 'package:sunwinners/data/models/devis_response_model.dart';

class ProjectCreateView extends StatefulWidget {
  final int devisId;
  final int? technicianId;
  final DevisResponseModel? selectedResponse;

  const ProjectCreateView({
    super.key,
    required this.devisId,
    this.technicianId,
    this.selectedResponse,
  });

  @override
  State<ProjectCreateView> createState() => _ProjectCreateViewState();
}

class _ProjectCreateViewState extends State<ProjectCreateView> {
  final ProjectController controller = Get.find<ProjectController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contratController = TextEditingController();

  @override
  void dispose() {
    _contratController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un Projet'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Création du Projet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Devis Information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informations du Devis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('ID du Devis: ${widget.devisId}'),
                      if (widget.selectedResponse != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Prix Total: ${widget.selectedResponse!.prixTotal?.toStringAsFixed(2)} €',
                        ),
                        const SizedBox(height: 10),
                        if (widget.selectedResponse!.commentaire != null)
                          Text(
                            'Commentaire: ${widget.selectedResponse!.commentaire}',
                          ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Technician Selection (if not provided)
              if (widget.technicianId == null) ...[
                const Text(
                  'Sélectionnez le Technicien',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // This would be a dropdown or list of technicians
                // For now, we'll assume the technician is selected elsewhere
                const Text(
                  'Le technicien est sélectionné automatiquement à partir de la réponse du devis',
                ),
                const SizedBox(height: 20),
              ],

              // Contract File Upload
              const Text(
                'Fichier de Contrat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _contratController,
                decoration: const InputDecoration(
                  labelText: 'Lien du fichier de contrat (optionnel)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // Optional field, so no validation needed
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Créer le Projet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Prepare project data
    final projectData = {
      'devis_id': widget.devisId,
      'technician_id':
          widget.technicianId ?? widget.selectedResponse?.technicianId,
      'status': 'd_accord', // Initial status
      'is_active': false, // Initially not active
      if (_contratController.text.isNotEmpty)
        'contrat_signed_file': _contratController.text,
    };

    await controller.createProjectFromDevis(projectData);
  }
}
