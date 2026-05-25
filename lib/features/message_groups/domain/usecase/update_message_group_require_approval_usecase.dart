import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/message_groups_repository.dart';

class UpdateMessageGroupRequireApprovalUseCase {
  final MessageGroupsRepository _repository;

  UpdateMessageGroupRequireApprovalUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String groupId,
    required bool requireApprovalToAddMembers,
  }) {
    return _repository.updateRequireApprovalToAddMembers(
      groupId: groupId.trim(),
      requireApprovalToAddMembers: requireApprovalToAddMembers,
    );
  }
}
