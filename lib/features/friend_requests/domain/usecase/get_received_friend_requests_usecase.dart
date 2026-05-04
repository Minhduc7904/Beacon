import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/friend_request_page.dart';
import '../repositories/friend_request_repository.dart';

class GetReceivedFriendRequestsUseCase {
  final FriendRequestRepository _repository;

  GetReceivedFriendRequestsUseCase(this._repository);

  Future<Either<Failure, FriendRequestPage>> call({
    String? cursor,
    int? limit,
  }) {
    return _repository.getReceivedRequests(
      cursor: cursor?.trim().isEmpty == true ? null : cursor?.trim(),
      limit: limit,
    );
  }
}
