import 'package:get/get.dart';
import 'package:sunwinners/core/network/api_client.dart';

class SubventionRepository {
  final ApiClient apiClient;

  SubventionRepository({required this.apiClient});

  /// Get all subventions
  Future<Response> getSubventions() async {
    return await apiClient.getData('/subventions');
  }

  /// Get subvention by ID
  Future<Response> getSubventionById(int id) async {
    return await apiClient.getData('/subventions/$id');
  }

  /// Get subventions by status
  Future<Response> getSubventionsByStatus(String status) async {
    return await apiClient.getData('/subventions?status=$status');
  }

  /// Get subventions by type
  Future<Response> getSubventionsByType(String type) async {
    return await apiClient.getData('/subventions?type=$type');
  }

  /// Get my subventions
  Future<Response> getMySubventions() async {
    return await apiClient.getData('/subventions/my');
  }

  /// Apply for a subvention
  Future<Response> applyForSubvention(
    Map<String, dynamic> subventionData,
  ) async {
    return await apiClient.postData('/subventions', subventionData);
  }

  /// Update subvention
  Future<Response> updateSubvention(
    int id,
    Map<String, dynamic> subventionData,
  ) async {
    return await apiClient.putData('/subventions/$id', subventionData);
  }

  /// Delete subvention
  Future<Response> deleteSubvention(int id) async {
    return await apiClient.deleteData('/subventions/$id');
  }

  /// Update subvention status (admin/owner only)
  Future<Response> updateSubventionStatus(int id, String status) async {
    return await apiClient.putData('/subventions/$id/status', {
      'status': status,
    });
  }

  /// Submit required documents for subvention
  Future<Response> submitDocuments(
    int id,
    Map<String, dynamic> documentData,
  ) async {
    return await apiClient.postData('/subventions/$id/documents', documentData);
  }
}
