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
  static const String safetySettings = '/safety/settings';

  // Check-in
  static const String checkins = '/checkins';
  static const String todayStatus = '/checkins/today-status';

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

  // Friend requests
  static const String friendRequests = '/friend-requests';
  static const String friendRequestsReceived = '/friend-requests/received';
  static const String friendRequestsSent = '/friend-requests/sent';
  static const String friendRequestAcceptTemplate =
      '/friend-requests/{id}/accept';
  static const String friendRequestDeclineTemplate =
      '/friend-requests/{id}/decline';

  // Friends
  static const String friends = '/friends';
  static const String friendsSearch = '/friends/search';
  static const String friendByUserIdTemplate = '/friends/{userId}';
  static const String friendTypeByUserIdTemplate = '/friends/{userId}/type';
  static const String friendDeleteByUserIdTemplate = '/friend/{userId}';

  // Message groups
  static const String messageGroups = '/message-groups';
  static const String messageGroupMessageTemplate =
      '/message-groups/{groupId}/messages';
  static const String messageGroupDetailTemplate =
      '/message-groups/group/{groupId}';

  static String mediaById(String id) => '/media/$id';
  static String mediaSoftDelete(String id) => '/media/$id/soft';
  static String friendRequestAccept(String id) => '/friend-requests/$id/accept';
  static String friendRequestDecline(String id) =>
      '/friend-requests/$id/decline';
  static String friendByUserId(String userId) => '/friends/$userId';
  static String friendTypeByUserId(String userId) => '/friends/$userId/type';
  static String friendDeleteByUserId(String userId) => '/friend/$userId';
  static String messageGroupMessage(String groupId) =>
      '/message-groups/$groupId/messages';
  static String messageGroupDetail(String groupId) =>
      '/message-groups/$groupId';
  static String messageGroupSeen(String groupId) =>
      '/message-groups/$groupId/seen';
}
