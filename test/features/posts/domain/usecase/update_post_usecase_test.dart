import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/posts/domain/entities/post.dart';
import 'package:beacon_app/features/posts/domain/entities/post_media.dart';
import 'package:beacon_app/features/posts/domain/entities/post_visibility.dart';
import 'package:beacon_app/features/posts/domain/entities/reaction_summary.dart';
import 'package:beacon_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:beacon_app/features/posts/domain/usecase/update_post_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsRepository extends Mock implements PostsRepository {}

Post _post({String? caption = 'Caption'}) {
  return Post(
    id: 'post-1',
    ownerUserId: 'user-1',
    owner: null,
    media: const PostMedia(
      id: 'media-1',
      url: 'https://example.com/media.jpg',
      type: 'image',
      thumbnailUrl: null,
      durationSeconds: null,
      width: 1080,
      height: 1080,
    ),
    caption: caption,
    visibility: PostVisibility.friends,
    status: 'published',
    createdAtUtc: DateTime.utc(2026, 5, 26),
    updatedAtUtc: DateTime.utc(2026, 5, 26, 1),
    latitude: null,
    longitude: null,
    dailySafetyRecordId: null,
    dailySafetyRecord: null,
    reactionSummary: const ReactionSummary.empty(),
    myReaction: null,
  );
}

void _verifyUpdatePostNeverCalled(MockPostsRepository repository) {
  verifyNever(
    () => repository.updatePost(
      postId: any(named: 'postId'),
      caption: any(named: 'caption'),
      visibility: any(named: 'visibility'),
    ),
  );
}

void main() {
  late MockPostsRepository repository;
  late UpdatePostUseCase useCase;

  setUpAll(() {
    registerFallbackValue(PostVisibility.friends);
  });

  setUp(() {
    repository = MockPostsRepository();
    useCase = UpdatePostUseCase(repository);
  });

  group('UpdatePostUseCase', () {
    test('trả về ValidationFailure khi postId rỗng', () async {
      final result = await useCase(
        const UpdatePostParams(postId: '   ', caption: 'Caption'),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postNotFound);
      }, (_) => fail('Expected Left'));
      _verifyUpdatePostNeverCalled(repository);
    });

    test('trả về ValidationFailure khi không có field nào thay đổi', () async {
      final result = await useCase(const UpdatePostParams(postId: 'post-1'));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postValidationError);
      }, (_) => fail('Expected Left'));
      _verifyUpdatePostNeverCalled(repository);
    });

    test('trả về ValidationFailure khi caption dài hơn 2000 ký tự', () async {
      final caption = List.filled(2001, 'a').join();

      final result = await useCase(
        UpdatePostParams(postId: 'post-1', caption: caption),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postCaptionTooLong);
      }, (_) => fail('Expected Left'));
      _verifyUpdatePostNeverCalled(repository);
    });

    test('gọi repository với caption rỗng khi caption blank', () async {
      final post = _post(caption: '');
      when(
        () => repository.updatePost(
          postId: 'post-1',
          caption: '',
          visibility: null,
        ),
      ).thenAnswer((_) async => Right(post));

      final result = await useCase(
        const UpdatePostParams(postId: ' post-1 ', caption: '   '),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualPost) => expect(actualPost, same(post)),
      );
      verify(
        () => repository.updatePost(
          postId: 'post-1',
          caption: '',
          visibility: null,
        ),
      ).called(1);
    });

    test(
      'gọi repository với postId và caption đã trim khi input hợp lệ',
      () async {
        final post = _post(caption: 'Caption mới');
        when(
          () => repository.updatePost(
            postId: 'post-1',
            caption: 'Caption mới',
            visibility: PostVisibility.private,
          ),
        ).thenAnswer((_) async => Right(post));

        final result = await useCase(
          const UpdatePostParams(
            postId: ' post-1 ',
            caption: '  Caption mới  ',
            visibility: PostVisibility.private,
          ),
        );

        result.fold(
          (_) => fail('Expected Right'),
          (actualPost) => expect(actualPost, same(post)),
        );
        verify(
          () => repository.updatePost(
            postId: 'post-1',
            caption: 'Caption mới',
            visibility: PostVisibility.private,
          ),
        ).called(1);
      },
    );

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(message: 'Cập nhật bài viết thất bại');
      when(
        () => repository.updatePost(
          postId: 'post-1',
          caption: null,
          visibility: PostVisibility.private,
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(
        const UpdatePostParams(
          postId: 'post-1',
          visibility: PostVisibility.private,
        ),
      );

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });

    test('trả về Post khi repository cập nhật thành công', () async {
      final post = _post(caption: 'Caption mới');
      when(
        () => repository.updatePost(
          postId: 'post-1',
          caption: 'Caption mới',
          visibility: null,
        ),
      ).thenAnswer((_) async => Right(post));

      final result = await useCase(
        const UpdatePostParams(postId: 'post-1', caption: 'Caption mới'),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualPost) => expect(actualPost, same(post)),
      );
    });
  });
}
