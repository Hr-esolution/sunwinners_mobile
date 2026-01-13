import 'client_model.dart';
import 'technician_model.dart';
import 'owner_model.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String role; // 'client', 'technician', 'owner'
  final bool approved;
  final ClientModel? client;
  final TechnicianModel? technician;
  final OwnerModel? owner;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.approved,
    this.client,
    this.technician,
    this.owner,
    this.createdAt,
    this.updatedAt,
  });

  /// FROM JSON (Laravel → Flutter)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle the case where profile data is in a 'profile' field instead of role-specific fields
    ClientModel? clientData;
    TechnicianModel? technicianData;
    OwnerModel? ownerData;

    // Check if profile data is in the 'profile' field (alternative structure)
    if (json['profile'] != null && json['profile'] is Map<String, dynamic>) {
      Map<String, dynamic> profileData = json['profile'];
      String role = json['role'] ?? '';

      switch (role) {
        case 'client':
          clientData = ClientModel(
            id: profileData['id'] ?? 0,
            userId: json['id'] ?? 0,
            address: profileData['address'],
            phone: profileData['phone'],
            createdAt: profileData['created_at'] != null
                ? DateTime.parse(profileData['created_at'])
                : null,
            updatedAt: profileData['updated_at'] != null
                ? DateTime.parse(profileData['updated_at'])
                : null,
          );
          break;
        case 'technician':
          technicianData = TechnicianModel(
            id: profileData['id'] ?? 0,
            userId: json['id'] ?? 0,
            certificates: profileData['certificates'],
            experience: profileData['experience'],
            companyName: profileData['company_name'],
            address: profileData['address'],
            phone: profileData['phone'],
            logo: profileData['logo'],
            createdAt: profileData['created_at'] != null
                ? DateTime.parse(profileData['created_at'])
                : null,
            updatedAt: profileData['updated_at'] != null
                ? DateTime.parse(profileData['updated_at'])
                : null,
          );
          break;
        case 'owner':
          ownerData = OwnerModel(
            id: profileData['id'] ?? 0,
            userId: json['id'] ?? 0,
            companyName: profileData['company_name'],
            licenseStatus: profileData['license_status'],
            createdAt: profileData['created_at'] != null
                ? DateTime.parse(profileData['created_at'])
                : null,
            updatedAt: profileData['updated_at'] != null
                ? DateTime.parse(profileData['updated_at'])
                : null,
          );
          break;
      }
    }

    // Default behavior: check for role-specific fields
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      approved: json['approved'] == true || json['approved'] == 1,
      client: json['client'] != null
          ? ClientModel.fromJson(json['client'])
          : clientData, // Use profile data if client field is not present
      technician: json['technician'] != null
          ? TechnicianModel.fromJson(json['technician'])
          : technicianData, // Use profile data if technician field is not present
      owner: json['owner'] != null
          ? OwnerModel.fromJson(json['owner'])
          : ownerData, // Use profile data if owner field is not present
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// TO JSON (Flutter → API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'approved': approved,
      'client': client?.toJson(),
      'technician': technician?.toJson(),
      'owner': owner?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Helpers
  bool get isClient => role == 'client';
  bool get isTechnician => role == 'technician';
  bool get isOwner => role == 'owner';
}