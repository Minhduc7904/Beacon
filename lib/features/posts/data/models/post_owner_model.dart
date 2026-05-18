import '../../domain/entities/post_owner.dart';

class PostOwnerModel extends PostOwner {
  const PostOwnerModel({
    required super.id,
    required super.displayName,
    required super.avatarUrl,
  });

  factory PostOwnerModel.fromJson(Map<String, dynamic> json) {
    return PostOwnerModel(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }
}
