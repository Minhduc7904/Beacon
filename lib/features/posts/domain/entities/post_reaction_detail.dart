import 'post_reaction_user.dart';

class PostReactionDetail {
  final String reactionId;
  final String icon;
  final DateTime reactedAtUtc;
  final PostReactionUser user;

  const PostReactionDetail({
    required this.reactionId,
    required this.icon,
    required this.reactedAtUtc,
    required this.user,
  });

  List<String> get icons {
    return icon
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }
}
