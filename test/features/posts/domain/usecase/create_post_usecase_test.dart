import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/posts/domain/entities/post.dart';
import 'package:beacon_app/features/posts/domain/entities/post_media.dart';
import 'package:beacon_app/features/posts/domain/entities/post_visibility.dart';
import 'package:beacon_app/features/posts/domain/entities/reaction_summary.dart';
import 'package:beacon_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:beacon_app/features/posts/domain/usecase/create_post_usecase.dart';
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
    updatedAtUtc: null,
    latitude: null,
    longitude: null,
    dailySafetyRecordId: null,
    dailySafetyRecord: null,
    reactionSummary: const ReactionSummary.empty(),
    myReaction: null,
  );
}

void _verifyCreatePostNeverCalled(MockPostsRepository repository) {
  verifyNever(
    () => repository.createPost(
      mediaId: any(named: 'mediaId'),
      caption: any(named: 'caption'),
      visibility: any(named: 'visibility'),
      latitude: any(named: 'latitude'),
      longitude: any(named: 'longitude'),
    ),
  );
}

void main() {
  late MockPostsRepository repository;
  late CreatePostUseCase useCase;

  setUpAll(() {
    registerFallbackValue(PostVisibility.friends);
  });

  setUp(() {
    repository = MockPostsRepository();
    useCase = CreatePostUseCase(repository);
  });

  group('CreatePostUseCase', () {
    test('trả về ValidationFailure khi mediaId rỗng', () async {
      final result = await useCase(const CreatePostParams(mediaId: '   '));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postMediaNotFound);
      }, (_) => fail('Expected Left'));
      _verifyCreatePostNeverCalled(repository);
    });

    test('trả về ValidationFailure khi caption dài hơn 2000 ký tự', () async {
      final caption = List.filled(2001, 'a').join();

      final result = await useCase(
        CreatePostParams(mediaId: 'media-1', caption: caption),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postCaptionTooLong);
      }, (_) => fail('Expected Left'));
      _verifyCreatePostNeverCalled(repository);
    });

    test('trả về ValidationFailure khi location chỉ có latitude', () async {
      final result = await useCase(
        const CreatePostParams(mediaId: 'media-1', latitude: 10.5),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postValidationError);
      }, (_) => fail('Expected Left'));
      _verifyCreatePostNeverCalled(repository);
    });

    test('trả về ValidationFailure khi location chỉ có longitude', () async {
      final result = await useCase(
        const CreatePostParams(mediaId: 'media-1', longitude: 106.7),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postValidationError);
      }, (_) => fail('Expected Left'));
      _verifyCreatePostNeverCalled(repository);
    });

    test('trả về ValidationFailure khi latitude ngoài khoảng hợp lệ', () async {
      final result = await useCase(
        const CreatePostParams(
          mediaId: 'media-1',
          latitude: 91,
          longitude: 106.7,
        ),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.postValidationError);
      }, (_) => fail('Expected Left'));
      _verifyCreatePostNeverCalled(repository);
    });

    test(
      'trả về ValidationFailure khi longitude ngoài khoảng hợp lệ',
      () async {
        final result = await useCase(
          const CreatePostParams(
            mediaId: 'media-1',
            latitude: 10.5,
            longitude: 181,
          ),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.postValidationError);
        }, (_) => fail('Expected Left'));
        _verifyCreatePostNeverCalled(repository);
      },
    );

    test('trim mediaId và gửi caption null khi caption blank', () async {
      final post = _post(caption: null);
      when(
        () => repository.createPost(
          mediaId: 'media-1',
          caption: null,
          visibility: PostVisibility.friends,
          latitude: null,
          longitude: null,
        ),
      ).thenAnswer((_) async => Right(post));

      final result = await useCase(
        const CreatePostParams(mediaId: '  media-1  ', caption: '   '),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualPost) => expect(actualPost, same(post)),
      );
      verify(
        () => repository.createPost(
          mediaId: 'media-1',
          caption: null,
          visibility: PostVisibility.friends,
          latitude: null,
          longitude: null,
        ),
      ).called(1);
    });

    test('gọi repository với params đã normalize khi input hợp lệ', () async {
      final post = _post(caption: 'Một ngày an toàn');
      when(
        () => repository.createPost(
          mediaId: 'media-1',
          caption: 'Một ngày an toàn',
          visibility: PostVisibility.private,
          latitude: 10.5,
          longitude: 106.7,
        ),
      ).thenAnswer((_) async => Right(post));

      final result = await useCase(
        const CreatePostParams(
          mediaId: ' media-1 ',
          caption: '  Một ngày an toàn  ',
          visibility: PostVisibility.private,
          latitude: 10.5,
          longitude: 106.7,
        ),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualPost) => expect(actualPost, same(post)),
      );
      verify(
        () => repository.createPost(
          mediaId: 'media-1',
          caption: 'Một ngày an toàn',
          visibility: PostVisibility.private,
          latitude: 10.5,
          longitude: 106.7,
        ),
      ).called(1);
    });

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(message: 'Tạo bài viết thất bại');
      when(
        () => repository.createPost(
          mediaId: 'media-1',
          caption: null,
          visibility: PostVisibility.friends,
          latitude: null,
          longitude: null,
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(const CreatePostParams(mediaId: 'media-1'));

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });
  });
}
