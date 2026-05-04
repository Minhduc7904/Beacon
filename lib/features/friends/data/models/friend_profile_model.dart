import '../../domain/entities/friend_profile.dart';
import '../../domain/entities/friend_type.dart';

class FriendProfileModel extends FriendProfile {
  const FriendProfileModel({
    required super.userId,
    required super.username,
    required super.avatarUrl,
    required super.type,
    required super.createdAtUtc,
    required super.messageGroupId,
  });

  factory FriendProfileModel.fromJson(Map<String, dynamic> json) {
    return FriendProfileModel(
      userId: json['userId']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
      type: FriendTypeValue.fromValue(_toInt(json['type'])),
      createdAtUtc: _toDate(json['createdAtUtc']),
      messageGroupId: json['messageGroupId']?.toString() ?? '',
    );
  }

  static DateTime? _toDate(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 2;
  }
}
