import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/message_groups_repository.dart';

class UpdateMessageGroupMemberRoleUseCase {
  UpdateMessageGroupMemberRoleUseCase(this._repository);

  final MessageGroupsRepository _repository;

  Future<Either<Failure, void>> call({
    required String groupId,
    required String targetUserId,
    required int role,
  }) {
    final trimmedGroupId = groupId.trim();
    final trimmedTargetUserId = targetUserId.trim();

    if (trimmedGroupId.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.messageGroupNotFound),
        ),
      );
    }

    if (trimmedTargetUserId.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.groupMemberNotFound),
        ),
      );
    }

    if (!_isValidRole(role)) {
      return Future.value(
        const Left(ValidationFailure(message: 'Vai trò không hợp lệ')),
      );
    }

    return _repository.updateMemberRole(
      groupId: trimmedGroupId,
      targetUserId: trimmedTargetUserId,
      role: role,
    );
  }

  bool _isValidRole(int role) => role == 0 || role == 1 || role == 2;
}
