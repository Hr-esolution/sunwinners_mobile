class AppRoles {
  static const String client = 'client';
  static const String technician = 'technician';
  static const String owner = 'owner';
  static const String admin = 'admin';

  static List<String> getAllRoles() {
    return [client, technician, owner, admin];
  }

  static bool isValidRole(String role) {
    return getAllRoles().contains(role);
  }

  static String getDashboardRoute(String role) {
    switch (role) {
      case client:
        return '/client/dashboard';
      case technician:
        return '/technician/dashboard';
      case owner:
        return '/owner/dashboard';
      case admin:
        return '/owner/dashboard'; // Admins can use the same dashboard as owners
      default:
        return '/login';
    }
  }
}