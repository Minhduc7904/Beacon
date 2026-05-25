import 'package:beacon_app/features/posts/data/models/reaction_summary_model.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_icon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReactionSummaryModel.fromJson', () {
    test('parse totalCount và icons đầy đủ', () {
      final result = ReactionSummaryModel.fromJson({
        'totalCount': 6,
        'icons': {'heart': 2, 'haha': 3, 'like': 1},
      });

      expect(result.totalCount, 6);
      expect(result.icons, {
        PostReactionIcon.heart: 2,
        PostReactionIcon.haha: 3,
        PostReactionIcon.like: 1,
      });
    });

    test('parse count từ num và String theo code hiện tại', () {
      final result = ReactionSummaryModel.fromJson({
        'totalCount': '7',
        'icons': {'heart': 2.9, 'wow': '5'},
      });

      expect(result.totalCount, 7);
      expect(result.icons, {
        PostReactionIcon.heart: 2,
        PostReactionIcon.wow: 5,
      });
    });

    test(
      'ignore unknown icon và parse key icon không phân biệt hoa thường',
      () {
        final result = ReactionSummaryModel.fromJson({
          'totalCount': 3,
          'icons': {'unknown': 1, ' Sad ': 2},
        });

        expect(result.totalCount, 3);
        expect(result.icons, {PostReactionIcon.sad: 2});
      },
    );

    test('fallback totalCount về 0 và icons rỗng khi thiếu icons', () {
      final result = ReactionSummaryModel.fromJson({'totalCount': null});

      expect(result.totalCount, 0);
      expect(result.icons, isEmpty);
    });

    test('fallback count icon về 0 khi value không parse được', () {
      final result = ReactionSummaryModel.fromJson({
        'totalCount': 'invalid',
        'icons': {'heart': 'invalid', 'like': null},
      });

      expect(result.totalCount, 0);
      expect(result.icons, {
        PostReactionIcon.heart: 0,
        PostReactionIcon.like: 0,
      });
    });
  });
}
