enum MessageType { success, error, info, warning }

class AppMessage {
  static int _counter = 0;

  final String id;
  final String message;
  final MessageType type;

  AppMessage({required this.message, required this.type})
      : id = (_counter++).toString();
}
