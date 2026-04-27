import 'chat_message.dart';

class Conversation {
  final String id;
  final String participantName;
  final String? participantAvatarUrl;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;

  const Conversation({
    required this.id,
    required this.participantName,
    this.participantAvatarUrl,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
  });

  Conversation copyWith({
    String? id,
    String? participantName,
    String? participantAvatarUrl,
    ChatMessage? lastMessage,
    int? unreadCount,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantName: participantName ?? this.participantName,
      participantAvatarUrl: participantAvatarUrl ?? this.participantAvatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
