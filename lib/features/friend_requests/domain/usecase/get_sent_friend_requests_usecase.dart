import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/friend_request_page.dart';
import '../repositories/friend_request_repository.dart';

class GetSentFriendRequestsUseCase {
  final FriendRequestRepository _repository;

  GetSentFriendRequestsUseCase(this._repository);

  Future<Either<Failure, FriendRequestPage>> call({
    String? cursor,
    int? limit,
  }) {
    return _repository.getSentRequests(
      cursor: cursor?.trim().isEmpty == true ? null : cursor?.trim(),
      limit: limit,
    );
  }
}
