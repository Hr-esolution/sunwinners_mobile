import 'package:get/get.dart';
import 'package:sunwinners/core/network/api_client.dart';

class ComposantRepository {
  final ApiClient apiClient;

  ComposantRepository({required this.apiClient});

  // For technician-specific operations (their own components)
  Future<Response> getTechnicianComposants() async {
    return await apiClient.getData('/technician/composants');
  }

  Future<Response> getTechnicianComposantById(int id) async {
    return await apiClient.getData('/technician/composants/$id');
  }

  Future<Response> createTechnicianComposant(Map<String, dynamic> composantData) async {
    return await apiClient.postData('/technician/composants', composantData);
  }

  Future<Response> updateTechnicianComposant(
    int id,
    Map<String, dynamic> composantData,
  ) async {
    return await apiClient.putData('/technician/composants/$id', composantData);
  }

  Future<Response> deleteTechnicianComposant(int id) async {
    return await apiClient.deleteData('/technician/composants/$id');
  }

  // For admin operations (all components)
  Future<Response> getAllComposants() async {
    return await apiClient.getData('/admin/composants');
  }

  Future<Response> getAllComposantById(int id) async {
    return await apiClient.getData('/admin/composants/$id');
  }

  Future<Response> createComposant(Map<String, dynamic> composantData) async {
    return await apiClient.postData('/admin/composants', composantData);
  }

  Future<Response> updateComposant(
    int id,
    Map<String, dynamic> composantData,
  ) async {
    return await apiClient.putData('/admin/composants/$id', composantData);
  }

  Future<Response> deleteComposant(int id) async {
    return await apiClient.deleteData('/admin/composants/$id');
  }
}
