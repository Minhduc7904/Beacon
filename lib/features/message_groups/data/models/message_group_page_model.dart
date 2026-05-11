import '../../domain/entities/message_group_page.dart';
import 'message_group_model.dart';

class MessageGroupPageModel extends MessageGroupPage {
  const MessageGroupPageModel({
    required super.items,
    required super.nextCursor,
    required super.limit,
    required super.hasMore,
  });

  factory MessageGroupPageModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final rows = payload['data'];
    final meta = payload['meta'];

    return MessageGroupPageModel(
      items: rows is List
          ? rows
                .whereType<Map>()
                .map(
                  (row) => MessageGroupModel.fromJson(
                    Map<String, dynamic>.from(row),
                  ),
                )
                .toList()
          : const <MessageGroupModel>[],
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
