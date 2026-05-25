import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/message_groups_repository.dart';

class RemoveMessageGroupMemberUseCase {
  RemoveMessageGroupMemberUseCase(this._repository);

  final MessageGroupsRepository _repository;

  Future<Either<Failure, void>> call({
    required String groupId,
    required String userId,
  }) {
    final trimmedGroupId = groupId.trim();
    final trimmedUserId = userId.trim();

    if (trimmedGroupId.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.messageGroupNotFound),
        ),
      );
    }

    if (trimmedUserId.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.groupMemberNotFound),
        ),
      );
    }

    return _repository.removeMember(
      groupId: trimmedGroupId,
      userId: trimmedUserId,
    );
  }
}
