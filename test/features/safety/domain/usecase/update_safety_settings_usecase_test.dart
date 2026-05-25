import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/safety/domain/entities/safety_settings.dart';
import 'package:beacon_app/features/safety/domain/repositories/safety_repository.dart';
import 'package:beacon_app/features/safety/domain/usecase/update_safety_settings_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSafetyRepository extends Mock implements SafetyRepository {}

SafetySettings _safetySettings({
  String dailyDeadlineLocalTime = '15:00',
  int gracePeriodMinutes = 30,
  int reminderBeforeMinutes = 60,
  int autoAlertDelayMinutes = 10,
  bool isMonitoringEnabled = true,
  bool isAutoAlertEnabled = true,
}) {
  return SafetySettings(
    dailyDeadlineLocalTime: dailyDeadlineLocalTime,
    gracePeriodMinutes: gracePeriodMinutes,
    reminderBeforeMinutes: reminderBeforeMinutes,
    autoAlertDelayMinutes: autoAlertDelayMinutes,
    isMonitoringEnabled: isMonitoringEnabled,
    isAutoAlertEnabled: isAutoAlertEnabled,
    isDefault: false,
  );
}

void _verifyUpdateSafetySettingsNeverCalled(MockSafetyRepository repository) {
  verifyNever(
    () => repository.updateSafetySettings(
      dailyDeadlineLocalTime: any(named: 'dailyDeadlineLocalTime'),
      gracePeriodMinutes: any(named: 'gracePeriodMinutes'),
      reminderBeforeMinutes: any(named: 'reminderBeforeMinutes'),
      autoAlertDelayMinutes: any(named: 'autoAlertDelayMinutes'),
      isMonitoringEnabled: any(named: 'isMonitoringEnabled'),
      isAutoAlertEnabled: any(named: 'isAutoAlertEnabled'),
    ),
  );
}

void main() {
  late MockSafetyRepository repository;
  late UpdateSafetySettingsUseCase useCase;

  setUp(() {
    repository = MockSafetyRepository();
    useCase = UpdateSafetySettingsUseCase(repository);
  });

  group('UpdateSafetySettingsUseCase', () {
    test('trả về ValidationFailure khi không có field nào thay đổi', () async {
      final result = await useCase(const UpdateSafetySettingsParams());

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Không có thay đổi nào để cập nhật');
      }, (_) => fail('Expected Left'));
      _verifyUpdateSafetySettingsNeverCalled(repository);
    });

    test('trả về ValidationFailure khi deadline sai định dạng', () async {
      final result = await useCase(
        const UpdateSafetySettingsParams(dailyDeadlineLocalTime: '24:00'),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.safetyDeadlineInvalidFormat);
      }, (_) => fail('Expected Left'));
      _verifyUpdateSafetySettingsNeverCalled(repository);
    });

    test('trả về ValidationFailure khi gracePeriodMinutes nhỏ hơn 0', () async {
      final result = await useCase(
        const UpdateSafetySettingsParams(gracePeriodMinutes: -1),
      );

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.safetyGracePeriodOutOfRange);
      }, (_) => fail('Expected Left'));
      _verifyUpdateSafetySettingsNeverCalled(repository);
    });

    test(
      'trả về ValidationFailure khi gracePeriodMinutes lớn hơn 1440',
      () async {
        final result = await useCase(
          const UpdateSafetySettingsParams(gracePeriodMinutes: 1441),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.safetyGracePeriodOutOfRange);
        }, (_) => fail('Expected Left'));
        _verifyUpdateSafetySettingsNeverCalled(repository);
      },
    );

    test(
      'trả về ValidationFailure khi reminderBeforeMinutes nhỏ hơn 0',
      () async {
        final result = await useCase(
          const UpdateSafetySettingsParams(reminderBeforeMinutes: -1),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.safetyReminderBeforeOutOfRange);
        }, (_) => fail('Expected Left'));
        _verifyUpdateSafetySettingsNeverCalled(repository);
      },
    );

    test(
      'trả về ValidationFailure khi reminderBeforeMinutes lớn hơn 1440',
      () async {
        final result = await useCase(
          const UpdateSafetySettingsParams(reminderBeforeMinutes: 1441),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.safetyReminderBeforeOutOfRange);
        }, (_) => fail('Expected Left'));
        _verifyUpdateSafetySettingsNeverCalled(repository);
      },
    );

    test(
      'trả về ValidationFailure khi autoAlertDelayMinutes nhỏ hơn 0',
      () async {
        final result = await useCase(
          const UpdateSafetySettingsParams(autoAlertDelayMinutes: -1),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.safetyAutoAlertDelayOutOfRange);
        }, (_) => fail('Expected Left'));
        _verifyUpdateSafetySettingsNeverCalled(repository);
      },
    );

    test(
      'trả về ValidationFailure khi autoAlertDelayMinutes lớn hơn 1440',
      () async {
        final result = await useCase(
          const UpdateSafetySettingsParams(autoAlertDelayMinutes: 1441),
        );

        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, ErrorMessages.safetyAutoAlertDelayOutOfRange);
        }, (_) => fail('Expected Left'));
        _verifyUpdateSafetySettingsNeverCalled(repository);
      },
    );

    test(
      'force isAutoAlertEnabled false khi isMonitoringEnabled là false',
      () async {
        final settings = _safetySettings(
          isMonitoringEnabled: false,
          isAutoAlertEnabled: false,
        );
        when(
          () => repository.updateSafetySettings(
            dailyDeadlineLocalTime: null,
            gracePeriodMinutes: null,
            reminderBeforeMinutes: null,
            autoAlertDelayMinutes: null,
            isMonitoringEnabled: false,
            isAutoAlertEnabled: false,
          ),
        ).thenAnswer((_) async => Right(settings));

        final result = await useCase(
          const UpdateSafetySettingsParams(
            isMonitoringEnabled: false,
            isAutoAlertEnabled: true,
          ),
        );

        result.fold(
          (_) => fail('Expected Right'),
          (actualSettings) => expect(actualSettings, same(settings)),
        );
        verify(
          () => repository.updateSafetySettings(
            dailyDeadlineLocalTime: null,
            gracePeriodMinutes: null,
            reminderBeforeMinutes: null,
            autoAlertDelayMinutes: null,
            isMonitoringEnabled: false,
            isAutoAlertEnabled: false,
          ),
        ).called(1);
      },
    );

    test('gọi repository với deadline đã trim và params hợp lệ', () async {
      final settings = _safetySettings(dailyDeadlineLocalTime: '09:30');
      when(
        () => repository.updateSafetySettings(
          dailyDeadlineLocalTime: '09:30',
          gracePeriodMinutes: 30,
          reminderBeforeMinutes: 60,
          autoAlertDelayMinutes: 10,
          isMonitoringEnabled: true,
          isAutoAlertEnabled: true,
        ),
      ).thenAnswer((_) async => Right(settings));

      final result = await useCase(
        const UpdateSafetySettingsParams(
          dailyDeadlineLocalTime: ' 09:30 ',
          gracePeriodMinutes: 30,
          reminderBeforeMinutes: 60,
          autoAlertDelayMinutes: 10,
          isMonitoringEnabled: true,
          isAutoAlertEnabled: true,
        ),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualSettings) => expect(actualSettings, same(settings)),
      );
      verify(
        () => repository.updateSafetySettings(
          dailyDeadlineLocalTime: '09:30',
          gracePeriodMinutes: 30,
          reminderBeforeMinutes: 60,
          autoAlertDelayMinutes: 10,
          isMonitoringEnabled: true,
          isAutoAlertEnabled: true,
        ),
      ).called(1);
    });

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(message: 'Cập nhật cài đặt thất bại');
      when(
        () => repository.updateSafetySettings(
          dailyDeadlineLocalTime: null,
          gracePeriodMinutes: 30,
          reminderBeforeMinutes: null,
          autoAlertDelayMinutes: null,
          isMonitoringEnabled: null,
          isAutoAlertEnabled: null,
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(
        const UpdateSafetySettingsParams(gracePeriodMinutes: 30),
      );

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });

    test('trả về SafetySettings khi repository cập nhật thành công', () async {
      final settings = _safetySettings();
      when(
        () => repository.updateSafetySettings(
          dailyDeadlineLocalTime: null,
          gracePeriodMinutes: null,
          reminderBeforeMinutes: 60,
          autoAlertDelayMinutes: null,
          isMonitoringEnabled: null,
          isAutoAlertEnabled: null,
        ),
      ).thenAnswer((_) async => Right(settings));

      final result = await useCase(
        const UpdateSafetySettingsParams(reminderBeforeMinutes: 60),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualSettings) => expect(actualSettings, same(settings)),
      );
    });
  });
}
