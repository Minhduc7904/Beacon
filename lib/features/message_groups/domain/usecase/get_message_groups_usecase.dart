import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/message_group_page.dart';
import '../repositories/message_groups_repository.dart';

class GetMessageGroupsUseCase {
  final MessageGroupsRepository _repository;

  GetMessageGroupsUseCase(this._repository);

  Future<Either<Failure, MessageGroupPage>> call({
    String? cursor,
    int? limit,
  }) {
    return _repository.getMessageGroups(
      cursor: cursor?.trim().isEmpty == true ? null : cursor?.trim(),
      limit: limit,
    );
  }
}
