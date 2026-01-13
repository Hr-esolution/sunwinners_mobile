import 'package:get/get.dart';
import '../data/models/project_model.dart';
import '../data/repositories/project_repo.dart';
import '../core/constants/app_constants.dart';

class ProjectController extends GetxController {
  final ProjectRepository projectRepo;
  ProjectController({required this.projectRepo});

  final _isLoading = false.obs;
  final _projectList = <ProjectModel>[].obs;
  final _currentProject = Rxn<ProjectModel>();

  bool get isLoading => _isLoading.value;
  List<ProjectModel> get projectList => _projectList;
  ProjectModel? get currentProject => _currentProject.value;

  void setLoading(bool value) {
    _isLoading.value = value;
    update();
  }

  void setProjectList(List<ProjectModel> projects) {
    _projectList.assignAll(projects);
    update();
  }

  void setCurrentProject(ProjectModel? project) {
    _currentProject.value = project;
    update();
  }

  Future<void> loadProjects() async {
    setLoading(true);
    try {
      final response = await projectRepo.getProjects();
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is List) {
          final projects = body.map((json) => ProjectModel.fromJson(json)).toList();
          setProjectList(projects);
        }
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMyProjects() async {
    setLoading(true);
    try {
      final response = await projectRepo.getMyProjects();
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is List) {
          final projects = body.map((json) => ProjectModel.fromJson(json)).toList();
          setProjectList(projects);
        }
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadProjectById(int id) async {
    setLoading(true);
    try {
      final response = await projectRepo.getProjectById(id);
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic>) {
          final project = ProjectModel.fromJson(body);
          setCurrentProject(project);
        }
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> createProject(Map<String, dynamic> projectData) async {
    setLoading(true);
    try {
      final response = await projectRepo.createProject(projectData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Project created successfully');
        await loadMyProjects(); // Reload the list
        Get.back(); // Go back to previous screen
      } else {
        String message = 'Project creation failed';
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'];
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> createProjectFromDevis(Map<String, dynamic> projectData) async {
    setLoading(true);
    try {
      final response = await projectRepo.createProjectFromDevis(projectData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Project created from devis successfully');
        await loadMyProjects(); // Reload the list
        Get.back(); // Go back to previous screen
      } else {
        String message = 'Project creation from devis failed';
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'];
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateProject(int id, Map<String, dynamic> projectData) async {
    setLoading(true);
    try {
      final response = await projectRepo.updateProject(id, projectData);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Project updated successfully');
        await loadProjectById(id); // Reload the specific project
        await loadMyProjects(); // Reload the list
      } else {
        String message = 'Project update failed';
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'];
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateProjectStatus(int id, String status) async {
    setLoading(true);
    try {
      final response = await projectRepo.updateProjectStatus(id, status);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Project status updated successfully');
        await loadProjectById(id); // Reload the specific project
        await loadMyProjects(); // Reload the list
      } else {
        String message = 'Project status update failed';
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'];
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateProjectProgress(int id, String progress) async {
    setLoading(true);
    try {
      final response = await projectRepo.updateProjectProgress(id, progress);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Project progress updated successfully');
        await loadProjectById(id); // Reload the specific project
      } else {
        String message = 'Project progress update failed';
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'];
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteProject(int id) async {
    setLoading(true);
    try {
      final response = await projectRepo.deleteProject(id);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Project deleted successfully');
        await loadMyProjects(); // Reload the list
      } else {
        String message = 'Project deletion failed';
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'];
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  // Alias method for loadProjectById to match the view expectations
  Future<void> loadProjectDetail(int id) async {
    await loadProjectById(id);
  }
}