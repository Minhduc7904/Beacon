import '../../domain/entities/message_group_detail.dart';
import 'message_group_member_model.dart';

class MessageGroupDetailModel extends MessageGroupDetail {
  const MessageGroupDetailModel({
    required super.groupId,
    required super.isPrivate,
    required super.createdAtUtc,
    required super.displayName,
    required super.displayAvatarUrl,
    required super.members,
    required super.requireApprovalToAddMembers,
  });

  factory MessageGroupDetailModel.fromJson(Map<String, dynamic> json) {
    final membersRaw = json['members'];
    return MessageGroupDetailModel(
      groupId: json['groupId']?.toString() ?? '',
      isPrivate: _toBool(json['isPrivate']) ?? json['type'] == 0,
      createdAtUtc: _toDate(json['createdAtUtc']),
      displayName: json['displayName']?.toString(),
      displayAvatarUrl: json['displayAvatarUrl']?.toString(),
        requireApprovalToAddMembers:
          _toBool(json['requireApprovalToAddMembers']) ?? false,
      members: membersRaw is List
          ? membersRaw
                .whereType<Map<String, dynamic>>()
                .map(MessageGroupMemberModel.fromJson)
                .toList()
          : const <MessageGroupMemberModel>[],
    );
  }

  static bool? _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final raw = value?.toString().trim().toLowerCase();
    if (raw == null || raw.isEmpty) {
      return null;
    }
    if (raw == 'true' || raw == '1') {
      return true;
    }
    if (raw == 'false' || raw == '0') {
      return false;
    }
    return null;
  }

  static DateTime? _toDate(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }
}
