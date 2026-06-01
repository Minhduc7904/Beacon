import '../models/monthly_checkins_model.dart';
import '../models/safety_settings_model.dart';

abstract class SafetyRemoteDatasource {
  Future<SafetySettingsModel> getSafetySettings();

  Future<MonthlyCheckinsModel> getMonthlyCheckins({
    required int year,
    required int month,
  });

  /// 🔥 PARTIAL UPDATE (PATCH)
  Future<SafetySettingsModel> updateSafetySettings({
    required Map<String, dynamic> body,
  });
}
