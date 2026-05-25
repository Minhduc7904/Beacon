import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/message_groups_repository.dart';

class AddGroupMembersUseCase {
  AddGroupMembersUseCase(this._repository);

  final MessageGroupsRepository _repository;

  Future<Either<Failure, void>> call({
    required String groupId,
    required List<String> targetUserIds,
  }) {
    final normalizedGroupId = groupId.trim();
    final normalizedUserIds = targetUserIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);

    if (normalizedGroupId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: 'Nhóm chat không hợp lệ')),
      );
    }

    if (normalizedUserIds.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: 'Vui lòng chọn ít nhất một bạn bè'),
        ),
      );
    }

    return _repository.addMembers(
      groupId: normalizedGroupId,
      targetUserIds: normalizedUserIds,
    );
  }
}
