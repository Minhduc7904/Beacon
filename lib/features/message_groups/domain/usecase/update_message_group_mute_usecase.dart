import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/message_groups_repository.dart';

class UpdateMessageGroupMuteUseCase {
  UpdateMessageGroupMuteUseCase(this._repository);

  final MessageGroupsRepository _repository;

  Future<Either<Failure, void>> call({
    required String groupId,
    required bool isMuted,
  }) {
    final trimmedGroupId = groupId.trim();

    if (trimmedGroupId.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.messageGroupNotFound),
        ),
      );
    }

    return _repository.updateMuteStatus(
      groupId: trimmedGroupId,
      isMuted: isMuted,
    );
  }
}
