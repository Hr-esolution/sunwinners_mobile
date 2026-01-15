import 'package:get/get.dart';
import 'package:sunwinners/core/network/api_client.dart';

class DevisRepository {
  final ApiClient apiClient;

  DevisRepository({required this.apiClient});

  /// Client: create a devis
  Future<Response> createDevis(Map<String, dynamic> devisData) async {
    return await apiClient.postData('/devis-solaire', devisData);
  }

  /// Client: create a devis with images (multipart)
  Future<Response> createDevisWithImages(
    Map<String, dynamic> devisData,
    List<String>? imagePaths,
  ) async {
    // Extract non-file fields to send as form data
    Map<String, dynamic> fields = {};
    devisData.forEach((key, value) {
      if (value != null) {
        fields[key] = value;
      }
    });

    return await apiClient.postMultipartData(
      '/devis-solaire',
      fields,
      imagePaths,
    );
  }

  /// Client: get my devis
  Future<Response> getMyDevis() async {
    return await apiClient.getData('/client/devis');
  }

  /// Technician: get assigned devis
  Future<Response> getAssignedDevis() async {
    return await apiClient.getData('/assigned-devis');
  }

  /// Technician: get assigned devis detail
  Future<Response> getAssignedDevisDetail(int id) async {
    return await apiClient.getData('/assigned-details/$id');
  }

  /// owner/Owner: get all devis
  Future<Response> getAllDevis() async {
    return await apiClient.getData('/owner/devis');
  }

  /// Client: get devis detail
  Future<Response> getDevisDetail(int id) async {
    return await apiClient.getData('/client/devis/$id');
  }

  /// owner/Owner: get devis detail by ID
  Future<Response> getDevisById(int id) async {
    return await apiClient.getData('/owner/devis/$id');
  }

  /// Client: validate devis
  Future<Response> validateDevis(int id) async {
    return await apiClient.postData('/devis/$id/validate', {});
  }

  /// Client: reject devis
  Future<Response> rejectDevis(int id) async {
    return await apiClient.postData('/devis/$id/reject', {});
  }

  Future<Response> assignTechnicians(
    int devisId,
    List<int> technicianIds,
  ) async {
    return await apiClient.assignTechnicians(devisId, technicianIds);
  }

  /// Client: see responses for a devis
  Future<Response> getDevisResponses(int devisId) async {
    return await apiClient.getData('/client/devis/$devisId/responses');
  }

  /// Technician: get specific response for a devis by a technician
  Future<Response> getTechnicianResponseForDevis(
    int devisId,
    int technicianId,
  ) async {
    return await apiClient.getData('/technician/devis/$devisId/responses');
  }

  /// Technician: respond to a devis
  Future<Response> respondToDevis(
    int devisId,
    Map<String, dynamic> responseData,
  ) async {
    return await apiClient.postData(
      '/technician/devis/$devisId/response',
      responseData,
    );
  }

  /// owner/Owner: remove technician from a devis
  Future<Response> removeTechnician(int devisId, int technicianId) async {
    return await apiClient.deleteData(
      '/devis/$devisId/remove-technician/$technicianId',
    );
  }
}
