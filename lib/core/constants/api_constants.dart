class ApiConstants {
  static const String baseUrl = 'https://homeopathybackend-1.onrender.com/api';
  static const String courses = '/courses';
  
  static String courseDetail(String courseId) => '/courses/$courseId';
  static String courseModules(String courseId) => '/courses/$courseId/modules';
}
