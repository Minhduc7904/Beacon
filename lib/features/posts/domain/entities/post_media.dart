class PostMedia {
  final String id;
  final String url;
  final String type;
  final String? thumbnailUrl;
  final String? localImagePath;
  final String? localThumbnailPath;
  final String? mediaCacheKey;
  final DateTime? mediaCachedAtUtc;
  final int? durationSeconds;
  final int? width;
  final int? height;

  const PostMedia({
    required this.id,
    required this.url,
    required this.type,
    required this.thumbnailUrl,
    this.localImagePath,
    this.localThumbnailPath,
    this.mediaCacheKey,
    this.mediaCachedAtUtc,
    required this.durationSeconds,
    required this.width,
    required this.height,
  });

  PostMedia copyWith({
    String? id,
    String? url,
    String? type,
    String? thumbnailUrl,
    bool clearThumbnailUrl = false,
    String? localImagePath,
    bool clearLocalImagePath = false,
    String? localThumbnailPath,
    bool clearLocalThumbnailPath = false,
    String? mediaCacheKey,
    bool clearMediaCacheKey = false,
    DateTime? mediaCachedAtUtc,
    bool clearMediaCachedAtUtc = false,
    int? durationSeconds,
    bool clearDurationSeconds = false,
    int? width,
    bool clearWidth = false,
    int? height,
    bool clearHeight = false,
  }) {
    return PostMedia(
      id: id ?? this.id,
      url: url ?? this.url,
      type: type ?? this.type,
      thumbnailUrl: clearThumbnailUrl
          ? null
          : (thumbnailUrl ?? this.thumbnailUrl),
      localImagePath: clearLocalImagePath
          ? null
          : (localImagePath ?? this.localImagePath),
      localThumbnailPath: clearLocalThumbnailPath
          ? null
          : (localThumbnailPath ?? this.localThumbnailPath),
      mediaCacheKey: clearMediaCacheKey
          ? null
          : (mediaCacheKey ?? this.mediaCacheKey),
      mediaCachedAtUtc: clearMediaCachedAtUtc
          ? null
          : (mediaCachedAtUtc ?? this.mediaCachedAtUtc),
      durationSeconds: clearDurationSeconds
          ? null
          : (durationSeconds ?? this.durationSeconds),
      width: clearWidth ? null : (width ?? this.width),
      height: clearHeight ? null : (height ?? this.height),
    );
  }
}
