import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class UpdateFcmTokenUseCase {
  final AuthRepository _repository;

  UpdateFcmTokenUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String token,
    required String platform,
  }) {
    final normalizedToken = token.trim();
    final normalizedPlatform = platform.trim();
    if (normalizedToken.isEmpty || normalizedPlatform.isEmpty) {
      return Future.value(const Right(null));
    }

    return _repository.updateFcmToken(
      token: normalizedToken,
      platform: normalizedPlatform,
    );
  }
}
