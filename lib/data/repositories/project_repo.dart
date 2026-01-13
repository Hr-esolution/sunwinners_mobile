import 'package:get/get.dart';
import 'package:sunwinners/core/network/api_client.dart';

class ProjectRepository {
  final ApiClient apiClient;

  ProjectRepository({required this.apiClient});

  /// Get all projects
  Future<Response> getProjects() async {
    return await apiClient.getData('/projects');
  }

  /// Get project by ID
  Future<Response> getProjectById(int id) async {
    return await apiClient.getData('/projects/$id');
  }

  /// Get projects by status
  Future<Response> getProjectsByStatus(String status) async {
    return await apiClient.getData('/projects?status=$status');
  }

  /// Get projects for current user (based on role)
  Future<Response> getMyProjects() async {
    return await apiClient.getData('/projects/my');
  }

  /// Create a new project
  Future<Response> createProject(Map<String, dynamic> projectData) async {
    return await apiClient.postData('/projects', projectData);
  }

  /// Create a project from an accepted devis
  Future<Response> createProjectFromDevis(Map<String, dynamic> projectData) async {
    return await apiClient.postData('/projects/from-devis', projectData);
  }

  /// Update project
  Future<Response> updateProject(
    int id,
    Map<String, dynamic> projectData,
  ) async {
    return await apiClient.putData('/projects/$id', projectData);
  }

  /// Delete project
  Future<Response> deleteProject(int id) async {
    return await apiClient.deleteData('/projects/$id');
  }

  /// Update project status
  Future<Response> updateProjectStatus(int id, String status) async {
    return await apiClient.putData('/projects/$id/status', {'status': status});
  }

  /// Update project progress
  Future<Response> updateProjectProgress(int id, String progress) async {
    return await apiClient.putData('/projects/$id/progress', {
      'progress': progress,
    });
  }
}
