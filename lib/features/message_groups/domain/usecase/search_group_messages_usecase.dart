import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group_message_page.dart';
import '../repositories/message_groups_repository.dart';

class SearchGroupMessagesUseCase {
  SearchGroupMessagesUseCase(this._repository);

  final MessageGroupsRepository _repository;

  Future<Either<Failure, GroupMessagePage>> call({
    required String groupId,
    required String search,
    String? cursor,
    int? limit,
  }) {
    final trimmedGroupId = groupId.trim();
    final trimmedSearch = search.trim();

    if (trimmedGroupId.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.messageGroupNotFound),
        ),
      );
    }

    if (trimmedSearch.isEmpty || trimmedSearch.length > 200) {
      return Future.value(
        const Left(
          ValidationFailure(message: 'Tu khoa tim kiem khong hop le'),
        ),
      );
    }

    return _repository.searchMessages(
      groupId: trimmedGroupId,
      search: trimmedSearch,
      cursor: cursor,
      limit: limit,
    );
  }
}
