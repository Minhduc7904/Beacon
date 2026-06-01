import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

enum MediaFileCacheVariant { thumbnail, original }

class MediaFileCacheService {
  static const int defaultMaxPostThumbnails = 300;
  static const int defaultMaxPostOriginals = 100;

  final Dio _dio;
  final Future<Directory> Function() _supportDirectoryProvider;

  MediaFileCacheService({
    required Dio dio,
    Future<Directory> Function()? supportDirectoryProvider,
  }) : _dio = dio,
       _supportDirectoryProvider =
           supportDirectoryProvider ?? getApplicationSupportDirectory;

  Future<String?> cachePostMedia({
    required String remoteUrl,
    required String? mediaId,
    String? objectKey,
    required MediaFileCacheVariant variant,
  }) async {
    final url = remoteUrl.trim();
    if (url.isEmpty) {
      return null;
    }

    final directory = await _postMediaDirectory();
    final fileName = _fileName(
      remoteUrl: url,
      mediaId: mediaId,
      objectKey: objectKey,
      variant: variant,
    );
    final file = File(_joinPath(directory.path, fileName));
    if (await file.exists()) {
      await file.setLastModified(DateTime.now().toUtc());
      return file.path;
    }

    final tempFile = File('${file.path}.download');
    try {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      final response = await _dio.download(
        url,
        tempFile.path,
        options: Options(responseType: ResponseType.bytes),
      );
      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        await _deleteIfExists(tempFile);
        return null;
      }

      if (await file.exists()) {
        await file.delete();
      }
      await tempFile.rename(file.path);
      return file.path;
    } catch (_) {
      await _deleteIfExists(tempFile);
      return null;
    }
  }

  String cacheKeyFor({
    required String? mediaId,
    String? objectKey,
    required String remoteUrl,
  }) {
    return _firstNonEmpty([mediaId, objectKey]) ?? _stableHash(remoteUrl);
  }

  Future<Set<String>> cleanupPostMedia({
    int maxThumbnails = defaultMaxPostThumbnails,
    int maxOriginals = defaultMaxPostOriginals,
    Set<String> protectedPaths = const <String>{},
  }) async {
    final directory = await _postMediaDirectory();
    final files = directory
        .listSync(followLinks: false)
        .whereType<File>()
        .toList(growable: false);

    final deleted = <String>{};
    deleted.addAll(
      await _cleanupFiles(
        files: files.where((file) => _isVariantFile(
          file,
          MediaFileCacheVariant.thumbnail,
        )),
        limit: maxThumbnails,
        protectedPaths: protectedPaths,
      ),
    );
    deleted.addAll(
      await _cleanupFiles(
        files: files.where((file) => _isVariantFile(
          file,
          MediaFileCacheVariant.original,
        )),
        limit: maxOriginals,
        protectedPaths: protectedPaths,
      ),
    );
    return deleted;
  }

  Future<Directory> _postMediaDirectory() async {
    final supportDirectory = await _supportDirectoryProvider();
    final directory = Directory(
      _joinPath(supportDirectory.path, 'cached_media', 'posts'),
    );
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  Future<Set<String>> _cleanupFiles({
    required Iterable<File> files,
    required int limit,
    required Set<String> protectedPaths,
  }) async {
    if (limit < 1) {
      return const <String>{};
    }

    final candidates = files
        .where((file) => !protectedPaths.contains(file.path))
        .toList(growable: false)
      ..sort((a, b) {
        final left = a.lastModifiedSync();
        final right = b.lastModifiedSync();
        return left.compareTo(right);
      });

    final overflow = candidates.length - limit;
    if (overflow <= 0) {
      return const <String>{};
    }

    final deleted = <String>{};
    for (final file in candidates.take(overflow)) {
      final filePath = file.path;
      try {
        await file.delete();
        deleted.add(filePath);
      } catch (_) {
        // Cleanup is best-effort; stale DB paths still fall back in the UI.
      }
    }
    return deleted;
  }

  bool _isVariantFile(File file, MediaFileCacheVariant variant) {
    final name = _basename(file.path);
    return name.contains('_${_variantSuffix(variant)}.');
  }

  String _fileName({
    required String remoteUrl,
    required String? mediaId,
    required String? objectKey,
    required MediaFileCacheVariant variant,
  }) {
    final rawKey = cacheKeyFor(
      mediaId: mediaId,
      objectKey: objectKey,
      remoteUrl: remoteUrl,
    );
    final safeKey = _sanitizeFilePart(rawKey);
    final extension = _extensionForUrl(remoteUrl);
    return '${safeKey}_${_variantSuffix(variant)}$extension';
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final normalized = value?.trim();
      if (normalized != null && normalized.isNotEmpty) {
        return normalized;
      }
    }
    return null;
  }

  String _variantSuffix(MediaFileCacheVariant variant) {
    switch (variant) {
      case MediaFileCacheVariant.thumbnail:
        return 'thumb';
      case MediaFileCacheVariant.original:
        return 'original';
    }
  }

  String _extensionForUrl(String remoteUrl) {
    final uri = Uri.tryParse(remoteUrl);
    final rawExtension = uri == null ? '' : _extension(uri.path);
    final extension = rawExtension.toLowerCase();
    if (extension.length >= 2 && extension.length <= 6) {
      return extension;
    }
    return '.jpg';
  }

  String _sanitizeFilePart(String value) {
    final sanitized = value
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    if (sanitized.isEmpty) {
      return _stableHash(value);
    }
    return sanitized.length <= 96 ? sanitized : sanitized.substring(0, 96);
  }

  String _stableHash(String value) {
    var hash = 0xcbf29ce484222325;
    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x100000001b3) & 0x7fffffffffffffff;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }

  Future<void> _deleteIfExists(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
  }

  String _joinPath(String first, String second, [String? third]) {
    final separator = Platform.pathSeparator;
    final parts = [
      first,
      second,
      if (third != null) third,
    ];
    return parts
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .join(separator);
  }

  String _basename(String filePath) {
    final normalized = filePath.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    return index == -1 ? normalized : normalized.substring(index + 1);
  }

  String _extension(String uriPath) {
    final fileName = _basename(uriPath);
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex <= 0 || dotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(dotIndex);
  }
}
