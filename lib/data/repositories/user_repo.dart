import 'package:get/get.dart';
import 'package:sunwinners/core/network/api_client.dart';

class UserRepository {
  final ApiClient apiClient;

  UserRepository({required this.apiClient});

  /// Get all technicians (for owner/admin)
  Future<Response> getAllTechnicians() async {
    return await apiClient.getData('/owner/technicians');
  }

  /// Get all clients (for owner/admin)
  Future<Response> getAllClients() async {
    return await apiClient.getData('/owner/clients');
  }

  /// Approve a technician (for owner/admin)
  Future<Response> approveTechnician(int technicianId) async {
    return await apiClient.postData('/owner/technicians/$technicianId/approve', {});
  }

  /// Reject a technician (for owner/admin)
  Future<Response> rejectTechnician(int technicianId) async {
    return await apiClient.postData('/owner/technicians/$technicianId/reject', {});
  }

  /// Get technician profile by ID (for owner/admin)
  Future<Response> getTechnicianProfile(int technicianId) async {
    return await apiClient.getData('/technician/profile/$technicianId');
  }

  /// Get client profile by ID (for owner/admin)
  Future<Response> getClientProfile(int clientId) async {
    return await apiClient.getData('/owner/clients/$clientId');
  }
}
