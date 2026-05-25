import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/posts/domain/entities/my_reaction.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_icon.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_result.dart';
import 'package:beacon_app/features/posts/domain/entities/reaction_summary.dart';
import 'package:beacon_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:beacon_app/features/posts/domain/usecase/set_post_reaction_icon_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsRepository extends Mock implements PostsRepository {}

PostReactionResult _reactionResult() {
  return const PostReactionResult(
    postId: 'post-1',
    myReaction: MyReaction(icon: PostReactionIcon.heart),
    reactionSummary: ReactionSummary(
      totalCount: 1,
      icons: {PostReactionIcon.heart: 1},
    ),
  );
}

void main() {
  late MockPostsRepository repository;
  late SetPostReactionIconUseCase useCase;

  setUp(() {
    repository = MockPostsRepository();
    useCase = SetPostReactionIconUseCase(repository);
  });

  group('SetPostReactionIconUseCase', () {
    test('trả về ValidationFailure khi postId rỗng', () async {
      final result = await useCase(
        const SetPostReactionIconParams(postId: '   ', icon: 'heart'),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postNotFound);
      }, (_) => fail('Expected Left'));
      verifyNever(
        () => repository.setReactionIcon(
          postId: any(named: 'postId'),
          icon: any(named: 'icon'),
        ),
      );
    });

    test('trả về ValidationFailure khi icon rỗng', () async {
      final result = await useCase(
        const SetPostReactionIconParams(postId: 'post-1', icon: '   '),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postInvalidReactionIcon);
      }, (_) => fail('Expected Left'));
      verifyNever(
        () => repository.setReactionIcon(
          postId: any(named: 'postId'),
          icon: any(named: 'icon'),
        ),
      );
    });

    test('trim postId và icon trước khi gọi repository', () async {
      final reactionResult = _reactionResult();
      when(
        () => repository.setReactionIcon(postId: 'post-1', icon: 'heart'),
      ).thenAnswer((_) async => Right(reactionResult));

      final result = await useCase(
        const SetPostReactionIconParams(postId: ' post-1 ', icon: ' heart '),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualResult) => expect(actualResult, same(reactionResult)),
      );
      verify(
        () => repository.setReactionIcon(postId: 'post-1', icon: 'heart'),
      ).called(1);
    });

    test(
      'không whitelist icon và delegate icon non-empty cho repository',
      () async {
        final reactionResult = _reactionResult();
        when(
          () =>
              repository.setReactionIcon(postId: 'post-1', icon: 'custom-icon'),
        ).thenAnswer((_) async => Right(reactionResult));

        final result = await useCase(
          const SetPostReactionIconParams(
            postId: 'post-1',
            icon: 'custom-icon',
          ),
        );

        result.fold(
          (_) => fail('Expected Right'),
          (actualResult) => expect(actualResult, same(reactionResult)),
        );
        verify(
          () =>
              repository.setReactionIcon(postId: 'post-1', icon: 'custom-icon'),
        ).called(1);
      },
    );

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(message: 'Thả reaction thất bại');
      when(
        () => repository.setReactionIcon(postId: 'post-1', icon: 'heart'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(
        const SetPostReactionIconParams(postId: 'post-1', icon: 'heart'),
      );

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });

    test('trả về PostReactionResult khi repository thành công', () async {
      final reactionResult = _reactionResult();
      when(
        () => repository.setReactionIcon(postId: 'post-1', icon: 'heart'),
      ).thenAnswer((_) async => Right(reactionResult));

      final result = await useCase(
        const SetPostReactionIconParams(postId: 'post-1', icon: 'heart'),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualResult) => expect(actualResult, same(reactionResult)),
      );
    });
  });
}
