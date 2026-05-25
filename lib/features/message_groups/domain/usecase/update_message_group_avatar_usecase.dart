import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/message_groups_repository.dart';

class UpdateMessageGroupAvatarUseCase {
  final MessageGroupsRepository _repository;

  UpdateMessageGroupAvatarUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String groupId,
    required String filePath,
  }) {
    final trimmedGroupId = groupId.trim();
    final trimmedPath = filePath.trim();

    if (trimmedGroupId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: 'Không tìm thấy nhóm chat')),
      );
    }

    if (trimmedPath.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: 'Không đọc được tệp ảnh đã chọn'),
        ),
      );
    }

    return _repository.updateGroupAvatar(
      groupId: trimmedGroupId,
      filePath: trimmedPath,
    );
  }
}
