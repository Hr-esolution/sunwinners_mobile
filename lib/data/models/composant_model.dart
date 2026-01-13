import 'technician_model.dart';
import 'devis_model.dart';

class ComposantModel {
  final int id;
  final String name;
  final String? reference;
  final double unitPrice;
  final int technicianId;
  final String? manufacturer;
  final int? warrantyPeriod;
  final String? certifications;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TechnicianModel? technician;
  final List<DevisModel>? devis;

  ComposantModel({
    required this.id,
    required this.name,
    this.reference,
    required this.unitPrice,
    required this.technicianId,
    this.manufacturer,
    this.warrantyPeriod,
    this.certifications,
    this.createdAt,
    this.updatedAt,
    this.technician,
    this.devis,
  });

  factory ComposantModel.fromJson(Map<String, dynamic> json) {
    return ComposantModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      reference: json['reference'],
      unitPrice: (json['unit_price'] != null)
          ? (json['unit_price'] is String)
              ? double.tryParse(json['unit_price']) ?? 0.0
              : (json['unit_price'] as num).toDouble()
          : 0.0,
      technicianId: json['technician_id'] ?? 0,
      manufacturer: json['manufacturer'],
      warrantyPeriod: json['warranty_period'],
      certifications: json['certifications'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      technician: json['technician'] != null 
          ? TechnicianModel.fromJson(json['technician']) 
          : null,
      devis: json['devis'] != null
          ? (json['devis'] as List)
              .map((item) => DevisModel.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'reference': reference,
      'unit_price': unitPrice,
      'technician_id': technicianId,
      'manufacturer': manufacturer,
      'warranty_period': warrantyPeriod,
      'certifications': certifications,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'technician': technician?.toJson(),
      'devis': devis?.map((d) => d.toJson()).toList(),
    };
  }
}
