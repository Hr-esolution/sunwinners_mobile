class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final dynamic profile; // Role-specific data

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profile,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      profile: _parseProfileData(json['profile'], json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profile': _profileToJson(profile),
    };
  }

  static dynamic _parseProfileData(dynamic profileData, String role) {
    if (profileData == null) return null;

    switch (role) {
      case 'client':
        return ClientProfile.fromJson(profileData as Map<String, dynamic>);
      case 'technician':
        return TechnicianProfile.fromJson(profileData as Map<String, dynamic>);
      case 'owner':
        return OwnerProfile.fromJson(profileData as Map<String, dynamic>);
      default:
        return profileData;
    }
  }

  static dynamic _profileToJson(dynamic profile) {
    if (profile == null) return null;

    if (profile is ClientProfile) {
      return profile.toJson();
    } else if (profile is TechnicianProfile) {
      return profile.toJson();
    } else if (profile is OwnerProfile) {
      return profile.toJson();
    }

    return profile;
  }

  // Helper methods to check role
  bool get isClient => role == 'client';
  bool get isTechnician => role == 'technician';
  bool get isOwner => role == 'owner';

  // Helper methods to access role-specific data
  ClientProfile? get clientProfile =>
      isClient ? profile as ClientProfile? : null;
  TechnicianProfile? get technicianProfile =>
      isTechnician ? profile as TechnicianProfile? : null;
  OwnerProfile? get ownerProfile => isOwner ? profile as OwnerProfile? : null;
}

class ClientProfile {
  final String? address;
  final String? phone;

  ClientProfile({this.address, this.phone});

  factory ClientProfile.fromJson(Map<String, dynamic> json) {
    return ClientProfile(address: json['address'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {'address': address, 'phone': phone};
  }
}

class TechnicianProfile {
  final String? certificates;
  final String? experience;
  final String? companyName;
  final String? address;
  final String? phone;
  final String? logo;

  TechnicianProfile({
    this.certificates,
    this.experience,
    this.companyName,
    this.address,
    this.phone,
    this.logo,
  });

  factory TechnicianProfile.fromJson(Map<String, dynamic> json) {
    return TechnicianProfile(
      certificates: json['certificates'],
      experience: json['experience'],
      companyName: json['company_name'],
      address: json['address'],
      phone: json['phone'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificates': certificates,
      'experience': experience,
      'company_name': companyName,
      'address': address,
      'phone': phone,
      'logo': logo,
    };
  }
}

class OwnerProfile {
  final String? companyName;
  final String? licenseStatus;

  OwnerProfile({this.companyName, this.licenseStatus});

  factory OwnerProfile.fromJson(Map<String, dynamic> json) {
    return OwnerProfile(
      companyName: json['company_name'],
      licenseStatus: json['license_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'company_name': companyName, 'license_status': licenseStatus};
  }
}
