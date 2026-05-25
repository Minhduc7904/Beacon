import '../../domain/entities/group_message.dart';
import '../../../posts/data/models/post_model.dart';

class GroupMessageModel extends GroupMessage {
  const GroupMessageModel({
    required super.id,
    required super.groupId,
    required super.senderId,
    super.senderDisplayName,
    required super.senderFamilyName,
    required super.senderGivenName,
    required super.content,
    required super.createdAtUtc,
    required super.postId,
    required super.post,
    super.type,
  });

  factory GroupMessageModel.fromJson(Map<String, dynamic> json) {
    final postJson = json['post'];

    return GroupMessageModel(
      id: json['id']?.toString() ?? '',
      groupId: json['groupId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      senderDisplayName: json['senderDisplayName']?.toString() ?? '',
      senderFamilyName: json['senderFamilyName']?.toString() ?? '',
      senderGivenName:
          json['senderGivenName']?.toString() ??
          json['senderUsername']?.toString() ??
          '',
      content: json['content']?.toString() ?? '',
      createdAtUtc: _toDate(json['createdAtUtc']),
      postId: json['postId']?.toString(),
      post: postJson is Map<String, dynamic>
          ? PostModel.fromJson(postJson)
          : null,
      type: GroupMessageType.fromValue(json['type'] ?? json['messageType']),
    );
  }

  static DateTime? _toDate(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return null;
    }

    final hasTimezoneSuffix =
        raw.endsWith('Z') ||
        raw.contains('+') ||
        raw.substring(10).contains('-');
    if (hasTimezoneSuffix) {
      return parsed.toUtc();
    }

    return DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
      parsed.millisecond,
      parsed.microsecond,
    );
  }
}
