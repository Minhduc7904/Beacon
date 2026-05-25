import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/posts/domain/entities/my_reaction.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_icon.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_result.dart';
import 'package:beacon_app/features/posts/domain/entities/reaction_summary.dart';
import 'package:beacon_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:beacon_app/features/posts/domain/usecase/set_post_reaction_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsRepository extends Mock implements PostsRepository {}

PostReactionResult _reactionResult({
  PostReactionIcon icon = PostReactionIcon.like,
}) {
  return PostReactionResult(
    postId: 'post-1',
    myReaction: MyReaction(icon: icon),
    reactionSummary: ReactionSummary(totalCount: 1, icons: {icon: 1}),
  );
}

void main() {
  late MockPostsRepository repository;
  late SetPostReactionUseCase useCase;

  setUp(() {
    repository = MockPostsRepository();
    useCase = SetPostReactionUseCase(repository);
  });

  group('SetPostReactionUseCase', () {
    test('trả về ValidationFailure khi postId rỗng', () async {
      final result = await useCase(
        const SetPostReactionParams(postId: '   ', icon: PostReactionIcon.like),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postNotFound);
      }, (_) => fail('Expected Left'));
      verifyNever(
        () => repository.setReaction(
          postId: any(named: 'postId'),
          icon: PostReactionIcon.like,
        ),
      );
    });

    test('trim postId và gọi repository với icon hợp lệ', () async {
      final reactionResult = _reactionResult(icon: PostReactionIcon.wow);
      when(
        () => repository.setReaction(
          postId: 'post-1',
          icon: PostReactionIcon.wow,
        ),
      ).thenAnswer((_) async => Right(reactionResult));

      final result = await useCase(
        const SetPostReactionParams(
          postId: ' post-1 ',
          icon: PostReactionIcon.wow,
        ),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualResult) => expect(actualResult, same(reactionResult)),
      );
      verify(
        () => repository.setReaction(
          postId: 'post-1',
          icon: PostReactionIcon.wow,
        ),
      ).called(1);
    });

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(message: 'Thả reaction thất bại');
      when(
        () => repository.setReaction(
          postId: 'post-1',
          icon: PostReactionIcon.heart,
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(
        const SetPostReactionParams(
          postId: 'post-1',
          icon: PostReactionIcon.heart,
        ),
      );

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });

    test('trả về PostReactionResult khi repository thành công', () async {
      final reactionResult = _reactionResult(icon: PostReactionIcon.haha);
      when(
        () => repository.setReaction(
          postId: 'post-1',
          icon: PostReactionIcon.haha,
        ),
      ).thenAnswer((_) async => Right(reactionResult));

      final result = await useCase(
        const SetPostReactionParams(
          postId: 'post-1',
          icon: PostReactionIcon.haha,
        ),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualResult) => expect(actualResult, same(reactionResult)),
      );
    });
  });
}
