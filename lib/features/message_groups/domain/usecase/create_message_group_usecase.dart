import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/message_group_detail.dart';
import '../repositories/message_groups_repository.dart';

class CreateMessageGroupUseCase {
  CreateMessageGroupUseCase(this._repository);

  final MessageGroupsRepository _repository;

  Future<Either<Failure, MessageGroupDetail>> call({
    required List<String> memberUserIds,
  }) {
    final normalizedUserIds = memberUserIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);

    if (normalizedUserIds.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: 'Vui lòng chọn ít nhất một bạn bè'),
        ),
      );
    }

    return _repository.createMessageGroup(memberUserIds: normalizedUserIds);
  }
}
