import '../../domain/entities/safety_settings.dart';

class SafetySettingsState {
  final bool isLoading;
  final bool isSaving;
  final SafetySettings? settings;
  final String? errorMessage;

  const SafetySettingsState({
    required this.isLoading,
    required this.isSaving,
    required this.settings,
    required this.errorMessage,
  });

  const SafetySettingsState.initial()
    : isLoading = false,
      isSaving = false,
      settings = null,
      errorMessage = null;

  bool get isBusy => isLoading || isSaving;

  SafetySettingsState copyWith({
    bool? isLoading,
    bool? isSaving,
    SafetySettings? settings,
    bool clearSettings = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SafetySettingsState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      settings: clearSettings ? null : (settings ?? this.settings),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
