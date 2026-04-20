import 'package:flutter/material.dart';

import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/input/input.dart';
import '../../../../../core/widgets/layout/screen_layout.dart';
import '../../../../../core/widgets/navigation/back_button.dart';
import '../../../../../core/widgets/text/text.dart';

class RegisterStepLayout extends StatelessWidget {
  static const double _titleTopSpacing = 210;
  static const double _titleToInputGroupSpacing = 36;
  static const double _inputSpacing = 20;
  static const double _inputGroupToActionGroupSpacing = 48;
  static const double _instructionToButtonSpacing = 20;

  const RegisterStepLayout({
    super.key,
    required this.title,
    required this.inputController,
    required this.inputHintText,
    required this.onContinuePressed,
    this.onBackPressed,
    this.inputLabel,
    this.inputCaption,
    this.inputRightCaption,
    this.inputType = InputType.text,
    this.inputIcon,
    this.inputFields,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onInputChanged,
    this.errorText,
    this.continueText = 'Tiếp theo',
    this.isLoading = false,
    this.loadingText,
    this.enabled = true,
    this.instructionText,
    this.showAgreement = true,
    this.onTermsPressed,
    this.onPrivacyPressed,
  });

  final String title;
  final TextEditingController inputController;
  final String inputHintText;
  final VoidCallback onContinuePressed;
  final VoidCallback? onBackPressed;
  final String? inputLabel;
  final String? inputCaption;
  final String? inputRightCaption;
  final InputType inputType;
  final Widget? inputIcon;
  final List<Widget>? inputFields;
  final TextInputType keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onInputChanged;
  final String? errorText;
  final String continueText;
  final bool isLoading;
  final String? loadingText;
  final bool enabled;
  final String? instructionText;
  final bool showAgreement;
  final VoidCallback? onTermsPressed;
  final VoidCallback? onPrivacyPressed;

  InputState _resolveInputState() {
    if (!enabled || isLoading) {
      return InputState.disabled;
    }

    if (errorText != null && errorText!.trim().isNotEmpty) {
      return InputState.error;
    }

    if (inputController.text.trim().isNotEmpty) {
      return InputState.filled;
    }

    return InputState.defaultState;
  }

  Widget _buildDefaultInput(bool disableActions) {
    final hasError = errorText != null && errorText!.trim().isNotEmpty;

    return Input(
      controller: inputController,
      onChanged: onInputChanged,
      label: inputLabel,
      caption: hasError ? errorText : inputCaption,
      rightCaption: inputRightCaption,
      hintText: inputHintText,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: !disableActions,
      state: _resolveInputState(),
      type: inputType,
      leftIcon: inputIcon,
    );
  }

  Widget _buildInputGroup(bool disableActions) {
    final fields = inputFields;

    if (fields == null || fields.isEmpty) {
      return _buildDefaultInput(disableActions);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < fields.length; index++) ...[
          if (index > 0) const SizedBox(height: _inputSpacing),
          fields[index],
        ],
      ],
    );
  }

  Widget? _buildInstruction() {
    final customInstruction = instructionText?.trim();
    if (customInstruction != null && customInstruction.isNotEmpty) {
      return AppText(
        customInstruction,
        preset: AppTextPreset.bodySmall,
        color: AppColors.ink400,
        textAlign: TextAlign.center,
      );
    }

    if (showAgreement) {
      return _RegisterAgreementText(
        onTermsPressed: onTermsPressed,
        onPrivacyPressed: onPrivacyPressed,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final disableActions = !enabled || isLoading;
    final instructionWidget = _buildInstruction();
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardVisible = keyboardInset > 0;
    final effectiveTitleTopSpacing = isKeyboardVisible
        ? (_titleTopSpacing - (keyboardInset * 0.35)).clamp(
            96.0,
            _titleTopSpacing,
          )
        : _titleTopSpacing;
    final effectiveTitleToInputSpacing = isKeyboardVisible
        ? 24.0
        : _titleToInputGroupSpacing;
    final effectiveInputToActionSpacing = isKeyboardVisible
        ? 24.0
        : _inputGroupToActionGroupSpacing;
    final effectiveInstructionToButtonSpacing = isKeyboardVisible
        ? 12.0
        : _instructionToButtonSpacing;

    return Scaffold(
      backgroundColor: AppColors.sky200,
      body: SafeArea(
        child: AppScreenLayout(
          child: Stack(
            children: [
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: isKeyboardVisible
                          ? const ClampingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.only(
                            bottom: isKeyboardVisible ? 16 : 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: effectiveTitleTopSpacing),
                              AppText(
                                title,
                                preset: AppTextPreset.title2,
                                fontWeight: FontWeight.w700,
                                color: AppColors.teal500,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: effectiveTitleToInputSpacing),
                              _buildInputGroup(disableActions),
                              SizedBox(height: effectiveInputToActionSpacing),
                              if (instructionWidget case final widget?) ...[
                                widget,
                                SizedBox(
                                  height: effectiveInstructionToButtonSpacing,
                                ),
                              ],
                              Button(
                                text: continueText,
                                size: ButtonSize.block,
                                type: ButtonType.primary,
                                state: disableActions
                                    ? ButtonState.disabled
                                    : ButtonState.defaultState,
                                onPressed: disableActions
                                    ? null
                                    : onContinuePressed,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 16,
                left: 0,
                child: AppBackButton(onPressed: onBackPressed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterAgreementText extends StatelessWidget {
  const _RegisterAgreementText({this.onTermsPressed, this.onPrivacyPressed});

  final VoidCallback? onTermsPressed;
  final VoidCallback? onPrivacyPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppText(
              'Bằng cách nhấn Tiếp tục, bạn đồng ý với',
              preset: AppTextPreset.bodySmall,
              color: AppColors.ink400,
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 4),
            _LegalLinkText(
              text: 'Điều khoản dịch vụ',
              onPressed: onTermsPressed,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _LegalLinkText(
              text: 'Chính sách bảo mật',
              onPressed: onPrivacyPressed,
            ),
            const SizedBox(width: 4),
            AppText(
              'của chúng tôi',
              preset: AppTextPreset.bodySmall,
              color: AppColors.ink400,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}

class _LegalLinkText extends StatelessWidget {
  const _LegalLinkText({required this.text, this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final link = AppText(
      text,
      preset: AppTextPreset.bodySmall,
      color: AppColors.teal500,
      fontWeight: FontWeight.w500,
    );

    if (onPressed == null) {
      return link;
    }

    return GestureDetector(onTap: onPressed, child: link);
  }
}
