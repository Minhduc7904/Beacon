import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/group_message_page.dart';
import '../repositories/message_groups_repository.dart';

class GetGroupMessagesUseCase {
  final MessageGroupsRepository _repository;

  GetGroupMessagesUseCase(this._repository);

  Future<Either<Failure, GroupMessagePage>> call({
    required String groupId,
    String? cursor,
    int? limit,
  }) {
    return _repository.getMessages(
      groupId: groupId.trim(),
      cursor: cursor?.trim().isEmpty == true ? null : cursor?.trim(),
      limit: limit,
    );
  }
}
