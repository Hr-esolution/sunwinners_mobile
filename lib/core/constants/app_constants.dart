class AppConstants {
  // API Configuration
  // Use your local IP address for iOS simulator/device
  static const String baseUrl =
      'http://localhost:8000/api'; // Replace with your actual IP
  // Alternative for iOS simulator: static const String baseUrl = 'http://127.0.0.1:8000/api';
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userRoleKey = 'user_role';
  static const String userDataKey = 'user_data';

  // Default Values
  static const Duration apiTimeout = Duration(seconds: 30);

  // Validation Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Error Messages
  static const String unauthorizedMessage =
      'Unauthorized access. Please login again.';
  static const String networkErrorMessage =
      'Network error occurred. Please check your connection.';
  static const String serverErrorMessage =
      'Server error occurred. Please try again later.';

  // Success Messages
  static const String loginSuccessMessage = 'Login successful';
  static const String registerSuccessMessage = 'Registration successful';
}
