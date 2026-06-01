import 'dart:async';

import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/core/messages/app_message_notifier.dart';
import 'package:beacon_app/features/home/domain/entities/checkin_record.dart';
import 'package:beacon_app/features/home/domain/entities/today_status.dart';
import 'package:beacon_app/features/home/domain/usecase/checkin_usecase.dart';
import 'package:beacon_app/features/home/domain/usecase/get_today_status_usecase.dart';
import 'package:beacon_app/features/home/presentation/controllers/home_checkin_notifier.dart';
import 'package:beacon_app/features/home/presentation/controllers/home_checkin_state.dart';
import 'package:beacon_app/features/safety/domain/entities/safety_settings.dart';
import 'package:beacon_app/features/safety/domain/usecase/get_safety_settings_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTodayStatusUseCase extends Mock implements GetTodayStatusUseCase {}

class MockCheckinUseCase extends Mock implements CheckinUseCase {}

class MockGetSafetySettingsUseCase extends Mock
    implements GetSafetySettingsUseCase {}

class MockAppMessageNotifier extends Mock implements AppMessageNotifier {}

TodayStatus _todayStatus({
  bool hasCheckedIn = false,
  TodayStatusType status = TodayStatusType.pending,
  int streak = 2,
  DateTime? deadlineAtUtc,
  int? remainingSeconds,
  DateTime? checkedInAtUtc,
  bool isMonitoringEnabled = true,
  bool isAutoAlertEnabled = true,
}) {
  return TodayStatus(
    hasCheckedIn: hasCheckedIn,
    status: status,
    streak: streak,
    deadlineAtUtc: deadlineAtUtc,
    remainingSeconds: remainingSeconds,
    checkedInAtUtc: checkedInAtUtc,
    isMonitoringEnabled: isMonitoringEnabled,
    isAutoAlertEnabled: isAutoAlertEnabled,
  );
}

SafetySettings _settings({int autoAlertDelayMinutes = 5}) {
  return SafetySettings(
    dailyDeadlineLocalTime: '22:00',
    gracePeriodMinutes: 10,
    reminderBeforeMinutes: 30,
    autoAlertDelayMinutes: autoAlertDelayMinutes,
    isMonitoringEnabled: true,
    isAutoAlertEnabled: true,
    isDefault: false,
  );
}

CheckinRecord _checkinRecord({
  CheckinType type = CheckinType.manual,
  DateTime? checkedInAtUtc,
}) {
  return CheckinRecord(
    id: 'checkin-1',
    dailySafetyRecordId: 'record-1',
    checkinDate: '2026-05-26',
    checkedInAtUtc: checkedInAtUtc ?? DateTime.utc(2026, 5, 26, 12),
    type: type,
    note: null,
    mood: null,
    latitude: null,
    longitude: null,
    mediaObjectId: null,
  );
}

void main() {
  late MockGetTodayStatusUseCase getTodayStatusUseCase;
  late MockCheckinUseCase checkinUseCase;
  late MockGetSafetySettingsUseCase getSafetySettingsUseCase;
  late MockAppMessageNotifier messageNotifier;
  late HomeCheckinNotifier notifier;

  setUpAll(() {
    registerFallbackValue(const CheckinParams());
  });

  setUp(() {
    getTodayStatusUseCase = MockGetTodayStatusUseCase();
    checkinUseCase = MockCheckinUseCase();
    getSafetySettingsUseCase = MockGetSafetySettingsUseCase();
    messageNotifier = MockAppMessageNotifier();

    notifier = HomeCheckinNotifier(
      getTodayStatusUseCase,
      checkinUseCase,
      getSafetySettingsUseCase,
      messageNotifier,
    );
  });

  tearDown(() {
    notifier.dispose();
  });

  Future<void> seedLoadedStatus(TodayStatus status) async {
    when(
      () => getTodayStatusUseCase.call(),
    ).thenAnswer((_) async => Right(status));
    when(
      () => getSafetySettingsUseCase.call(),
    ).thenAnswer((_) async => Right(_settings()));

    await notifier.load(forceRefresh: true);

    clearInteractions(getTodayStatusUseCase);
    clearInteractions(getSafetySettingsUseCase);
    clearInteractions(messageNotifier);
  }

  group('HomeCheckinNotifier initial', () {
    test('khởi tạo với state mặc định và không tự gọi usecase', () {
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.isCheckingIn, isFalse);
      expect(notifier.state.todayStatus, isNull);
      expect(notifier.state.safetySettings, isNull);
      expect(notifier.state.remainingSeconds, isNull);
      expect(notifier.state.lastCheckinType, isNull);
      expect(notifier.state.errorMessage, isNull);
      expect(notifier.state.phase, HomeCheckinPhase.unknown);
      verifyNever(() => getTodayStatusUseCase.call());
      verifyNever(() => getSafetySettingsUseCase.call());
      verifyNever(() => checkinUseCase.call(any()));
    });
  });

  group('HomeCheckinNotifier load', () {
    test('load success gọi status/settings và cập nhật state', () async {
      final statusCompleter = Completer<Either<Failure, TodayStatus>>();
      final status = _todayStatus();
      final settings = _settings();
      when(
        () => getTodayStatusUseCase.call(),
      ).thenAnswer((_) => statusCompleter.future);
      when(
        () => getSafetySettingsUseCase.call(),
      ).thenAnswer((_) async => Right(settings));

      final future = notifier.load();

      expect(notifier.state.isLoading, isTrue);

      statusCompleter.complete(Right(status));
      await future;

      verify(() => getTodayStatusUseCase.call()).called(1);
      verify(() => getSafetySettingsUseCase.call()).called(1);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.todayStatus, same(status));
      expect(notifier.state.safetySettings, same(settings));
      expect(notifier.state.errorMessage, isNull);
      expect(notifier.state.phase, HomeCheckinPhase.pending);
    });

    test('load bỏ qua usecase khi đã có todayStatus và không force', () async {
      final status = _todayStatus();
      await seedLoadedStatus(status);

      await notifier.load();

      verifyNever(() => getTodayStatusUseCase.call());
      verifyNever(() => getSafetySettingsUseCase.call());
      expect(notifier.state.todayStatus, same(status));
    });

    test('load today status failure set error và vẫn đọc settings', () async {
      const failure = ServerFailure(message: 'Không tải được trạng thái');
      final settings = _settings();
      when(
        () => getTodayStatusUseCase.call(),
      ).thenAnswer((_) async => const Left(failure));
      when(
        () => getSafetySettingsUseCase.call(),
      ).thenAnswer((_) async => Right(settings));

      await notifier.load();

      verify(() => messageNotifier.addError(failure.message)).called(1);
      verify(() => getSafetySettingsUseCase.call()).called(1);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.todayStatus, isNull);
      expect(notifier.state.safetySettings, same(settings));
      expect(notifier.state.errorMessage, failure.message);
    });

    test('load settings failure chỉ phát message và giữ todayStatus', () async {
      final status = _todayStatus();
      const failure = ServerFailure(message: 'Không tải được cấu hình an toàn');
      when(
        () => getTodayStatusUseCase.call(),
      ).thenAnswer((_) async => Right(status));
      when(
        () => getSafetySettingsUseCase.call(),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.load();

      verify(() => messageNotifier.addError(failure.message)).called(1);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.todayStatus, same(status));
      expect(notifier.state.safetySettings, isNull);
      expect(notifier.state.errorMessage, isNull);
    });

    test(
      'load forceRefresh calls usecase again when todayStatus is cached',
      () async {
        final cachedStatus = _todayStatus(
          hasCheckedIn: true,
          status: TodayStatusType.checkedIn,
          checkedInAtUtc: DateTime.utc(2026, 5, 26, 9),
        );
        await seedLoadedStatus(cachedStatus);

        final freshStatus = _todayStatus(
          hasCheckedIn: false,
          status: TodayStatusType.pending,
          streak: 0,
        );
        final freshSettings = _settings(autoAlertDelayMinutes: 8);
        when(
          () => getTodayStatusUseCase.call(),
        ).thenAnswer((_) async => Right(freshStatus));
        when(
          () => getSafetySettingsUseCase.call(),
        ).thenAnswer((_) async => Right(freshSettings));

        await notifier.load(forceRefresh: true);

        verify(() => getTodayStatusUseCase.call()).called(1);
        verify(() => getSafetySettingsUseCase.call()).called(1);
        expect(notifier.state.todayStatus, same(freshStatus));
        expect(notifier.state.safetySettings, same(freshSettings));
        expect(notifier.state.phase, HomeCheckinPhase.pending);
      },
    );
  });

  group('HomeCheckinNotifier checkin', () {
    test('checkin success gọi usecase và cập nhật status checkedIn', () async {
      final currentStatus = _todayStatus(streak: 4);
      await seedLoadedStatus(currentStatus);
      final checkinCompleter = Completer<Either<Failure, CheckinRecord>>();
      final record = _checkinRecord(
        checkedInAtUtc: DateTime.utc(2026, 5, 26, 13),
      );
      when(
        () => checkinUseCase.call(any()),
      ).thenAnswer((_) => checkinCompleter.future);

      final future = notifier.checkin();

      expect(notifier.state.isCheckingIn, isTrue);

      checkinCompleter.complete(Right(record));
      await future;

      final captured =
          verify(() => checkinUseCase.call(captureAny())).captured.single
              as CheckinParams;
      expect(captured.note, isNull);
      expect(captured.mediaId, isNull);
      expect(captured.mood, isNull);
      verify(() => messageNotifier.addSuccess('Check-in thành công')).called(1);
      expect(notifier.state.isCheckingIn, isFalse);
      expect(notifier.state.lastCheckinType, CheckinType.manual);
      expect(notifier.state.todayStatus?.hasCheckedIn, isTrue);
      expect(notifier.state.todayStatus?.status, TodayStatusType.checkedIn);
      expect(notifier.state.todayStatus?.streak, 5);
      expect(notifier.state.todayStatus?.checkedInAtUtc, record.checkedInAtUtc);
      expect(notifier.state.errorMessage, isNull);
    });

    test('checkin failure phát error và giữ todayStatus cũ', () async {
      final currentStatus = _todayStatus(streak: 3);
      await seedLoadedStatus(currentStatus);
      const failure = ValidationFailure(message: 'Không thể check-in');
      when(
        () => checkinUseCase.call(any()),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.checkin();

      verify(() => messageNotifier.addError(failure.message)).called(1);
      expect(notifier.state.isCheckingIn, isFalse);
      expect(notifier.state.todayStatus, same(currentStatus));
      expect(notifier.state.errorMessage, failure.message);
    });

    test('không gọi usecase khi đã checked-in', () async {
      await seedLoadedStatus(
        _todayStatus(
          hasCheckedIn: true,
          status: TodayStatusType.checkedIn,
          checkedInAtUtc: DateTime.utc(2026, 5, 26, 9),
        ),
      );

      await notifier.checkin();

      verifyNever(() => checkinUseCase.call(any()));
    });

    test('không gọi usecase khi phase đang emergency', () async {
      await seedLoadedStatus(
        _todayStatus(status: TodayStatusType.overdue, remainingSeconds: null),
      );

      await notifier.checkin();

      verifyNever(() => checkinUseCase.call(any()));
      expect(notifier.state.phase, HomeCheckinPhase.emergency);
    });

    test('không gọi checkin lần hai khi đang isCheckingIn', () async {
      await seedLoadedStatus(_todayStatus());
      final checkinCompleter = Completer<Either<Failure, CheckinRecord>>();
      when(
        () => checkinUseCase.call(any()),
      ).thenAnswer((_) => checkinCompleter.future);

      final first = notifier.checkin();
      await notifier.checkin();

      checkinCompleter.complete(Right(_checkinRecord()));
      await first;

      verify(() => checkinUseCase.call(any())).called(1);
    });
  });
}
