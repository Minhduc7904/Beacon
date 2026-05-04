import '../models/safety_settings_model.dart';

abstract class SafetyRemoteDatasource {
  Future<SafetySettingsModel> getSafetySettings();

  /// 🔥 PARTIAL UPDATE (PATCH)
  Future<SafetySettingsModel> updateSafetySettings({
    required Map<String, dynamic> body,
  });
}
