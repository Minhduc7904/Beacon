class PostMedia {
  final String id;
  final String url;
  final String type;
  final String? thumbnailUrl;
  final int? durationSeconds;
  final int? width;
  final int? height;

  const PostMedia({
    required this.id,
    required this.url,
    required this.type,
    required this.thumbnailUrl,
    required this.durationSeconds,
    required this.width,
    required this.height,
  });
}
