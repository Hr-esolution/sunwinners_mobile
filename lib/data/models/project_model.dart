import 'technician_model.dart';
import 'devis_model.dart';
import 'subvention_model.dart';

class ProjectModel {
  final int id;
  final int devisId;
  final int technicianId;
  final String status; // d_accord, en_cours, termine
  final bool? isActive;
  final String? contratSignedFile;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DevisModel? devis;
  final TechnicianModel? technician;
  final SubventionModel? subvention;

  ProjectModel({
    required this.id,
    required this.devisId,
    required this.technicianId,
    required this.status,
    this.isActive,
    this.contratSignedFile,
    this.createdAt,
    this.updatedAt,
    this.devis,
    this.technician,
    this.subvention,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? 0,
      devisId: json['devis_id'] ?? 0,
      technicianId: json['technician_id'] ?? 0,
      status: json['status'] ?? 'd_accord',
      isActive: json['is_active'],
      contratSignedFile: json['contrat_signed_file'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      devis: json['devis'] != null ? DevisModel.fromJson(json['devis']) : null,
      technician: json['technician'] != null
          ? TechnicianModel.fromJson(json['technician'])
          : null,
      subvention: json['subvention'] != null
          ? SubventionModel.fromJson(json['subvention'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'devis_id': devisId,
      'technician_id': technicianId,
      'status': status,
      'is_active': isActive,
      'contrat_signed_file': contratSignedFile,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'devis': devis?.toJson(),
      'technician': technician?.toJson(),
      'subvention': subvention?.toJson(),
    };
  }
}
