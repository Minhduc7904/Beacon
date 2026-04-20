import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/usecase/get_me_usecase.dart';
import '../../domain/usecase/update_me_usecase.dart';
import '../../domain/usecase/update_my_avatar_usecase.dart';
import 'me_profile_notifier.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetMeUseCase _getMeUseCase;
  final UpdateMeUseCase _updateMeUseCase;
  final UpdateMyAvatarUseCase _updateMyAvatarUseCase;
  final MeProfileNotifier _meProfileNotifier;
  final AppMessageNotifier _messageNotifier;

  ProfileNotifier(
    this._getMeUseCase,
    this._updateMeUseCase,
    this._updateMyAvatarUseCase,
    this._meProfileNotifier,
    this._messageNotifier,
  ) : super(const ProfileState.initial());

  Future<void> loadProfile({bool forceRefresh = false}) async {
    if (state.isLoadingProfile) {
      return;
    }

    final existingProfile = _meProfileNotifier.state.valueOrNull;
    if (!forceRefresh && existingProfile != null) {
      return;
    }

    state = state.copyWith(isLoadingProfile: true, clearErrorMessage: true);

    final result = await _getMeUseCase.call();
    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isLoadingProfile: false,
          errorMessage: failure.message,
        );
      },
      (profile) {
        _meProfileNotifier.setProfile(profile);
        state = state.copyWith(
          isLoadingProfile: false,
          clearErrorMessage: true,
        );
      },
    );
  }

  Future<bool> updateProfile(UpdateMeParams params) async {
    if (state.isUpdatingProfile) {
      return false;
    }

    state = state.copyWith(isUpdatingProfile: true, clearErrorMessage: true);

    final result = await _updateMeUseCase.call(params);
    return result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isUpdatingProfile: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (profile) {
        _meProfileNotifier.setProfile(profile);
        _messageNotifier.addSuccess('Cập nhật thông tin thành công');
        state = state.copyWith(
          isUpdatingProfile: false,
          clearErrorMessage: true,
        );
        return true;
      },
    );
  }

  Future<bool> updateAvatar({required String filePath}) async {
    if (state.isUpdatingAvatar) {
      return false;
    }

    state = state.copyWith(isUpdatingAvatar: true, clearErrorMessage: true);

    final result = await _updateMyAvatarUseCase.call(
      UpdateMyAvatarParams(filePath: filePath),
    );

    return result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isUpdatingAvatar: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (profile) {
        _meProfileNotifier.setProfile(profile);
        _messageNotifier.addSuccess('Cập nhật ảnh đại diện thành công');
        state = state.copyWith(
          isUpdatingAvatar: false,
          clearErrorMessage: true,
        );
        return true;
      },
    );
  }
}
