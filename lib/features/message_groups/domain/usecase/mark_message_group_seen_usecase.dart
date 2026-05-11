import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/message_groups_repository.dart';

class MarkMessageGroupSeenUseCase {
  MarkMessageGroupSeenUseCase(this._repository);

  final MessageGroupsRepository _repository;

  Future<Either<Failure, void>> call({
    required String groupId,
    required String lastSeenMessageId,
  }) {
    return _repository.markSeen(
      groupId: groupId.trim(),
      lastSeenMessageId: lastSeenMessageId.trim(),
    );
  }
}
