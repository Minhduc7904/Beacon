import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.userId,
    required super.username,
    required super.email,
    required super.familyName,
    required super.givenName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final fullName = json['fullName']?.toString().trim() ?? '';
    var familyName = json['familyName']?.toString().trim() ?? '';
    var givenName = json['givenName']?.toString().trim() ?? '';

    if ((familyName.isEmpty || givenName.isEmpty) && fullName.isNotEmpty) {
      final nameParts = fullName
          .split(RegExp(r'\s+'))
          .where((part) => part.isNotEmpty)
          .toList();

      if (nameParts.isNotEmpty) {
        if (givenName.isEmpty) {
          givenName = nameParts.last;
        }
        if (familyName.isEmpty) {
          familyName = nameParts.length > 1
              ? nameParts.sublist(0, nameParts.length - 1).join(' ')
              : '';
        }
      }
    }

    return UserModel(
      userId: json['userId']?.toString() ?? '',
      username: json['username'] as String? ?? '',
      email: json['email']?.toString() ?? '',
      familyName: familyName,
      givenName: givenName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'familyName': familyName,
      'givenName': givenName,
      'fullName': fullName,
    };
  }
}
