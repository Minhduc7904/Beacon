import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecase/get_me_usecase.dart';

class MeProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final GetMeUseCase _getMeUseCase;

  MeProfileNotifier(this._getMeUseCase)
    : super(const AsyncValue<UserProfile?>.data(null));

  Future<UserProfile?> fetchProfile() async {
    state = const AsyncValue<UserProfile?>.loading();
    final result = await _getMeUseCase.call();

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
      (profile) {
        state = AsyncValue<UserProfile?>.data(profile);
        return profile;
      },
    );
  }

  void setProfile(UserProfile profile) {
    state = AsyncValue<UserProfile?>.data(profile);
  }

  void clearProfile() {
    state = const AsyncValue<UserProfile?>.data(null);
  }

  Failure? get lastFailure {
    return state.whenOrNull(error: (error, stackTrace) {
      if (error is Failure) {
        return error;
      }
      return null;
    });
  }
}
