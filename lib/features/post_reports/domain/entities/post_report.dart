class PostReport {
  final String id;
  final String postId;
  final String reporterUserId;
  final String reason;
  final String? description;
  final String status;
  final DateTime createdAtUtc;

  const PostReport({
    required this.id,
    required this.postId,
    required this.reporterUserId,
    required this.reason,
    required this.description,
    required this.status,
    required this.createdAtUtc,
  });
}
