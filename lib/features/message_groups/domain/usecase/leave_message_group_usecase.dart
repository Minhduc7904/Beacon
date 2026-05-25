import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/message_groups_repository.dart';

class LeaveMessageGroupUseCase {
  final MessageGroupsRepository _repository;

  LeaveMessageGroupUseCase(this._repository);

  Future<Either<Failure, void>> call({required String groupId}) {
    return _repository.leaveGroup(groupId: groupId.trim());
  }
}
