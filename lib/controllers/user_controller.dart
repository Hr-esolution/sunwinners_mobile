import 'package:get/get.dart';
import 'package:sunwinners/data/models/user_model.dart';
import 'package:sunwinners/data/repositories/user_repo.dart';

class UserController extends GetxController {
  final UserRepository userRepo;
  UserController({required this.userRepo});

  final _isLoading = false.obs;
  final _technicians = <UserModel>[].obs;
  final _clients = <UserModel>[].obs;

  bool get isLoading => _isLoading.value;
  List<UserModel> get technicians => _technicians;
  List<UserModel> get clients => _clients;

  void setLoading(bool value) {
    _isLoading.value = value;
    update();
  }

  void setTechnicians(List<UserModel> technicians) {
    _technicians.assignAll(technicians);
    update();
  }

  void setClients(List<UserModel> clients) {
    _clients.assignAll(clients);
    update();
  }

  /// Load all technicians for owner/admin
  Future<void> loadAllTechnicians() async {
    _isLoading.value = true;
    update();
    try {
      print('🔍 loadAllTechnicians: Calling API...');
      final response = await userRepo.getAllTechnicians();
      print('🔍 loadAllTechnicians: Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['technicians'] is List) {
          final techniciansList = (body['technicians'] as List)
              .map((json) => UserModel.fromJson(json))
              .toList();
          setTechnicians(techniciansList);
          print('🔍 loadAllTechnicians: Loaded ${techniciansList.length} technicians');
        } else {
          print('🔍 loadAllTechnicians: Unexpected response format');
          setTechnicians([]);
        }
      } else {
        print('🔍 loadAllTechnicians: Error response: ${response.body}');
        setTechnicians([]);
        String message = 'Failed to load technicians';
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'];
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      print('🔍 loadAllTechnicians: Exception occurred: $e');
      setTechnicians([]);
      Get.snackbar('Error', 'Server error occurred');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// Load all clients for owner/admin
  Future<void> loadAllClients() async {
    _isLoading.value = true;
    update();
    try {
      print('🔍 loadAllClients: Calling API...');
      final response = await userRepo.getAllClients();
      print('🔍 loadAllClients: Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['clients'] is List) {
          final clientsList = (body['clients'] as List)
              .map((json) => UserModel.fromJson(json))
              .toList();
          setClients(clientsList);
          print('🔍 loadAllClients: Loaded ${clientsList.length} clients');
        } else {
          print('🔍 loadAllClients: Unexpected response format');
          setClients([]);
        }
      } else {
        print('🔍 loadAllClients: Error response: ${response.body}');
        setClients([]);
        String message = 'Failed to load clients';
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'];
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      print('🔍 loadAllClients: Exception occurred: $e');
      setClients([]);
      Get.snackbar('Error', 'Server error occurred');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// Approve a technician
  Future<void> approveTechnician(int technicianId) async {
    _isLoading.value = true;
    update();
    try {
      print('🔍 approveTechnician: Calling API for technician ID: $technicianId');
      final response = await userRepo.approveTechnician(technicianId);
      print('🔍 approveTechnician: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Technician approved successfully');
        // Reload the technicians list
        await loadAllTechnicians();
      } else {
        print('🔍 approveTechnician: Error response: ${response.body}');
        String message = 'Failed to approve technician';
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'];
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      print('🔍 approveTechnician: Exception occurred: $e');
      Get.snackbar('Error', 'Server error occurred');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// Reject a technician
  Future<void> rejectTechnician(int technicianId) async {
    _isLoading.value = true;
    update();
    try {
      print('🔍 rejectTechnician: Calling API for technician ID: $technicianId');
      final response = await userRepo.rejectTechnician(technicianId);
      print('🔍 rejectTechnician: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Technician rejected successfully');
        // Reload the technicians list
        await loadAllTechnicians();
      } else {
        print('🔍 rejectTechnician: Error response: ${response.body}');
        String message = 'Failed to reject technician';
        if (response.body is Map && response.body['message'] != null) {
          message = response.body['message'];
        }
        Get.snackbar('Error', message);
      }
    } catch (e) {
      print('🔍 rejectTechnician: Exception occurred: $e');
      Get.snackbar('Error', 'Server error occurred');
    } finally {
      _isLoading.value = false;
      update();
    }
  }
}