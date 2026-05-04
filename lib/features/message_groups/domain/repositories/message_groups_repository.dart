import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/group_message.dart';
import '../entities/message_group_detail.dart';
import '../entities/group_message_page.dart';
import '../entities/message_group_page.dart';

abstract class MessageGroupsRepository {
  Future<Either<Failure, MessageGroupPage>> getMessageGroups({
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, GroupMessage>> sendMessage({
    required String groupId,
    required String content,
  });

  Future<Either<Failure, GroupMessagePage>> getMessages({
    required String groupId,
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, MessageGroupDetail>> getGroupDetail({
    required String groupId,
  });
}
