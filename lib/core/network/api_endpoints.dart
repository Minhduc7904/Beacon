class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'http://localhost:3001/api';

  // Auth
  static const String login = '/auth/student/login';
  static const String register = '/auth/student/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
}
