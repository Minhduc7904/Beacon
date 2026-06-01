import '../models/checkin_record_model.dart';
import '../models/today_status_model.dart';

abstract class CheckinRemoteDatasource {
  Future<CheckinRecordModel> checkin({
    String? note,
    String? mediaId,
    String? mood,
  });

  Future<TodayStatusModel> getTodayStatus();
}
