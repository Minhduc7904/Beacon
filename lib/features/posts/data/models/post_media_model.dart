import '../../domain/entities/post_media.dart';

class PostMediaModel extends PostMedia {
  const PostMediaModel({
    required super.id,
    required super.url,
    required super.type,
    required super.thumbnailUrl,
    super.localImagePath,
    super.localThumbnailPath,
    super.mediaCacheKey,
    super.mediaCachedAtUtc,
    required super.durationSeconds,
    required super.width,
    required super.height,
  });

  factory PostMediaModel.fromJson(Map<String, dynamic> json) {
    return PostMediaModel(
      id: json['id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      localImagePath: json['localImagePath']?.toString(),
      localThumbnailPath: json['localThumbnailPath']?.toString(),
      mediaCacheKey: json['mediaCacheKey']?.toString(),
      mediaCachedAtUtc: _toNullableDate(json['mediaCachedAtUtc']),
      durationSeconds: _toNullableInt(json['durationSeconds']),
      width: _toNullableInt(json['width']),
      height: _toNullableInt(json['height']),
    );
  }

  static int? _toNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }

  static DateTime? _toNullableDate(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw)?.toUtc();
  }
}
