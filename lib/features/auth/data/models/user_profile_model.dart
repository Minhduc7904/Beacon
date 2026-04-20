import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.username,
    required super.email,
    required super.familyName,
    required super.givenName,
    required super.phoneNumber,
    required super.timeZone,
    required super.isActive,
    required super.isEmailVerified,
    required super.lastLoginAtUtc,
    required super.createdAtUtc,
    required super.avatarMediaObjectId,
    required super.avatarUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      familyName: json['familyName']?.toString() ?? '',
      givenName: json['givenName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString(),
      timeZone: json['timeZone']?.toString() ?? '',
      isActive: json['isActive'] == true,
      isEmailVerified: json['isEmailVerified'] == true,
      lastLoginAtUtc: _toNullableDateTime(json['lastLoginAtUtc']),
      createdAtUtc: _toDateTime(json['createdAtUtc']),
      avatarMediaObjectId: json['avatarMediaObjectId']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }

  static DateTime _toDateTime(dynamic value) {
    final parsed = DateTime.tryParse(value?.toString() ?? '');
    return parsed ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }

  static DateTime? _toNullableDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    return DateTime.tryParse(value.toString());
  }
}
