import 'package:get/get.dart';
import 'package:sunwinners/core/network/api_client.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  final ApiClient apiClient;

  ProfileRepository({required this.apiClient});

  Future<Response> getProfile() async {
    return await apiClient.getData('/profile');
  }

  Future<Response> updateProfile(ProfileModel profileModel) async {
    // Convert the ProfileModel to the format expected by the Laravel API
    final profileData = _prepareProfileDataForApi(profileModel);
    return await apiClient.putData('/profile', profileData);
  }

  Future<Response> changePassword(Map<String, dynamic> passwordData) async {
    return await apiClient.postData('/change-password', passwordData);
  }

  Future<Response> uploadAvatar(String filePath) async {
    // This would require multipart form data handling
    // Implementation depends on the specific API endpoint
    return await apiClient.postData('/profile/avatar', {'avatar': filePath});
  }

  /// Prepares profile data in the format expected by the Laravel API
  Map<String, dynamic> _prepareProfileDataForApi(ProfileModel profileModel) {
    final data = <String, dynamic>{};

    // Add role-specific fields based on user role
    switch (profileModel.role) {
      case 'client':
        if (profileModel.clientProfile != null) {
          final clientProfile = profileModel.clientProfile!;
          if (clientProfile.address != null) data['address'] = clientProfile.address;
          if (clientProfile.phone != null) data['phone'] = clientProfile.phone;
        }
        break;
      case 'technician':
        if (profileModel.technicianProfile != null) {
          final technicianProfile = profileModel.technicianProfile!;
          if (technicianProfile.certificates != null) data['certificates'] = technicianProfile.certificates;
          if (technicianProfile.experience != null) data['experience'] = technicianProfile.experience;
          if (technicianProfile.companyName != null) data['company_name'] = technicianProfile.companyName;
          if (technicianProfile.address != null) data['address'] = technicianProfile.address;
          if (technicianProfile.phone != null) data['phone'] = technicianProfile.phone;
        }
        break;
      case 'owner':
        if (profileModel.ownerProfile != null) {
          final ownerProfile = profileModel.ownerProfile!;
          if (ownerProfile.companyName != null) data['company_name'] = ownerProfile.companyName;
          if (ownerProfile.licenseStatus != null) data['license_status'] = ownerProfile.licenseStatus;
        }
        break;
    }

    return data;
  }
}
