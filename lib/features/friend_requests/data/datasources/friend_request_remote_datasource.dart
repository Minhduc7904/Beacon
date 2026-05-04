import '../models/friend_request_model.dart';
import '../models/friend_request_page_model.dart';

abstract class FriendRequestRemoteDatasource {
  Future<FriendRequestModel> sendFriendRequest({required String receiverId});

  Future<void> acceptFriendRequest({required String id});

  Future<void> declineFriendRequest({required String id});

  Future<FriendRequestPageModel> getReceivedRequests({
    String? cursor,
    int? limit,
  });

  Future<FriendRequestPageModel> getSentRequests({
    String? cursor,
    int? limit,
  });
}
