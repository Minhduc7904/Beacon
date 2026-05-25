import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/friends/domain/entities/friend_page.dart';
import 'package:beacon_app/features/friends/domain/entities/friend_presence_page.dart';
import 'package:beacon_app/features/friends/domain/entities/friend_profile.dart';
import 'package:beacon_app/features/friends/domain/entities/friend_type.dart';
import 'package:beacon_app/features/friends/domain/repositories/friends_repository.dart';
import 'package:beacon_app/features/home/domain/entities/checkin_record.dart';
import 'package:beacon_app/features/home/domain/entities/today_status.dart';
import 'package:beacon_app/features/home/domain/repositories/checkin_repository.dart';
import 'package:beacon_app/features/message_groups/domain/entities/group_message.dart';
import 'package:beacon_app/features/message_groups/domain/entities/group_message_page.dart';
import 'package:beacon_app/features/message_groups/domain/entities/message_group_detail.dart';
import 'package:beacon_app/features/message_groups/domain/entities/message_group_page.dart';
import 'package:beacon_app/features/message_groups/domain/repositories/message_groups_repository.dart';
import 'package:beacon_app/features/posts/domain/entities/post.dart';
import 'package:beacon_app/features/posts/domain/entities/post_page.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_icon.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_page.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_result.dart';
import 'package:beacon_app/features/posts/domain/entities/post_visibility.dart';
import 'package:beacon_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:beacon_app/features/safety/domain/entities/safety_settings.dart';
import 'package:beacon_app/features/safety/domain/repositories/safety_repository.dart';
import 'package:dartz/dartz.dart';

Never _unsupported(String name) {
  throw UnsupportedError('$name is outside the auth integration flow');
}

class FakeCheckinRepository implements CheckinRepository {
  @override
  Future<Either<Failure, TodayStatus>> getTodayStatus() async {
    return Right(
      TodayStatus(
        hasCheckedIn: true,
        status: TodayStatusType.checkedIn,
        streak: 1,
        deadlineAtUtc: null,
        remainingSeconds: null,
        checkedInAtUtc: DateTime.utc(2026, 5, 26, 8),
        isMonitoringEnabled: true,
        isAutoAlertEnabled: true,
      ),
    );
  }

  @override
  Future<Either<Failure, CheckinRecord>> checkin({
    String? note,
    String? mediaId,
  }) async {
    return Right(
      CheckinRecord(
        id: 'checkin-1',
        dailySafetyRecordId: 'daily-safety-1',
        checkinDate: '2026-05-26',
        checkedInAtUtc: DateTime.utc(2026, 5, 26, 8),
        type: CheckinType.manual,
        note: note,
        latitude: null,
        longitude: null,
        mediaObjectId: mediaId,
      ),
    );
  }
}

class FakeSafetyRepository implements SafetyRepository {
  static const _settings = SafetySettings(
    dailyDeadlineLocalTime: '21:00',
    gracePeriodMinutes: 30,
    reminderBeforeMinutes: 15,
    autoAlertDelayMinutes: 30,
    isMonitoringEnabled: true,
    isAutoAlertEnabled: true,
    isDefault: false,
  );

  @override
  Future<Either<Failure, SafetySettings>> getSafetySettings() async {
    return const Right(_settings);
  }

  @override
  Future<Either<Failure, SafetySettings>> updateSafetySettings({
    String? dailyDeadlineLocalTime,
    int? gracePeriodMinutes,
    int? reminderBeforeMinutes,
    int? autoAlertDelayMinutes,
    bool? isMonitoringEnabled,
    bool? isAutoAlertEnabled,
  }) async {
    return Right(
      SafetySettings(
        dailyDeadlineLocalTime:
            dailyDeadlineLocalTime ?? _settings.dailyDeadlineLocalTime,
        gracePeriodMinutes: gracePeriodMinutes ?? _settings.gracePeriodMinutes,
        reminderBeforeMinutes:
            reminderBeforeMinutes ?? _settings.reminderBeforeMinutes,
        autoAlertDelayMinutes:
            autoAlertDelayMinutes ?? _settings.autoAlertDelayMinutes,
        isMonitoringEnabled:
            isMonitoringEnabled ?? _settings.isMonitoringEnabled,
        isAutoAlertEnabled: isAutoAlertEnabled ?? _settings.isAutoAlertEnabled,
        isDefault: false,
      ),
    );
  }
}

class FakeFriendsRepository implements FriendsRepository {
  @override
  Future<Either<Failure, FriendPage>> getFriends({
    String? search,
    String? cursor,
    int? limit,
  }) async {
    return Right(
      FriendPage(
        items: const [],
        nextCursor: null,
        limit: limit ?? 100,
        hasMore: false,
      ),
    );
  }

  @override
  Future<Either<Failure, FriendPresencePage>> getFriendsPresence({
    String? cursor,
    int? limit,
  }) async {
    return Right(
      FriendPresencePage(
        items: const [],
        nextCursor: null,
        limit: limit ?? 100,
        hasMore: false,
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> deleteFriend({required String userId}) {
    return _unsupported('deleteFriend');
  }

  @override
  Future<Either<Failure, FriendProfile>> getFriendDetail({
    required String userId,
  }) {
    return _unsupported('getFriendDetail');
  }

  @override
  Future<Either<Failure, FriendPage>> searchFriends({
    required String search,
    String? cursor,
    int? limit,
  }) async {
    return Right(
      FriendPage(
        items: const [],
        nextCursor: null,
        limit: limit ?? 100,
        hasMore: false,
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> updateFriendType({
    required String userId,
    required FriendType type,
  }) {
    return _unsupported('updateFriendType');
  }
}

class FakeMessageGroupsRepository implements MessageGroupsRepository {
  @override
  Future<Either<Failure, MessageGroupPage>> getMessageGroups({
    String? cursor,
    int? limit,
  }) async {
    return Right(
      MessageGroupPage(
        items: const [],
        nextCursor: null,
        limit: limit ?? 100,
        hasMore: false,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> addMembers({
    required String groupId,
    required List<String> targetUserIds,
  }) {
    return _unsupported('addMembers');
  }

  @override
  Future<Either<Failure, void>> approveMember({
    required String groupId,
    required String userId,
  }) {
    return _unsupported('approveMember');
  }

  @override
  Future<Either<Failure, MessageGroupDetail>> createMessageGroup({
    required List<String> memberUserIds,
  }) {
    return _unsupported('createMessageGroup');
  }

  @override
  Future<Either<Failure, void>> deleteGroup({required String groupId}) {
    return _unsupported('deleteGroup');
  }

  @override
  Future<Either<Failure, void>> denyMember({
    required String groupId,
    required String userId,
  }) {
    return _unsupported('denyMember');
  }

  @override
  Future<Either<Failure, MessageGroupDetail>> getGroupDetail({
    required String groupId,
  }) {
    return _unsupported('getGroupDetail');
  }

  @override
  Future<Either<Failure, GroupMessagePage>> getMessages({
    required String groupId,
    String? cursor,
    int? limit,
  }) {
    return _unsupported('getMessages');
  }

  @override
  Future<Either<Failure, void>> leaveGroup({required String groupId}) {
    return _unsupported('leaveGroup');
  }

  @override
  Future<Either<Failure, void>> markSeen({
    required String groupId,
    required String lastSeenMessageId,
  }) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> removeMember({
    required String groupId,
    required String userId,
  }) {
    return _unsupported('removeMember');
  }

  @override
  Future<Either<Failure, GroupMessagePage>> searchMessages({
    required String groupId,
    required String search,
    String? cursor,
    int? limit,
  }) {
    return _unsupported('searchMessages');
  }

  @override
  Future<Either<Failure, GroupMessage>> sendMessage({
    required String groupId,
    required String content,
  }) {
    return _unsupported('sendMessage');
  }

  @override
  Future<Either<Failure, GroupMessage>> sendPostMessage({
    required String postId,
    required String clientMessageId,
    String? content,
  }) {
    return _unsupported('sendPostMessage');
  }

  @override
  Future<Either<Failure, void>> updateGroupAvatar({
    required String groupId,
    required String filePath,
  }) {
    return _unsupported('updateGroupAvatar');
  }

  @override
  Future<Either<Failure, void>> updateGroupName({
    required String groupId,
    required String name,
  }) {
    return _unsupported('updateGroupName');
  }

  @override
  Future<Either<Failure, void>> updateMemberCustomName({
    required String groupId,
    required String userId,
    String? customName,
  }) {
    return _unsupported('updateMemberCustomName');
  }

  @override
  Future<Either<Failure, void>> updateMemberRole({
    required String groupId,
    required String targetUserId,
    required int role,
  }) {
    return _unsupported('updateMemberRole');
  }

  @override
  Future<Either<Failure, void>> updateMuteStatus({
    required String groupId,
    required bool isMuted,
  }) {
    return _unsupported('updateMuteStatus');
  }

  @override
  Future<Either<Failure, void>> updateRequireApprovalToAddMembers({
    required String groupId,
    required bool requireApprovalToAddMembers,
  }) {
    return _unsupported('updateRequireApprovalToAddMembers');
  }
}

class FakePostsRepository implements PostsRepository {
  @override
  Future<Either<Failure, PostPage>> getFeedPosts({
    String? cursor,
    int? limit,
  }) async {
    return const Right(PostPage(items: [], nextCursor: null));
  }

  @override
  Future<Either<Failure, PostPage>> getFriendPosts({
    required String friendId,
    String? cursor,
    int? limit,
  }) async {
    return const Right(PostPage(items: [], nextCursor: null));
  }

  @override
  Future<Either<Failure, PostPage>> getMyPosts({
    String? cursor,
    int? limit,
  }) async {
    return const Right(PostPage(items: [], nextCursor: null));
  }

  @override
  Future<Either<Failure, PostReactionPage>> getReactions({
    required String postId,
    String? cursor,
    int? limit,
  }) async {
    return const Right(PostReactionPage.empty());
  }

  @override
  Future<Either<Failure, Post>> createPost({
    required String mediaId,
    String? caption,
    required PostVisibility visibility,
    double? latitude,
    double? longitude,
  }) {
    return _unsupported('createPost');
  }

  @override
  Future<Either<Failure, bool>> deletePost({required String postId}) {
    return _unsupported('deletePost');
  }

  @override
  Future<Either<Failure, PostReactionResult>> deleteReaction({
    required String postId,
  }) {
    return _unsupported('deleteReaction');
  }

  @override
  Future<Either<Failure, PostReactionResult>> setReaction({
    required String postId,
    required PostReactionIcon icon,
  }) {
    return _unsupported('setReaction');
  }

  @override
  Future<Either<Failure, PostReactionResult>> setReactionIcon({
    required String postId,
    required String icon,
  }) {
    return _unsupported('setReactionIcon');
  }

  @override
  Future<Either<Failure, Post>> updatePost({
    required String postId,
    String? caption,
    PostVisibility? visibility,
  }) {
    return _unsupported('updatePost');
  }
}
