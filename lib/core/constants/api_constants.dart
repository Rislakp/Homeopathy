/// API Endpoint Constants for Homeopathy Application
class ApiConstants {
  /// Toggle between Local Development server and Production server.
  /// Set [isLocalDev] to `false` for Production (https://homeopathybackend-1.onrender.com/api)
  /// or `true` for local development (http://localhost:5000/api).
  static bool isLocalDev = false;

  static const String localBaseUrl = 'http://localhost:5000/api';
  static const String prodBaseUrl = 'https://homeopathybackend-1.onrender.com/api';

  /// Returns the active base URL depending on [isLocalDev].
  static String get baseUrl => isLocalDev ? localBaseUrl : prodBaseUrl;

  /// Auth Endpoints
  static String get login => '$baseUrl/auth/login';
  static String get studentLogin => '$baseUrl/auth/student/login';
  static String get adminLogin => '$baseUrl/auth/admin/login';
  static String get register => '$baseUrl/auth/register';
  static String get me => '$baseUrl/auth/me';

  /// Admin User Role Management Endpoint
  static String userRoleUpdate(String userId) => '$baseUrl/v1/admin/users/$userId/role';

  /// Feature Endpoints
  static String get courses => '$baseUrl/courses';
  static String get extractMcqs => '$baseUrl/exams/extract-mcqs';
  static String get grandMock => '$baseUrl/exams/grand-mock';
  static String get testQuestions => '$baseUrl/test-questions';
  static String get studentResults => '$baseUrl/student/results';
  static String get studentExams => '$baseUrl/student/exams';

  /// Student Endpoints
  static String get adminStudents => '$baseUrl/v1/admin/students';
  static String get students => '$baseUrl/v1/students';
  static String studentById(String id) => '$baseUrl/v1/students/$id';
}
