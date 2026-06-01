import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/checkin_record.dart';
import '../entities/today_status.dart';

abstract class CheckinRepository {
  Future<Either<Failure, TodayStatus>> getTodayStatus();

  Future<Either<Failure, CheckinRecord>> checkin({
    String? note,
    String? mediaId,
    String? mood,
  });
}
