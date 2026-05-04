import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/group_message.dart';
import '../repositories/message_groups_repository.dart';

class SendGroupMessageUseCase {
  final MessageGroupsRepository _repository;

  SendGroupMessageUseCase(this._repository);

  Future<Either<Failure, GroupMessage>> call({
    required String groupId,
    required String content,
  }) {
    return _repository.sendMessage(
      groupId: groupId.trim(),
      content: content.trim(),
    );
  }
}
