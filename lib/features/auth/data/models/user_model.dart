import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int userId,
    required String firstName,
    required String lastName,
  }) : super(userId: userId, firstName: firstName, lastName: lastName);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'firstName': firstName, 'lastName': lastName};
  }
}
