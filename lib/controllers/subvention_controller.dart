import 'package:get/get.dart';
import '../data/models/subvention_model.dart';
import '../data/repositories/subvention_repo.dart';
import '../core/constants/app_constants.dart';

class SubventionController extends GetxController {
  final SubventionRepository subventionRepo;
  SubventionController({required this.subventionRepo});

  final _isLoading = false.obs;
  final _subventionList = <SubventionModel>[].obs;
  final _currentSubvention = Rxn<SubventionModel>();

  bool get isLoading => _isLoading.value;
  List<SubventionModel> get subventionList => _subventionList;
  SubventionModel? get currentSubvention => _currentSubvention.value;

  void setLoading(bool value) {
    _isLoading.value = value;
    update();
  }

  void setSubventionList(List<SubventionModel> subventions) {
    _subventionList.assignAll(subventions);
    update();
  }

  void setCurrentSubvention(SubventionModel? subvention) {
    _currentSubvention.value = subvention;
    update();
  }

  Future<void> loadSubventions() async {
    setLoading(true);
    try {
      final response = await subventionRepo.getSubventions();
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is List) {
          final subventions = body.map((json) => SubventionModel.fromJson(json)).toList();
          setSubventionList(subventions);
        }
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMySubventions() async {
    setLoading(true);
    try {
      final response = await subventionRepo.getMySubventions();
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is List) {
          final subventions = body.map((json) => SubventionModel.fromJson(json)).toList();
          setSubventionList(subventions);
        }
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadSubventionById(int id) async {
    setLoading(true);
    try {
      final response = await subventionRepo.getSubventionById(id);
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic>) {
          final subvention = SubventionModel.fromJson(body);
          setCurrentSubvention(subvention);
        }
      }
    } catch (e) {
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> applyForSubvention(Map<String, dynamic> subventionData) async {
    setLoading(true);
    try {
      final response = await subventionRepo.applyForSubvention(subventionData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Subvention application submitted successfully');
        await loadMySubventions(); // Reload the list
        Get.back(); // Go back to previous screen
      } else {
        String message = 'Subvention application failed';
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

  Future<void> updateSubvention(int id, Map<String, dynamic> subventionData) async {
    setLoading(true);
    try {
      final response = await subventionRepo.updateSubvention(id, subventionData);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Subvention updated successfully');
        await loadSubventionById(id); // Reload the specific subvention
        await loadMySubventions(); // Reload the list
      } else {
        String message = 'Subvention update failed';
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

  Future<void> updateSubventionStatus(int id, String status) async {
    setLoading(true);
    try {
      final response = await subventionRepo.updateSubventionStatus(id, status);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Subvention status updated successfully');
        await loadSubventionById(id); // Reload the specific subvention
        await loadMySubventions(); // Reload the list
      } else {
        String message = 'Subvention status update failed';
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

  Future<void> submitDocuments(int id, Map<String, dynamic> documentData) async {
    setLoading(true);
    try {
      final response = await subventionRepo.submitDocuments(id, documentData);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Documents submitted successfully');
        await loadSubventionById(id); // Reload the specific subvention
      } else {
        String message = 'Document submission failed';
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

  Future<void> deleteSubvention(int id) async {
    setLoading(true);
    try {
      final response = await subventionRepo.deleteSubvention(id);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Subvention deleted successfully');
        await loadMySubventions(); // Reload the list
      } else {
        String message = 'Subvention deletion failed';
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

  // Alias method for loadSubventionById to match the view expectations
  Future<void> loadSubventionDetail(int id) async {
    await loadSubventionById(id);
  }
}