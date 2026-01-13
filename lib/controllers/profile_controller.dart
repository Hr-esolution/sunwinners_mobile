import 'package:get/get.dart';
import '../data/models/profile_model.dart';
import '../data/repositories/profile_repo.dart';
import '../core/constants/app_constants.dart';

class ProfileController extends GetxController {
  final ProfileRepository profileRepo;
  ProfileController({required this.profileRepo});

  final _isLoading = false.obs;
  final _currentProfile = Rxn<ProfileModel>();

  bool get isLoading => _isLoading.value;
  ProfileModel? get currentProfile => _currentProfile.value;

  void setLoading(bool value) {
    _isLoading.value = value;
    update();
  }

  void setCurrentProfile(ProfileModel? profile) {
    _currentProfile.value = profile;
    update();
  }

  Future<void> loadProfile() async {
    setLoading(true);
    try {
      final response = await profileRepo.getProfile();
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic>) {
          print('Profile response: $body'); // Debug print
          final profile = ProfileModel.fromJson(body);
          print('Parsed profile: ${profile.toJson()}'); // Debug print
          setCurrentProfile(profile);
        }
      } else {
        Get.snackbar('Error', 'Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading profile: $e'); // Debug print
      Get.snackbar('Error', AppConstants.serverErrorMessage);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateProfile(ProfileModel profileModel) async {
    setLoading(true);
    try {
      final response = await profileRepo.updateProfile(profileModel);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully');
        await loadProfile(); // Reload the profile after update
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

  Future<void> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    setLoading(true);
    try {
      final response = await profileRepo.changePassword({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      });

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password changed successfully');
      } else {
        String message = 'Password change failed';
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

  Future<void> uploadAvatar(String filePath) async {
    setLoading(true);
    try {
      final response = await profileRepo.uploadAvatar(filePath);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Avatar updated successfully');
        await loadProfile(); // Reload profile to get updated avatar
      } else {
        String message = 'Avatar upload failed';
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
}