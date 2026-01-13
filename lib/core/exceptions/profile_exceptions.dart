/// Custom exception for profile-related errors
class ProfileException implements Exception {
  final String message;
  final int? statusCode;
  final String? details;

  ProfileException({
    required this.message,
    this.statusCode,
    this.details,
  });

  @override
  String toString() {
    if (details != null) {
      return 'ProfileException: $message (Status: $statusCode, Details: $details)';
    } else if (statusCode != null) {
      return 'ProfileException: $message (Status: $statusCode)';
    }
    return 'ProfileException: $message';
  }
}

/// Custom exception for authentication-related errors
class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Custom exception for network-related errors
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
