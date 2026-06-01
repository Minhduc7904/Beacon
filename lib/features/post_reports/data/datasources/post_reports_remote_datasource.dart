import '../models/post_report_model.dart';

abstract class PostReportsRemoteDatasource {
  Future<PostReportModel> reportPost({
    required String postId,
    required String reason,
    String? description,
  });
}
