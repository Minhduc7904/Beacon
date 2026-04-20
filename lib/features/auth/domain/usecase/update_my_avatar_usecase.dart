import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class UpdateMyAvatarParams {
  final String filePath;

  const UpdateMyAvatarParams({required this.filePath});
}

class UpdateMyAvatarUseCase {
  final AuthRepository _repository;

  UpdateMyAvatarUseCase(this._repository);

  Future<Either<Failure, UserProfile>> call(UpdateMyAvatarParams params) {
    if (params.filePath.trim().isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: 'Không đọc được tệp ảnh đã chọn'),
        ),
      );
    }

    return _repository.updateMyAvatar(filePath: params.filePath.trim());
  }
}
