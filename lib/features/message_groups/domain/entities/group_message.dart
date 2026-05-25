import '../../../posts/domain/entities/post.dart';

enum GroupMessageType {
  normal(0),
  nicknameChanged(1),
  roleChanged(2),
  memberAdded(3),
  memberLeft(4),
  memberNicknameChanged(5),
  groupAvatarChanged(6),
  groupDeleted(7),
  groupApprovalSettingChanged(8),
  memberApproved(9),
  memberDenied(10),
  groupNameChanged(11);

  const GroupMessageType(this.value);

  final int value;

  static GroupMessageType fromValue(dynamic value) {
    final parsed = value is int
        ? value
        : value is num
        ? value.toInt()
        : int.tryParse(value?.toString() ?? '');

    if (parsed != null) {
      return GroupMessageType.values.firstWhere(
        (type) => type.value == parsed,
        orElse: () => GroupMessageType.normal,
      );
    }

    final normalized = value
        ?.toString()
        .trim()
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return GroupMessageType.normal;
    }

    return GroupMessageType.values.firstWhere(
      (type) =>
          type.name.toLowerCase() == normalized ||
          type.name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase() ==
              normalized,
      orElse: () => GroupMessageType.normal,
    );
  }
}

class GroupMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderDisplayName;
  final String senderFamilyName;
  final String senderGivenName;
  final String content;
  final DateTime? createdAtUtc;
  final String? postId;
  final Post? post;
  final GroupMessageType type;
  final String? metadataJson;

  const GroupMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    this.senderDisplayName = '',
    required this.senderFamilyName,
    required this.senderGivenName,
    required this.content,
    required this.createdAtUtc,
    required this.postId,
    required this.post,
    this.type = GroupMessageType.normal,
    this.metadataJson,
  });

  String get senderFullName {
    final displayName = senderDisplayName.trim();
    if (displayName.isNotEmpty) {
      return displayName;
    }

    return [
      senderFamilyName.trim(),
      senderGivenName.trim(),
    ].where((part) => part.isNotEmpty).join(' ');
  }

  bool get isSystemMessage => type != GroupMessageType.normal;
}
