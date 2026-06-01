import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const String _baseUrlOverride = String.fromEnvironment('BASE_URL');

  // Base URL
  static final String baseUrl = _baseUrlOverride.trim().isNotEmpty
      ? _baseUrlOverride.trim()
      : dotenv.env['BASE_URL'] ?? 'http://localhost:5000/api/v1';

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
  static const String deviceTokens = '/device-tokens';
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

  // Posts
  static const String posts = '/posts';
  static const String postsFeed = '/posts/feed';
  static const String postsMe = '/posts/me';
  static const String postByIdTemplate = '/posts/{postId}';
  static const String postsFriendTemplate = '/posts/friends/{friendId}';
  static const String postReactionTemplate = '/posts/{postId}/reaction';
  static const String postReactionsTemplate = '/posts/{postId}/reactions';
  static const String postReportsTemplate = '/posts/{postId}/reports';

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
  static const String friendsPresence = '/friends/presence';
  static const String friendsSearch = '/friends/search';
  static const String friendByUserIdTemplate = '/friends/{userId}';
  static const String friendTypeByUserIdTemplate = '/friends/{userId}/type';
  static const String friendDeleteByUserIdTemplate = '/friend/{userId}';

  // Message groups
  static const String messageGroups = '/message-groups';
  static const String messageGroupMessages = '/message-groups/messages';
  static const String messageGroupMessageTemplate =
      '/message-groups/{groupId}/messages';
  static const String messageGroupMessageSearchTemplate =
      '/message-groups/{groupId}/messages/search';
  static const String messageGroupDetailTemplate =
      '/message-groups/group/{groupId}';
  static const String messageGroupMemberCustomNameTemplate =
      '/message-groups/{groupId}/members/{userId}/custom-name';
  static const String messageGroupMemberTemplate =
      '/message-groups/{groupId}/members/{userId}';
  static const String messageGroupMemberApproveTemplate =
      '/message-groups/{groupId}/members/{userId}/approve';
  static const String messageGroupMemberDenyTemplate =
      '/message-groups/{groupId}/members/{userId}/deny';
  static const String messageGroupLeaveTemplate =
      '/message-groups/{groupId}/members/me';
  static const String messageGroupMuteTemplate =
      '/message-groups/{groupId}/members/me/mute';
  static const String messageGroupRequireApprovalTemplate =
      '/message-groups/{groupId}/require-approval-to-add-members';
  static const String messageGroupNameTemplate =
      '/message-groups/{groupId}/name';
  static const String messageGroupAvatarTemplate =
      '/message-groups/{groupId}/avatar';
  static const String messageGroupOwnerTemplate =
      '/message-groups/{groupId}/owner';

  static String mediaById(String id) => '/media/$id';
  static String mediaSoftDelete(String id) => '/media/$id/soft';
  static String postById(String postId) => '/posts/$postId';
  static String postsFriend(String friendId) => '/posts/friends/$friendId';
  static String postReaction(String postId) => '/posts/$postId/reaction';
  static String postReactions(String postId) => '/posts/$postId/reactions';
  static String postReports(String postId) => '/posts/$postId/reports';
  static String friendRequestAccept(String id) => '/friend-requests/$id/accept';
  static String friendRequestDecline(String id) =>
      '/friend-requests/$id/decline';
  static String friendByUserId(String userId) => '/friends/$userId';
  static String friendTypeByUserId(String userId) => '/friends/$userId/type';
  static String friendDeleteByUserId(String userId) => '/friend/$userId';
  static String messageGroupMessage(String groupId) =>
      '/message-groups/$groupId/messages';
  static String messageGroupMessageSearch(String groupId) =>
      '/message-groups/$groupId/messages/search';
  static String messageGroupDetail(String groupId) =>
      '/message-groups/$groupId';
  static String messageGroupSeen(String groupId) =>
      '/message-groups/$groupId/seen';
  static String messageGroupMembers(String groupId) =>
      '/message-groups/$groupId/members';
  static String messageGroupMemberCustomName(String groupId, String userId) =>
      '/message-groups/$groupId/members/$userId/custom-name';
  static String messageGroupMember(String groupId, String userId) =>
      '/message-groups/$groupId/members/$userId';
  static String messageGroupMemberApprove(String groupId, String userId) =>
      '/message-groups/$groupId/members/$userId/approve';
  static String messageGroupMemberDeny(String groupId, String userId) =>
      '/message-groups/$groupId/members/$userId/deny';
  static String messageGroupLeave(String groupId) =>
      '/message-groups/$groupId/members/me';
  static String messageGroupMute(String groupId) =>
      '/message-groups/$groupId/members/me/mute';
  static String messageGroupRequireApproval(String groupId) =>
      '/message-groups/$groupId/require-approval-to-add-members';
  static String messageGroupName(String groupId) =>
      '/message-groups/$groupId/name';
  static String messageGroupAvatar(String groupId) =>
      '/message-groups/$groupId/avatar';
  static String messageGroupOwner(String groupId) =>
      '/message-groups/$groupId/owner';
}
