import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/usecase/get_safety_settings_usecase.dart';
import '../../domain/usecase/update_safety_settings_usecase.dart';
import 'safety_settings_state.dart';

class SafetySettingsNotifier extends StateNotifier<SafetySettingsState> {
  final GetSafetySettingsUseCase _getSafetySettingsUseCase;
  final UpdateSafetySettingsUseCase _updateSafetySettingsUseCase;
  final AppMessageNotifier _messageNotifier;

  SafetySettingsNotifier(
    this._getSafetySettingsUseCase,
    this._updateSafetySettingsUseCase,
    this._messageNotifier,
  ) : super(const SafetySettingsState.initial());

  Future<void> loadSettings({bool forceRefresh = false}) async {
    if (state.isLoading) {
      return;
    }

    if (!forceRefresh && state.settings != null) {
      return;
    }

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    final result = await _getSafetySettingsUseCase.call();
    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (settings) {
        state = state.copyWith(
          isLoading: false,
          settings: settings,
          clearErrorMessage: true,
        );
      },
    );
  }

  Future<bool> updateSettings(UpdateSafetySettingsParams params) async {
    if (state.isSaving) {
      return false;
    }

    state = state.copyWith(isSaving: true, clearErrorMessage: true);

    final result = await _updateSafetySettingsUseCase.call(params);
    return result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isSaving: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (settings) {
        _messageNotifier.addSuccess('Cập nhật cài đặt an toàn thành công');
        state = state.copyWith(
          isSaving: false,
          settings: settings,
          clearErrorMessage: true,
        );
        return true;
      },
    );
  }
}
