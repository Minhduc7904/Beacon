class MessageGroupRealtimeConstants {
  MessageGroupRealtimeConstants._();

  static const String joinMessageGroupMethod = 'JoinMessageGroup';
  static const String leaveMessageGroupMethod = 'LeaveMessageGroup';
  static const String sendTypingStatusMethod = 'SendTypingStatus';
  static const String messageReceivedEvent = 'ReceiveMessage';
  static const String receiveNewMessageEvent = 'ReceiveNewMessage';
  static const String receiveTypingStatusEvent = 'ReceiveTypingStatus';
  static const String receiveUnreadMessageCountEvent =
      'ReceiveUnreadMessageCount';
  static const String receiveMessageGroupSeenEvent = 'ReceiveMessageGroupSeen';
  static const String receiveMessageSeenEvent = 'ReceiveMessageSeen';
}
