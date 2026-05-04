import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/message_group_detail.dart';
import '../repositories/message_groups_repository.dart';

class GetMessageGroupDetailUseCase {
  final MessageGroupsRepository _repository;

  GetMessageGroupDetailUseCase(this._repository);

  Future<Either<Failure, MessageGroupDetail>> call({
    required String groupId,
  }) {
    return _repository.getGroupDetail(groupId: groupId.trim());
  }
}
