enum ChatMessageSender { me, other }

class ChatMessage {
  final String id;
  final String conversationId;
  final String content;
  final ChatMessageSender sender;
  final DateTime createdAt;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.sender,
    required this.createdAt,
    this.isRead = false,
  });

  bool get isMe => sender == ChatMessageSender.me;

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? content,
    ChatMessageSender? sender,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
