import '../../domain/entities/friend_presence_page.dart';
import 'friend_presence_model.dart';

class FriendPresencePageModel extends FriendPresencePage {
  const FriendPresencePageModel({
    required super.items,
    required super.nextCursor,
    required super.limit,
    required super.hasMore,
  });

  factory FriendPresencePageModel.fromJson(Map<String, dynamic> json) {
    final rows = json['data'];
    final meta = json['meta'];

    return FriendPresencePageModel(
      items: rows is List
          ? rows
                .whereType<Map<String, dynamic>>()
                .map(FriendPresenceModel.fromJson)
                .toList()
          : const <FriendPresenceModel>[],
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
