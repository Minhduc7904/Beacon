import '../../domain/entities/friend_request_page.dart';
import 'friend_request_model.dart';

class FriendRequestPageModel extends FriendRequestPage {
  const FriendRequestPageModel({
    required super.items,
    required super.nextCursor,
    required super.limit,
    required super.hasMore,
  });

  factory FriendRequestPageModel.fromJson(Map<String, dynamic> json) {
    final rows = json['data'];
    final meta = json['meta'];

    return FriendRequestPageModel(
      items: rows is List
          ? rows
                .whereType<Map<String, dynamic>>()
                .map(FriendRequestModel.fromJson)
                .toList()
          : const <FriendRequestModel>[],
      nextCursor: meta is Map<String, dynamic>
          ? meta['nextCursor']?.toString()
          : null,
      limit: meta is Map<String, dynamic> ? _toInt(meta['limit']) : 0,
      hasMore: meta is Map<String, dynamic> && meta['hasMore'] == true,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
