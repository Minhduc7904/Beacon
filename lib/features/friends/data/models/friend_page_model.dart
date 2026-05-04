import '../../domain/entities/friend_page.dart';
import 'friend_profile_model.dart';

class FriendPageModel extends FriendPage {
  const FriendPageModel({
    required super.items,
    required super.nextCursor,
    required super.limit,
    required super.hasMore,
  });

  factory FriendPageModel.fromJson(Map<String, dynamic> json) {
    final rows = json['data'];
    final meta = json['meta'];

    return FriendPageModel(
      items: rows is List
          ? rows
                .whereType<Map<String, dynamic>>()
                .map(FriendProfileModel.fromJson)
                .toList()
          : const <FriendProfileModel>[],
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
