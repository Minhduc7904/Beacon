import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/message_groups_repository.dart';

class UpdateMessageGroupMemberCustomNameUseCase {
  final MessageGroupsRepository _repository;

  UpdateMessageGroupMemberCustomNameUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String groupId,
    required String userId,
    String? customName,
  }) {
    final trimmedGroupId = groupId.trim();
    final trimmedUserId = userId.trim();
    final trimmedName = customName?.trim();

    return _repository.updateMemberCustomName(
      groupId: trimmedGroupId,
      userId: trimmedUserId,
      customName: trimmedName == null || trimmedName.isEmpty
          ? null
          : trimmedName,
    );
  }
}
