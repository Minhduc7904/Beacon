import '../../domain/entities/friend_request.dart';

class FriendRequestModel extends FriendRequest {
  const FriendRequestModel({
    required super.id,
    required super.userId,
    required super.familyName,
    required super.givenName,
    required super.avatarUrl,
    required super.createdAtUtc,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      id: json['id']?.toString() ?? '',
      userId:
          json['receiverId']?.toString() ?? json['senderId']?.toString() ?? '',
      familyName:
          json['receiverFamilyName']?.toString() ??
          json['senderFamilyName']?.toString() ??
          '',
      givenName:
          json['receiverGivenName']?.toString() ??
          json['senderGivenName']?.toString() ??
          '',
      avatarUrl:
          json['receiverAvatarUrl']?.toString() ??
          json['senderAvatarUrl']?.toString(),
      createdAtUtc: _toDate(json['createdAtUtc']),
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
