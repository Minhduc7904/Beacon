import '../../domain/entities/post_reaction_icon.dart';
import '../../domain/entities/reaction_summary.dart';

class ReactionSummaryModel extends ReactionSummary {
  const ReactionSummaryModel({required super.totalCount, required super.icons});

  factory ReactionSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawIcons = json['icons'];
    final icons = <PostReactionIcon, int>{};

    if (rawIcons is Map<String, dynamic>) {
      for (final entry in rawIcons.entries) {
        final icon = postReactionIconFromValue(entry.key);
        if (icon != null) {
          icons[icon] = _toInt(entry.value);
        }
      }
    }

    return ReactionSummaryModel(
      totalCount: _toInt(json['totalCount']),
      icons: icons,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
