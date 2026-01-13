import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repo.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/app_roles.dart';

class AuthController extends GetxController {
  final AuthRepository authRepo;
  AuthController({required this.authRepo});

  final _isLoading = false.obs;
  final _userRole = ''.obs;
  final _currentUser = Rxn<UserModel>();

  bool get isLoading => _isLoading.value;
  String get userRole => _userRole.value;
  UserModel? get currentUser => _currentUser.value;

  // Use GetBuilder instead of Obx for state management
  void setLoading(bool value) {
    _isLoading.value = value;
    update();
  }

  void setUserRole(String role) {
    _userRole.value = role;
    update();
  }

  void setCurrentUser(UserModel? user) {
    _currentUser.value = user;
    if (user != null) {
      _userRole.value = user.role;
    }
    update();
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      final response = await authRepo.login(email, password);

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic>) {
          final token = body['token'];
          final userData = body['user'];

          if (token != null && userData != null) {
            await authRepo.saveToken(token);
            final user = UserModel.fromJson(userData);
            setCurrentUser(user);

            // Navigate to appropriate dashboard based on role
            String route = AppRoles.getDashboardRoute(user.role);
            Get.offAllNamed(route);
          } else {
            Get.snackbar('Error', 'Invalid response data');
          }
        } else {
          Get.snackbar('Error', 'Invalid response format');
        }
      } else {
        String message = 'Login failed';
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

  Future<void> register(Map<String, dynamic> userData) async {
    setLoading(true);
    try {
      final response = await authRepo.register(userData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', AppConstants.registerSuccessMessage);
        Get.toNamed('/login');
      } else {
        String message = 'Registration failed';
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

  Future<void> logout() async {
    try {
      await authRepo.logout();
      await authRepo.removeToken();
      setCurrentUser(null);
      setUserRole('');
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Logout failed');
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final response = await authRepo.getProfile();
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic>) {
          final user = UserModel.fromJson(body);
          setCurrentUser(user);
          setUserRole(user.role);
        }
      }
    } catch (e) {
      // Error handling is done in the UI layer
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    setLoading(true);
    try {
      final response = await authRepo.updateProfile(profileData);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully');
        // Reload the user profile to get updated data
        await loadUserProfile();
      } else {
        String message = 'Update failed';
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

  Future<void> uploadProfileImage(String imagePath) async {
    setLoading(true);
    try {
      final response = await authRepo.uploadProfileImage(imagePath);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile image uploaded successfully');
        // Reload the user profile to get updated data
        await loadUserProfile();
      } else {
        String message = 'Upload failed';
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

  Future<bool> checkAuthStatus() async {
    bool isAuthenticated = await authRepo.isAuthenticated();
    if (isAuthenticated) {
      await loadUserProfile();
    }
    return isAuthenticated;
  }
}
