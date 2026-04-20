class MediaUploadResult {
  final String id;
  final String url;
  final String? thumbnailUrl;
  final String objectKey;
  final String type;
  final String mimeType;
  final int size;
  final int? width;
  final int? height;
  final DateTime? createdAt;
  final String createdBy;

  const MediaUploadResult({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.objectKey,
    required this.type,
    required this.mimeType,
    required this.size,
    required this.width,
    required this.height,
    required this.createdAt,
    required this.createdBy,
  });
}
