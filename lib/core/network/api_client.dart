import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sunwinners/core/constants/app_constants.dart';

class ApiClient extends GetConnect {
  String? token;

  ApiClient() {
    baseUrl = AppConstants.baseUrl;
    timeout = AppConstants.apiTimeout;
    httpClient.defaultContentType = 'application/json';

    // Ajoute toujours le header Authorization avec le token le plus récent
    httpClient.addRequestModifier<dynamic>((request) async {
      token = await getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // Modificateur de réponse pour détecter HTML/redirect (token expiré)
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 301 || response.statusCode == 302) {
        _handleAuthFailure();
        return Response(
          body: {'message': 'Authentication failed - redirect received'},
          statusCode: 401,
          request: response.request,
        );
      }

      // Si réponse HTML -> token invalide
      if (response.body is String &&
          (response.body as String).startsWith('<!DOCTYPE html>')) {
        _handleAuthFailure();
        return Response(
          body: {'message': 'Unauthorized or HTML page received'},
          statusCode: 401,
          request: response.request,
        );
      }

      // Handle 401 responses directly from the server
      if (response.statusCode == 401) {
        _handleAuthFailure();
      }

      return response;
    });
  }

  // ========================
  // 🔹 CRUD HTTP
  // ========================
  Future<Response> getData(String uri) async {
    await _ensureTokenLoaded();
    return await get(uri);
  }

  Future<Response> postData(String uri, dynamic body) async {
    await _ensureTokenLoaded();
    return await post(uri, body);
  }

  // ========================
  // 🔹 Post Multipart Data (for file uploads)
  // ========================
  Future<Response> postMultipartData(String uri, Map<String, dynamic> fields, List<String>? filePaths) async {
    await _ensureTokenLoaded();

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$uri'));

    // Add authorization header
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Add form fields
    fields.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

    // Add files if provided
    if (filePaths != null) {
      for (String filePath in filePaths) {
        var file = await http.MultipartFile.fromPath('images[]', filePath);
        request.files.add(file);
      }
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    return Response(
      body: responseBody,
      statusCode: response.statusCode,
      headers: response.headers,
    );
  }

  Future<Response> putData(String uri, dynamic body) async {
    await _ensureTokenLoaded();
    return await put(uri, body);
  }

  Future<Response> deleteData(String uri) async {
    await _ensureTokenLoaded();
    return await delete(uri);
  }

  // ========================
  // 🔹 Gestion token
  // ========================
  Future<void> _ensureTokenLoaded() async {
    token ??= await getToken();
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    this.token = token;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(AppConstants.tokenKey);
    return token;
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    token = null;
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ========================
  // 🔹 Assign Technicians avec gestion token expiré
  // ========================
  Future<Response> assignTechnicians(
    int devisId,
    List<int> technicianIds,
  ) async {
    return await postData('/devis/$devisId/assign-technicians', {
      'technician_ids': technicianIds,
    });
  }

  // ========================
  // 🔹 Upload Profile Image
  // ========================
  Future<Response> uploadProfileImage(String imagePath) async {
    await _ensureTokenLoaded();

    final multipartFile = await http.MultipartFile.fromPath('image', imagePath);
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/profile/upload-image'),
    )..files.add(multipartFile);

    // Add authorization header
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    return Response(
      body: responseBody,
      statusCode: response.statusCode,
      headers: response.headers,
    );
  }


  // Method to handle authentication failure
  void _handleAuthFailure() {
    // Remove the invalid token
    removeToken();

    // Optionally redirect to login screen
    // Note: This creates a circular dependency, so we handle this in the controllers
    // Get.offAllNamed('/login');
  }
}
