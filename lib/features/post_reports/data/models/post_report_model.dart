import '../../domain/entities/post_report.dart';

class PostReportModel extends PostReport {
  const PostReportModel({
    required super.id,
    required super.postId,
    required super.reporterUserId,
    required super.reason,
    required super.description,
    required super.status,
    required super.createdAtUtc,
  });

  factory PostReportModel.fromJson(Map<String, dynamic> json) {
    return PostReportModel(
      id: json['id']?.toString() ?? '',
      postId: json['postId']?.toString() ?? '',
      reporterUserId: json['reporterUserId']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      description: json['description']?.toString(),
      status: json['status']?.toString() ?? '',
      createdAtUtc:
          DateTime.tryParse(json['createdAtUtc']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }
}
