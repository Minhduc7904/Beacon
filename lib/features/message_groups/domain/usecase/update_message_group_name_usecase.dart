import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/message_groups_repository.dart';

class UpdateMessageGroupNameUseCase {
  final MessageGroupsRepository _repository;

  UpdateMessageGroupNameUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String groupId,
    required String name,
  }) {
    final trimmedGroupId = groupId.trim();
    final trimmedName = name.trim();

    if (trimmedGroupId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: 'Không tìm thấy nhóm chat')),
      );
    }

    if (trimmedName.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: 'Vui lòng nhập tên nhóm')),
      );
    }

    if (trimmedName.length > 100) {
      return Future.value(
        const Left(
          ValidationFailure(message: 'Tên nhóm không được vượt quá 100 ký tự'),
        ),
      );
    }

    return _repository.updateGroupName(
      groupId: trimmedGroupId,
      name: trimmedName,
    );
  }
}
