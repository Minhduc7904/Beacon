import '../../domain/entities/group_message_page.dart';
import 'group_message_model.dart';

class GroupMessagePageModel extends GroupMessagePage {
  const GroupMessagePageModel({
    required super.items,
    required super.nextCursor,
    required super.limit,
    required super.hasMore,
  });

  factory GroupMessagePageModel.fromJson(Map<String, dynamic> json) {
    final rows = json['data'];
    final meta = json['meta'];

    return GroupMessagePageModel(
      items: rows is List
          ? rows
                .whereType<Map<String, dynamic>>()
                .map(GroupMessageModel.fromJson)
                .toList()
          : const <GroupMessageModel>[],
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
