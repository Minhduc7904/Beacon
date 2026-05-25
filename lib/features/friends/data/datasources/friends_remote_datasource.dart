import '../models/friend_page_model.dart';
import '../models/friend_presence_page_model.dart';
import '../models/friend_profile_model.dart';

abstract class FriendsRemoteDatasource {
  Future<FriendPageModel> getFriends({
    String? search,
    String? cursor,
    int? limit,
  });

  Future<FriendPresencePageModel> getFriendsPresence({
    String? cursor,
    int? limit,
  });

  Future<FriendPageModel> searchFriends({
    required String search,
    String? cursor,
    int? limit,
  });

  Future<FriendProfileModel> getFriendDetail({required String userId});

  Future<void> updateFriendType({required String userId, required int type});

  Future<void> deleteFriend({required String userId});
}
