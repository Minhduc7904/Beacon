import '../../../posts/domain/entities/post.dart';

class GroupMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderFamilyName;
  final String senderGivenName;
  final String content;
  final DateTime? createdAtUtc;
  final String? postId;
  final Post? post;

  const GroupMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderFamilyName,
    required this.senderGivenName,
    required this.content,
    required this.createdAtUtc,
    required this.postId,
    required this.post,
  });

  String get senderFullName {
    return [
      senderFamilyName.trim(),
      senderGivenName.trim(),
    ].where((part) => part.isNotEmpty).join(' ');
  }
}
