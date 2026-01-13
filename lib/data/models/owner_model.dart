class OwnerModel {
  final int id;
  final int userId;
  final String? companyName;
  final bool? licenseStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OwnerModel({
    required this.id,
    required this.userId,
    this.companyName,
    this.licenseStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      companyName: json['company_name'],
      licenseStatus: json['license_status'],
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
      'company_name': companyName,
      'license_status': licenseStatus,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}