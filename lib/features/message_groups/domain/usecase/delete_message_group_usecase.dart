import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/message_groups_repository.dart';

class DeleteMessageGroupUseCase {
  final MessageGroupsRepository _repository;

  DeleteMessageGroupUseCase(this._repository);

  Future<Either<Failure, void>> call({required String groupId}) {
    return _repository.deleteGroup(groupId: groupId.trim());
  }
}
