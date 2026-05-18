import '../../domain/entities/my_reaction.dart';
import '../../domain/entities/post_reaction_icon.dart';

class MyReactionModel extends MyReaction {
  const MyReactionModel({required super.icon});

  factory MyReactionModel.fromJson(Map<String, dynamic> json) {
    return MyReactionModel(
      icon:
          postReactionIconFromValue(json['icon']?.toString()) ??
          PostReactionIcon.heart,
    );
  }
}
