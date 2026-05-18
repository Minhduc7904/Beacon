import '../../domain/entities/post_reaction_detail.dart';
import 'post_reaction_user_model.dart';

class PostReactionDetailModel extends PostReactionDetail {
  const PostReactionDetailModel({
    required super.reactionId,
    required super.icon,
    required super.reactedAtUtc,
    required super.user,
  });

  factory PostReactionDetailModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return PostReactionDetailModel(
      reactionId: json['reactionId']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      reactedAtUtc:
          DateTime.tryParse(json['reactedAtUtc']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      user: userJson is Map<String, dynamic>
          ? PostReactionUserModel.fromJson(userJson)
          : const PostReactionUserModel(
              id: '',
              displayName: '',
              avatarUrl: null,
            ),
    );
  }
}
