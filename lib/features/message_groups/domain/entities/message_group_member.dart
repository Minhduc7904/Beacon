class MessageGroupMember {
  final String userId;
  final String? familyName;
  final String? givenName;
  final String? customName;
  final String? avatarUrl;
  final int role;
  final String? lastSeenMessageId;
  final DateTime? lastSeenAtUtc;

  const MessageGroupMember({
    required this.userId,
    required this.familyName,
    required this.givenName,
    required this.customName,
    required this.avatarUrl,
    required this.role,
    required this.lastSeenMessageId,
    required this.lastSeenAtUtc,
  });

  String get fullName {
    return [
      familyName?.trim() ?? '',
      givenName?.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
  }

  bool get isAdminRole => role == 1 || role == 2;

  String get roleLabelVi {
    switch (role) {
      case 1:
        return 'Chủ nhóm';
      case 2:
        return 'Quản trị viên';
      case 0:
      default:
        return 'Thành viên';
    }
  }
}
