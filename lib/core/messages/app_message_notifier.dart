import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_message.dart';

class AppMessageNotifier extends StateNotifier<List<AppMessage>> {
  AppMessageNotifier() : super(const []);

  void addSuccess(String message) =>
      _add(AppMessage(message: message, type: MessageType.success));

  void addError(String message) =>
      _add(AppMessage(message: message, type: MessageType.error));

  void addInfo(String message) =>
      _add(AppMessage(message: message, type: MessageType.info));

  void addWarning(String message) =>
      _add(AppMessage(message: message, type: MessageType.warning));

  void _add(AppMessage message) => state = [...state, message];

  void removeMessage(String id) =>
      state = state.where((m) => m.id != id).toList();
}
