class TechnicianModel {
  final int id;
  final int userId;
  final String? name; // Added name field to handle cases where user data is included
  final String? certificates;
  final String? experience;
  final String? companyName;
  final String? address;
  final String? phone;
  final String? logo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TechnicianModel({
    required this.id,
    required this.userId,
    this.name,
    this.certificates,
    this.experience,
    this.companyName,
    this.address,
    this.phone,
    this.logo,
    this.createdAt,
    this.updatedAt,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    return TechnicianModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? json['user']?['name'], // Handle both direct name and nested user.name
      certificates: json['certificates'],
      experience: json['experience'],
      companyName: json['company_name'],
      address: json['address'],
      phone: json['phone'],
      logo: json['logo'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'certificates': certificates,
      'experience': experience,
      'company_name': companyName,
      'address': address,
      'phone': phone,
      'logo': logo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}