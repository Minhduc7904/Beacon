import '../../domain/entities/message_group_detail.dart';
import 'message_group_member_model.dart';

class MessageGroupDetailModel extends MessageGroupDetail {
  const MessageGroupDetailModel({
    required super.groupId,
    required super.isPrivate,
    required super.createdAtUtc,
    required super.members,
  });

  factory MessageGroupDetailModel.fromJson(Map<String, dynamic> json) {
    final membersRaw = json['members'];
    return MessageGroupDetailModel(
      groupId: json['groupId']?.toString() ?? '',
      isPrivate: json['isPrivate'] == true,
      createdAtUtc: _toDate(json['createdAtUtc']),
      members: membersRaw is List
          ? membersRaw
                .whereType<Map<String, dynamic>>()
                .map(MessageGroupMemberModel.fromJson)
                .toList()
          : const <MessageGroupMemberModel>[],
    );
  }

  static DateTime? _toDate(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }
}
