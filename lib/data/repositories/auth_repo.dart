import 'package:get/get.dart';
import 'package:sunwinners/core/network/api_client.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<Response> login(String email, String password) async {
    return await apiClient.postData('/login', {
      'email': email,
      'password': password,
    });
  }

  Future<Response> register(Map<String, dynamic> userData) async {
    return await apiClient.postData('/register', userData);
  }

  Future<Response> logout() async {
    return await apiClient.postData('/logout', {});
  }

  Future<Response> getProfile() async {
    return await apiClient.getData('/profile');
  }

  Future<Response> updateProfile(Map<String, dynamic> profileData) async {
    return await apiClient.putData('/profile', profileData);
  }

  Future<Response> uploadProfileImage(String imagePath) async {
    return await apiClient.uploadProfileImage(imagePath);
  }

  Future<void> saveToken(String token) => apiClient.saveToken(token);
  Future<String?> getToken() => apiClient.getToken();
  Future<void> removeToken() => apiClient.removeToken();
  Future<bool> isAuthenticated() => apiClient.isAuthenticated();
}
