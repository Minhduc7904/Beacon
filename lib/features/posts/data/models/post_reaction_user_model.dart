import '../../domain/entities/post_reaction_user.dart';

class PostReactionUserModel extends PostReactionUser {
  const PostReactionUserModel({
    required super.id,
    required super.displayName,
    required super.avatarUrl,
  });

  factory PostReactionUserModel.fromJson(Map<String, dynamic> json) {
    return PostReactionUserModel(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }
}
