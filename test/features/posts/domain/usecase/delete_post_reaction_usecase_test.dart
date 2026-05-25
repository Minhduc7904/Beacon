import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_result.dart';
import 'package:beacon_app/features/posts/domain/entities/reaction_summary.dart';
import 'package:beacon_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:beacon_app/features/posts/domain/usecase/delete_post_reaction_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsRepository extends Mock implements PostsRepository {}

const _reactionResult = PostReactionResult(
  postId: 'post-1',
  myReaction: null,
  reactionSummary: ReactionSummary.empty(),
);

void main() {
  late MockPostsRepository repository;
  late DeletePostReactionUseCase useCase;

  setUp(() {
    repository = MockPostsRepository();
    useCase = DeletePostReactionUseCase(repository);
  });

  group('DeletePostReactionUseCase', () {
    test('trả về ValidationFailure khi postId rỗng', () async {
      final result = await useCase(
        const DeletePostReactionParams(postId: '   '),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postNotFound);
      }, (_) => fail('Expected Left'));
      verifyNever(
        () => repository.deleteReaction(postId: any(named: 'postId')),
      );
    });

    test('trim postId trước khi gọi repository', () async {
      when(
        () => repository.deleteReaction(postId: 'post-1'),
      ).thenAnswer((_) async => const Right(_reactionResult));

      final result = await useCase(
        const DeletePostReactionParams(postId: ' post-1 '),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualResult) => expect(actualResult, same(_reactionResult)),
      );
      verify(() => repository.deleteReaction(postId: 'post-1')).called(1);
    });

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(message: 'Xóa reaction thất bại');
      when(
        () => repository.deleteReaction(postId: 'post-1'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(
        const DeletePostReactionParams(postId: 'post-1'),
      );

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });

    test('trả về PostReactionResult khi repository thành công', () async {
      when(
        () => repository.deleteReaction(postId: 'post-1'),
      ).thenAnswer((_) async => const Right(_reactionResult));

      final result = await useCase(
        const DeletePostReactionParams(postId: 'post-1'),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualResult) => expect(actualResult, same(_reactionResult)),
      );
    });
  });
}
