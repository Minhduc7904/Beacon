import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String userId,
    required String username,
    required String fullName,
  }) : super(userId: userId, username: username, fullName: fullName);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId']?.toString() ?? '',
      username: json['username'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'username': username, 'fullName': fullName};
  }
}
