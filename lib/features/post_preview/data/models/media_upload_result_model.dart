import '../../domain/entities/media_upload_result.dart';

class MediaUploadResultModel extends MediaUploadResult {
  const MediaUploadResultModel({
    required super.id,
    required super.url,
    required super.thumbnailUrl,
    required super.objectKey,
    required super.type,
    required super.mimeType,
    required super.size,
    required super.width,
    required super.height,
    required super.createdAt,
    required super.createdBy,
  });

  factory MediaUploadResultModel.fromJson(Map<String, dynamic> json) {
    return MediaUploadResultModel(
      id: json['id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      objectKey: json['objectKey']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      mimeType: json['mimeType']?.toString() ?? '',
      size: _toInt(json['size']),
      width: _toNullableInt(json['width']),
      height: _toNullableInt(json['height']),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      createdBy: json['createdBy']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
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
}
