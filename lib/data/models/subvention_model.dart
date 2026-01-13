import 'project_model.dart';

class SubventionModel {
  final int id;
  final int? projectId;
  final String? nomProjet;
  final String? typeProjet; // Solaire, Eolien
  final String? nom;
  final String? adresse;
  final String? telephone;
  final String? representant;
  final String? email;
  final String? secteur;
  final String? typeEntreprise;
  final String? tailleEntreprise;
  final String? descriptionProjet;
  final String? adresseProjet;
  final DateTime? dateDebut;
  final List<String>? eligibilite; // JSON array
  final String? signataireNom;
  final String? signataireFonction;
  final String? signataireSignature;
  final String? signataireLieuDate;
  final String? statut; // en_attente, confirmee, refusee
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProjectModel? project;

  SubventionModel({
    required this.id,
    this.projectId,
    this.nomProjet,
    this.typeProjet,
    this.nom,
    this.adresse,
    this.telephone,
    this.representant,
    this.email,
    this.secteur,
    this.typeEntreprise,
    this.tailleEntreprise,
    this.descriptionProjet,
    this.adresseProjet,
    this.dateDebut,
    this.eligibilite,
    this.signataireNom,
    this.signataireFonction,
    this.signataireSignature,
    this.signataireLieuDate,
    this.statut,
    this.createdAt,
    this.updatedAt,
    this.project,
  });

  factory SubventionModel.fromJson(Map<String, dynamic> json) {
    return SubventionModel(
      id: json['id'] ?? 0,
      projectId: json['project_id'],
      nomProjet: json['nom_projet'],
      typeProjet: json['type_projet'],
      nom: json['nom'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      representant: json['representant'],
      email: json['email'],
      secteur: json['secteur'],
      typeEntreprise: json['type_entreprise'],
      tailleEntreprise: json['taille_entreprise'],
      descriptionProjet: json['description_projet'],
      adresseProjet: json['adresse_projet'],
      dateDebut: json['date_debut'] != null
          ? DateTime.parse(json['date_debut'])
          : null,
      eligibilite: json['eligibilite'] != null ? List<String>.from(json['eligibilite']) : null,
      signataireNom: json['signataire_nom'],
      signataireFonction: json['signataire_fonction'],
      signataireSignature: json['signataire_signature'],
      signataireLieuDate: json['signataire_lieu_date'],
      statut: json['statut'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      project: json['project'] != null ? ProjectModel.fromJson(json['project']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'nom_projet': nomProjet,
      'type_projet': typeProjet,
      'nom': nom,
      'adresse': adresse,
      'telephone': telephone,
      'representant': representant,
      'email': email,
      'secteur': secteur,
      'type_entreprise': typeEntreprise,
      'taille_entreprise': tailleEntreprise,
      'description_projet': descriptionProjet,
      'adresse_projet': adresseProjet,
      'date_debut': dateDebut?.toIso8601String(),
      'eligibilite': eligibilite,
      'signataire_nom': signataireNom,
      'signataire_fonction': signataireFonction,
      'signataire_signature': signataireSignature,
      'signataire_lieu_date': signataireLieuDate,
      'statut': statut,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'project': project?.toJson(),
    };
  }
}