import 'dart:convert';

import 'user_model.dart';
import 'technician_model.dart';
import 'devis_response_model.dart';

class DevisModel {
  final int id;
  final int userId;
  final String typeDemandeur;
  final DateTime? date;
  final String reference;
  final String status;
  final String typeDemande;
  final String objectif;
  final String typeInstallation;
  final String? typeUtilisation;
  final String? typePompe;
  final double? debitEstime;
  final int? profondeurForage;
  final int? capaciteReservoir;
  final String? adresseComplete;
  final String? toitInstallation;
  final List<String>? images;
  final int? technicianId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final UserModel? user;
  final List<TechnicianModel>? technicians;
  final List<DevisResponseModel>? responses;

  DevisModel({
    required this.id,
    required this.userId,
    required this.typeDemandeur,
    this.date,
    required this.reference,
    required this.status,
    required this.typeDemande,
    required this.objectif,
    required this.typeInstallation,
    this.typeUtilisation,
    this.typePompe,
    this.debitEstime,
    this.profondeurForage,
    this.capaciteReservoir,
    this.adresseComplete,
    this.toitInstallation,
    this.images,
    this.technicianId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.technicians,
    this.responses,
  });

  factory DevisModel.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    List<String>? parseImages(dynamic value) {
      if (value == null) return null;
      if (value is List) return List<String>.from(value);
      if (value is String && value.isNotEmpty) {
        try {
          return List<String>.from(jsonDecode(value));
        } catch (_) {
          return null;
        }
      }
      return null;
    }

    return DevisModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      typeDemandeur: json['type_demandeur'] ?? '',
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      reference: json['reference'] ?? '',
      status: json['status'] ?? '',
      typeDemande: json['type_demande'] ?? '',
      objectif: json['objectif'] ?? '',
      typeInstallation: json['type_installation'] ?? '',
      typeUtilisation: json['type_utilisation'],
      typePompe: json['type_pompe'],
      debitEstime: parseDouble(json['debit_estime']),
      profondeurForage: json['profondeur_forage'],
      capaciteReservoir: json['capacite_reservoir'],
      adresseComplete: json['adresse_complete'],
      toitInstallation: json['toit_installation'],
      images: parseImages(json['images']),
      technicianId: json['technician_id'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      technicians: json['technicians'] != null
          ? (json['technicians'] as List)
                .map((e) => TechnicianModel.fromJson(e))
                .toList()
          : null,
      responses: json['responses'] != null
          ? (json['responses'] as List)
                .map((e) => DevisResponseModel.fromJson(e))
                .toList()
          : null,
    );
  }

  String get clientName => user?.name ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type_demandeur': typeDemandeur,
      'date': date?.toIso8601String(),
      'reference': reference,
      'status': status,
      'type_demande': typeDemande,
      'objectif': objectif,
      'type_installation': typeInstallation,
      'type_utilisation': typeUtilisation,
      'type_pompe': typePompe,
      'debit_estime': debitEstime,
      'profondeur_forage': profondeurForage,
      'capacite_reservoir': capaciteReservoir,
      'adresse_complete': adresseComplete,
      'toit_installation': toitInstallation,
      'images': images != null ? jsonEncode(images) : null,
      'technician_id': technicianId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),

      // Relations
      'user': user?.toJson(),
      'technicians': technicians?.map((t) => t.toJson()).toList(),
      'responses': responses?.map((r) => r.toJson()).toList(),
    };
  }
}
