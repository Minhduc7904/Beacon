import 'package:beacon_app/core/constants/error_messages.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/features/home/domain/entities/checkin_record.dart';
import 'package:beacon_app/features/home/domain/repositories/checkin_repository.dart';
import 'package:beacon_app/features/home/domain/usecase/checkin_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckinRepository extends Mock implements CheckinRepository {}

CheckinRecord _checkinRecord() {
  return CheckinRecord(
    id: 'checkin-1',
    dailySafetyRecordId: 'daily-1',
    checkinDate: '2026-05-26',
    checkedInAtUtc: DateTime.utc(2026, 5, 26, 12),
    type: CheckinType.manual,
    note: 'An toàn',
    latitude: null,
    longitude: null,
    mediaObjectId: 'media-1',
  );
}

void _verifyCheckinNeverCalled(MockCheckinRepository repository) {
  verifyNever(
    () => repository.checkin(
      note: any(named: 'note'),
      mediaId: any(named: 'mediaId'),
    ),
  );
}

void main() {
  late MockCheckinRepository repository;
  late CheckinUseCase useCase;

  setUp(() {
    repository = MockCheckinRepository();
    useCase = CheckinUseCase(repository);
  });

  group('CheckinUseCase', () {
    test('trả về ValidationFailure khi note dài hơn 1000 ký tự', () async {
      final note = List.filled(1001, 'a').join();

      final result = await useCase(CheckinParams(note: note));

      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, ErrorMessages.checkinValidationError);
      }, (_) => fail('Expected Left'));
      _verifyCheckinNeverCalled(repository);
    });

    test(
      'gọi repository với note và mediaId đã trim khi input hợp lệ',
      () async {
        final record = _checkinRecord();
        when(
          () => repository.checkin(note: 'An toàn', mediaId: 'media-1'),
        ).thenAnswer((_) async => Right(record));

        final result = await useCase(
          const CheckinParams(note: '  An toàn  ', mediaId: '  media-1  '),
        );

        result.fold(
          (_) => fail('Expected Right'),
          (actualRecord) => expect(actualRecord, same(record)),
        );
        verify(
          () => repository.checkin(note: 'An toàn', mediaId: 'media-1'),
        ).called(1);
      },
    );

    test('trả về CheckinRecord khi repository check-in thành công', () async {
      final record = _checkinRecord();
      when(
        () => repository.checkin(note: 'An toàn', mediaId: 'media-1'),
      ).thenAnswer((_) async => Right(record));

      final result = await useCase(
        const CheckinParams(note: 'An toàn', mediaId: 'media-1'),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (actualRecord) => expect(actualRecord, same(record)),
      );
    });

    test('pass-through failure từ repository', () async {
      const failure = ServerFailure(message: 'Check-in thất bại');
      when(
        () => repository.checkin(note: 'An toàn', mediaId: null),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase(const CheckinParams(note: 'An toàn'));

      result.fold(
        (actualFailure) => expect(actualFailure, same(failure)),
        (_) => fail('Expected Left'),
      );
    });
  });
}
