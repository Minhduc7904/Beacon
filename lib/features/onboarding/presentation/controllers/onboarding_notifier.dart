import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/usecase/complete_onboarding_usecase.dart';
import 'onboarding_state.dart';

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final CompleteOnboardingUseCase _completeOnboardingUseCase;
  final AppMessageNotifier _messageNotifier;

  OnboardingNotifier(this._completeOnboardingUseCase, this._messageNotifier)
    : super(const OnboardingInitial());

  Future<void> completeOnboarding() async {
    state = const OnboardingLoading();

    try {
      await _completeOnboardingUseCase();
      state = const OnboardingCompleted();
    } catch (_) {
      const message = 'Không thể hoàn tất onboarding. Vui lòng thử lại.';
      _messageNotifier.addError(message);
      state = const OnboardingError(message);
    }
  }
}
