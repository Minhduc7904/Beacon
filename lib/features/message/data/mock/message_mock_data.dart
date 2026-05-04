import '../../domain/entities/chat_message.dart';
import '../../domain/entities/conversation.dart';

int _autoId = 1000;

/// Mock data for the message feature — simulates a backend.
class MessageMockData {
  MessageMockData._();

  // ─── Mock user names ─────────────────────────────────────────────────────────

  static const _names = [
    'Minh Anh',
    'Hải Đăng',
    'Thu Hà',
    'Quốc Bảo',
    'Ngọc Trâm',
    'Đức Huy',
  ];

  // ─── Conversations ────────────────────────────────────────────────────────────

  static final List<Conversation> conversations = List.unmodifiable([
    Conversation(
      id: 'conv_1',
      participantName: _names[0],
      unreadCount: 2,
      updatedAt: DateTime.now().subtract(const Duration(minutes: 3)),
      lastMessage: ChatMessage(
        id: 'msg_1_5',
        conversationId: 'conv_1',
        content: 'Hẹn gặp lại nhé! 👋',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
    ),
    Conversation(
      id: 'conv_2',
      participantName: _names[1],
      unreadCount: 0,
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      lastMessage: ChatMessage(
        id: 'msg_2_3',
        conversationId: 'conv_2',
        content: 'Ok, mình hiểu rồi!',
        sender: ChatMessageSender.me,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ),
    Conversation(
      id: 'conv_3',
      participantName: _names[2],
      unreadCount: 5,
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      lastMessage: ChatMessage(
        id: 'msg_3_4',
        conversationId: 'conv_3',
        content: 'Bạn check-in hôm nay chưa?',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ),
    Conversation(
      id: 'conv_4',
      participantName: _names[3],
      unreadCount: 0,
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      lastMessage: ChatMessage(
        id: 'msg_4_2',
        conversationId: 'conv_4',
        content: 'Cảm ơn bạn nhiều!',
        sender: ChatMessageSender.me,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ),
    Conversation(
      id: 'conv_5',
      participantName: _names[4],
      unreadCount: 1,
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      lastMessage: ChatMessage(
        id: 'msg_5_3',
        conversationId: 'conv_5',
        content: 'Chúc ngủ ngon 🌙',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ),
    Conversation(
      id: 'conv_6',
      participantName: _names[5],
      unreadCount: 0,
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      lastMessage: ChatMessage(
        id: 'msg_6_1',
        conversationId: 'conv_6',
        content: 'Haha, vui ghê 😂',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ),
  ]);

  // ─── Messages per conversation ────────────────────────────────────────────────

  static final Map<String, List<ChatMessage>> _messages = {
    'conv_1': [
      ChatMessage(
        id: 'msg_1_1',
        conversationId: 'conv_1',
        content: 'Hey! Hôm nay bạn thế nào?',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      ChatMessage(
        id: 'msg_1_2',
        conversationId: 'conv_1',
        content: 'Mình ổn nha, cảm ơn bạn! 😊',
        sender: ChatMessageSender.me,
        createdAt: DateTime.now().subtract(const Duration(minutes: 55)),
      ),
      ChatMessage(
        id: 'msg_1_3',
        conversationId: 'conv_1',
        content: 'Hôm nay mình đã check-in rồi đó.',
        sender: ChatMessageSender.me,
        createdAt: DateTime.now().subtract(const Duration(minutes: 50)),
      ),
      ChatMessage(
        id: 'msg_1_4',
        conversationId: 'conv_1',
        content: 'Tuyệt vời! Giữ streak nhé 🔥',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: 'msg_1_5',
        conversationId: 'conv_1',
        content: 'Hẹn gặp lại nhé! 👋',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
    ],
    'conv_2': [
      ChatMessage(
        id: 'msg_2_1',
        conversationId: 'conv_2',
        content: 'Bạn có biết cách thay đổi avatar không?',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      ChatMessage(
        id: 'msg_2_2',
        conversationId: 'conv_2',
        content: 'Vào Profile > Edit Profile nhé!',
        sender: ChatMessageSender.me,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        id: 'msg_2_3',
        conversationId: 'conv_2',
        content: 'Ok, mình hiểu rồi!',
        sender: ChatMessageSender.me,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
    'conv_3': [
      ChatMessage(
        id: 'msg_3_1',
        conversationId: 'conv_3',
        content: 'Chào bạn! 🌸',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      ChatMessage(
        id: 'msg_3_2',
        conversationId: 'conv_3',
        content: 'Chào Thu Hà!',
        sender: ChatMessageSender.me,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      ChatMessage(
        id: 'msg_3_3',
        conversationId: 'conv_3',
        content: 'Mình thấy app này hay lắm!',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      ChatMessage(
        id: 'msg_3_4',
        conversationId: 'conv_3',
        content: 'Bạn check-in hôm nay chưa?',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ],
    'conv_4': [
      ChatMessage(
        id: 'msg_4_1',
        conversationId: 'conv_4',
        content: 'Mình mới tải app, bạn hướng dẫn mình nhé!',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
      ChatMessage(
        id: 'msg_4_2',
        conversationId: 'conv_4',
        content: 'Cảm ơn bạn nhiều!',
        sender: ChatMessageSender.me,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    'conv_5': [
      ChatMessage(
        id: 'msg_5_1',
        conversationId: 'conv_5',
        content: 'Hôm nay trời đẹp quá! ☀️',
        sender: ChatMessageSender.me,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      ),
      ChatMessage(
        id: 'msg_5_2',
        conversationId: 'conv_5',
        content: 'Ừ, thời tiết tuyệt vời!',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      ),
      ChatMessage(
        id: 'msg_5_3',
        conversationId: 'conv_5',
        content: 'Chúc ngủ ngon 🌙',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ],
    'conv_6': [
      ChatMessage(
        id: 'msg_6_1',
        conversationId: 'conv_6',
        content: 'Haha, vui ghê 😂',
        sender: ChatMessageSender.other,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ],
  };

  /// Returns a mutable copy of messages for the given conversation.
  static List<ChatMessage> messagesFor(String conversationId) {
    return List<ChatMessage>.from(_messages[conversationId] ?? []);
  }

  /// Generate a mock "auto-reply" after the user sends a message.
  static ChatMessage generateAutoReply(String conversationId) {
    const replies = [
      'Ừ, mình hiểu rồi! 👍',
      'Hay quá! Kể thêm đi.',
      'Cảm ơn bạn nhé! 🙏',
      'Wow, thú vị ghê!',
      'Mình cũng nghĩ vậy 😄',
      'Ok nha!',
      'Để mình xem lại nhé.',
      'Haha 😂',
    ];

    final reply = replies[DateTime.now().millisecond % replies.length];

    return ChatMessage(
      id: 'auto_${_autoId++}',
      conversationId: conversationId,
      content: reply,
      sender: ChatMessageSender.other,
      createdAt: DateTime.now(),
    );
  }
}
