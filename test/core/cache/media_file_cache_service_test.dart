import 'dart:io';

import 'package:beacon_app/core/cache/media_file_cache_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late Directory tempDirectory;
  late MockDio dio;
  late MediaFileCacheService service;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('beacon_media_cache_');
    dio = MockDio();
    service = MediaFileCacheService(
      dio: dio,
      supportDirectoryProvider: () async => tempDirectory,
    );
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('cachePostMedia dùng mediaId làm key và không download khi file đã có', () async {
    final existing = File(
      '${tempDirectory.path}${Platform.pathSeparator}cached_media'
      '${Platform.pathSeparator}posts${Platform.pathSeparator}media-1_thumb.jpg',
    );
    await existing.create(recursive: true);
    await existing.writeAsBytes([1, 2, 3]);

    final path = await service.cachePostMedia(
      remoteUrl: 'https://example.com/temporary-signed-url.jpg',
      mediaId: 'media-1',
      variant: MediaFileCacheVariant.thumbnail,
    );

    expect(path, existing.path);
    verifyNever(
      () => dio.download(
        any(),
        any(),
        options: any(named: 'options'),
      ),
    );
  });

  test('cacheKeyFor ưu tiên mediaId rồi objectKey trước khi hash URL', () {
    expect(
      service.cacheKeyFor(
        mediaId: ' media-1 ',
        objectKey: 'object-1',
        remoteUrl: 'https://example.com/a.jpg',
      ),
      'media-1',
    );
    expect(
      service.cacheKeyFor(
        mediaId: ' ',
        objectKey: ' object-1 ',
        remoteUrl: 'https://example.com/a.jpg',
      ),
      'object-1',
    );
    expect(
      service.cacheKeyFor(
        mediaId: '',
        remoteUrl: 'https://example.com/a.jpg?signature=abc',
      ),
      service.cacheKeyFor(
        mediaId: '',
        remoteUrl: 'https://example.com/a.jpg?signature=abc',
      ),
    );
  });

  test('cachePostMedia download file mới vào thư mục cached_media/posts', () async {
    when(
      () => dio.download(
        any(),
        any(),
        options: any(named: 'options'),
      ),
    ).thenAnswer((invocation) async {
      final savePath = invocation.positionalArguments[1] as String;
      await File(savePath).writeAsBytes([1, 2, 3]);
      return Response<void>(
        statusCode: 200,
        requestOptions: RequestOptions(path: 'https://example.com/image.webp'),
      );
    });

    final path = await service.cachePostMedia(
      remoteUrl: 'https://example.com/image.webp?signature=abc',
      mediaId: 'media-1',
      variant: MediaFileCacheVariant.thumbnail,
    );

    expect(path, isNotNull);
    expect(path, endsWith('media-1_thumb.webp'));
    expect(await File(path!).exists(), isTrue);
  });

  test('cleanupPostMedia xóa thumbnail cũ vượt giới hạn và giữ protected path', () async {
    final postsDirectory = Directory(
      '${tempDirectory.path}${Platform.pathSeparator}cached_media'
      '${Platform.pathSeparator}posts',
    );
    await postsDirectory.create(recursive: true);
    final oldFile = File('${postsDirectory.path}${Platform.pathSeparator}old_thumb.jpg');
    final protectedFile = File(
      '${postsDirectory.path}${Platform.pathSeparator}protected_thumb.jpg',
    );
    final newFile = File('${postsDirectory.path}${Platform.pathSeparator}new_thumb.jpg');
    await oldFile.writeAsBytes([1]);
    await protectedFile.writeAsBytes([2]);
    await newFile.writeAsBytes([3]);
    await oldFile.setLastModified(DateTime.utc(2026, 1, 1));
    await protectedFile.setLastModified(DateTime.utc(2026, 1, 2));
    await newFile.setLastModified(DateTime.utc(2026, 1, 3));

    final deleted = await service.cleanupPostMedia(
      maxThumbnails: 1,
      maxOriginals: 100,
      protectedPaths: {protectedFile.path},
    );

    expect(deleted, {oldFile.path});
    expect(await oldFile.exists(), isFalse);
    expect(await protectedFile.exists(), isTrue);
    expect(await newFile.exists(), isTrue);
  });
}
