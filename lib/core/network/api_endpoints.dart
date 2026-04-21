import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:5000/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String checkEmail = '/auth/check-email';
  static const String checkPhone = '/auth/check-phone';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String me = '/auth/me';
  static const String userMe = '/users/me';
  static const String userMeAvatar = '/users/me/avatar';

  // Health
  static const String health = '/health';
  static const String healthLive = '/health/live';
  static const String healthReady = '/health/ready';
  static const String healthDb = '/health/db';
  static const String healthMinio = '/health/minio';

  // Media
  static const String postMediaUpload = '/media';
  static const String mediaByIdTemplate = '/media/{id}';
  static const String mediaSoftDeleteTemplate = '/media/{id}/soft';

  static String mediaById(String id) => '/media/$id';
  static String mediaSoftDelete(String id) => '/media/$id/soft';
}
