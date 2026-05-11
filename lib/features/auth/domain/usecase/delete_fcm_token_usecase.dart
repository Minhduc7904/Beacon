import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class DeleteFcmTokenUseCase {
  final AuthRepository _repository;

  DeleteFcmTokenUseCase(this._repository);

  Future<Either<Failure, void>> call({required String token}) {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      return Future.value(const Right(null));
    }

    return _repository.deleteFcmToken(token: normalizedToken);
  }
}
