import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/validation_messages.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/button/button.dart';
import '../../../../core/widgets/input/input.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/switch_button/switch_button.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/safety_settings.dart';
import '../../domain/usecase/update_safety_settings_usecase.dart';
import '../controllers/safety_settings_state.dart';

class SafetySettingsPage extends ConsumerStatefulWidget {
  const SafetySettingsPage({super.key});

  @override
  ConsumerState<SafetySettingsPage> createState() => _SafetySettingsPageState();
}

class _SafetySettingsPageState extends ConsumerState<SafetySettingsPage> {
  static const String _minuteParseError =
      'Vui lòng nhập số nguyên từ 0 đến 1440';

  late final TextEditingController _gracePeriodController;
  late final TextEditingController _reminderBeforeController;
  late final TextEditingController _autoAlertDelayController;
  late final ProviderSubscription<SafetySettingsState> _subscription;

  String _dailyDeadlineLocalTime = '22:00';
  bool _isMonitoringEnabled = true;
  bool _isAutoAlertEnabled = true;

  String? _deadlineError;
  String? _gracePeriodError;
  String? _reminderBeforeError;
  String? _autoAlertDelayError;

  @override
  void initState() {
    super.initState();

    _gracePeriodController = TextEditingController();
    _reminderBeforeController = TextEditingController();
    _autoAlertDelayController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(safetySettingsNotifierProvider.notifier).loadSettings();
    });

    _subscription = ref.listenManual<SafetySettingsState>(
      safetySettingsNotifierProvider,
      (previous, next) {
        final current = next.settings;
        if (!mounted || current == null) return;

        final prevSettings = previous?.settings;
        if (_isSameSettings(prevSettings, current)) return;

        _hydrateFromSettings(current);
      },
    );
  }

  @override
  void dispose() {
    _subscription.close();
    _gracePeriodController.dispose();
    _reminderBeforeController.dispose();
    _autoAlertDelayController.dispose();
    super.dispose();
  }

  bool _isSameSettings(SafetySettings? a, SafetySettings b) {
    if (a == null) return false;
    return a.dailyDeadlineLocalTime == b.dailyDeadlineLocalTime &&
        a.gracePeriodMinutes == b.gracePeriodMinutes &&
        a.reminderBeforeMinutes == b.reminderBeforeMinutes &&
        a.autoAlertDelayMinutes == b.autoAlertDelayMinutes &&
        a.isMonitoringEnabled == b.isMonitoringEnabled &&
        a.isAutoAlertEnabled == b.isAutoAlertEnabled &&
        a.isDefault == b.isDefault;
  }

  void _hydrateFromSettings(SafetySettings settings) {
    setState(() {
      _dailyDeadlineLocalTime = settings.dailyDeadlineLocalTime;
      _isMonitoringEnabled = settings.isMonitoringEnabled;
      _isAutoAlertEnabled = settings.isAutoAlertEnabled;
      _gracePeriodController.text = settings.gracePeriodMinutes.toString();
      _reminderBeforeController.text = settings.reminderBeforeMinutes
          .toString();
      _autoAlertDelayController.text = settings.autoAlertDelayMinutes
          .toString();
      _clearInlineErrors();
    });
  }

  void _clearInlineErrors() {
    _deadlineError = null;
    _gracePeriodError = null;
    _reminderBeforeError = null;
    _autoAlertDelayError = null;
  }

  void _applyValidationError(String? message) {
    final normalized = message?.trim() ?? '';
    setState(() {
      switch (normalized) {
        case ErrorMessages.safetyDeadlineInvalidFormat:
        case ErrorMessages.safetySettingsValidationError:
          _deadlineError = normalized;
          break;
        case ErrorMessages.safetyGracePeriodOutOfRange:
          _gracePeriodError = normalized;
          break;
        case ErrorMessages.safetyReminderBeforeOutOfRange:
          _reminderBeforeError = normalized;
          break;
        case ErrorMessages.safetyAutoAlertDelayOutOfRange:
          _autoAlertDelayError = normalized;
          break;
      }
    });
  }

  InputState _resolveInputState(String value, String? error) {
    if (error != null && error.isNotEmpty) return InputState.error;
    if (value.trim().isNotEmpty) return InputState.filled;
    return InputState.defaultState;
  }

  Future<void> _onPickDeadline() async {
    final current =
        _parseTimeOfDay(_dailyDeadlineLocalTime) ??
        const TimeOfDay(hour: 22, minute: 0);

    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (!mounted || picked == null) return;

    setState(() {
      _deadlineError = null;
      _dailyDeadlineLocalTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    });
  }

  bool _hasChanges(SafetySettings settings) {
    final grace = int.tryParse(_gracePeriodController.text.trim());
    final reminder = int.tryParse(_reminderBeforeController.text.trim());
    final autoAlert = int.tryParse(_autoAlertDelayController.text.trim());

    return _dailyDeadlineLocalTime != settings.dailyDeadlineLocalTime ||
        grace != settings.gracePeriodMinutes ||
        reminder != settings.reminderBeforeMinutes ||
        autoAlert != settings.autoAlertDelayMinutes ||
        _isMonitoringEnabled != settings.isMonitoringEnabled ||
        _isAutoAlertEnabled != settings.isAutoAlertEnabled;
  }

  TimeOfDay? _parseTimeOfDay(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    return TimeOfDay(hour: hour, minute: minute);
  }

  // Helper để trigger setState khi user type, giúp re-evaluate _hasChanges
  void _onInputChanged(void Function() clearError) {
    setState(() {
      clearError();
    });
  }

  Future<void> _onSavePressed(SafetySettingsState state) async {
    if (state.isSaving || state.settings == null) return;

    setState(() => _clearInlineErrors());
    final currentSettings = state.settings!;

    int? gracePeriodMinutes;
    int? reminderBeforeMinutes;
    int? autoAlertDelayMinutes;

    // Chỉ validate format phút nếu Monitoring đang được Bật
    if (_isMonitoringEnabled) {
      gracePeriodMinutes = int.tryParse(_gracePeriodController.text.trim());
      reminderBeforeMinutes = int.tryParse(
        _reminderBeforeController.text.trim(),
      );
      autoAlertDelayMinutes = int.tryParse(
        _autoAlertDelayController.text.trim(),
      );

      bool hasParseError = false;

      if (gracePeriodMinutes == null) {
        _gracePeriodError = _minuteParseError;
        hasParseError = true;
      }
      if (reminderBeforeMinutes == null) {
        _reminderBeforeError = _minuteParseError;
        hasParseError = true;
      }
      if (autoAlertDelayMinutes == null) {
        _autoAlertDelayError = _minuteParseError;
        hasParseError = true;
      }

      if (hasParseError) {
        setState(() {});
        return;
      }
    }

    // Partial Update: Chỉ gửi những field có sự thay đổi (Truyền null cho field không đổi)
    final params = UpdateSafetySettingsParams(
      dailyDeadlineLocalTime:
          _dailyDeadlineLocalTime != currentSettings.dailyDeadlineLocalTime
          ? _dailyDeadlineLocalTime
          : null,

      gracePeriodMinutes:
          (_isMonitoringEnabled &&
              gracePeriodMinutes != currentSettings.gracePeriodMinutes)
          ? gracePeriodMinutes
          : null,

      reminderBeforeMinutes:
          (_isMonitoringEnabled &&
              reminderBeforeMinutes != currentSettings.reminderBeforeMinutes)
          ? reminderBeforeMinutes
          : null,

      autoAlertDelayMinutes:
          (_isMonitoringEnabled &&
              autoAlertDelayMinutes != currentSettings.autoAlertDelayMinutes)
          ? autoAlertDelayMinutes
          : null,

      isMonitoringEnabled:
          _isMonitoringEnabled != currentSettings.isMonitoringEnabled
          ? _isMonitoringEnabled
          : null,

      isAutoAlertEnabled:
          _isAutoAlertEnabled != currentSettings.isAutoAlertEnabled
          ? _isAutoAlertEnabled
          : null,
    );

    final success = await ref
        .read(safetySettingsNotifierProvider.notifier)
        .updateSettings(params);

    if (!success && mounted) {
      final errorMessage = ref
          .read(safetySettingsNotifierProvider)
          .errorMessage;
      _applyValidationError(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(safetySettingsNotifierProvider);
    final settings = state.settings;

    final showInitialLoading = state.isLoading && settings == null;

    // Logic xác định Button Save có được enable hay không
    final bool canSave = settings != null && _hasChanges(settings);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt an toàn'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: AppScreenLayout(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: showInitialLoading
              ? const Center(child: CircularProgressIndicator())
              : settings == null
              ? _SafetySettingsErrorState(
                  onRetry: () {
                    ref
                        .read(safetySettingsNotifierProvider.notifier)
                        .loadSettings(forceRefresh: true);
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          AppSwitchButton(
                            label: 'Bật theo dõi an toàn',
                            description:
                                'Hệ thống sẽ theo dõi khung giờ và điều kiện an toàn của bạn.',
                            value: _isMonitoringEnabled,
                            enabled: !state.isSaving,
                            onChanged: (value) {
                              setState(() {
                                _isMonitoringEnabled = value;
                                if (!value) {
                                  _isAutoAlertEnabled = false;
                                  _clearInlineErrors();
                                }
                              });
                            },
                          ),
                          if (_isMonitoringEnabled) ...[
                            const SizedBox(height: 14),
                            if (settings.isDefault) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: AppText(
                                  'Bạn đang dùng cấu hình mặc định. Hãy lưu để cá nhân hóa cài đặt an toàn.',
                                  preset: AppTextPreset.bodySmall,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                            _SafetyTimePickerField(
                              label: 'Giờ giới hạn mỗi ngày',
                              value: _dailyDeadlineLocalTime,
                              errorText: _deadlineError,
                              onTap: _onPickDeadline,
                            ),
                            const SizedBox(height: 14),
                            Input(
                              labelText:
                                  'Thời gian gia hạn sau giờ giới hạn (phút)',
                              keyboardType: TextInputType.number,
                              controller: _gracePeriodController,
                              onChanged: (_) => _onInputChanged(
                                () => _gracePeriodError = null,
                              ),
                              caption: _gracePeriodError,
                              state: _resolveInputState(
                                _gracePeriodController.text,
                                _gracePeriodError,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Input(
                              labelText: 'Nhắc trước giờ giới hạn (phút)',
                              keyboardType: TextInputType.number,
                              controller: _reminderBeforeController,
                              onChanged: (_) => _onInputChanged(
                                () => _reminderBeforeError = null,
                              ),
                              caption: _reminderBeforeError,
                              state: _resolveInputState(
                                _reminderBeforeController.text,
                                _reminderBeforeError,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Input(
                              labelText: 'Trì hoãn tự động cảnh báo (phút)',
                              keyboardType: TextInputType.number,
                              controller: _autoAlertDelayController,
                              onChanged: (_) => _onInputChanged(
                                () => _autoAlertDelayError = null,
                              ),
                              caption: _autoAlertDelayError,
                              state: _resolveInputState(
                                _autoAlertDelayController.text,
                                _autoAlertDelayError,
                              ),
                            ),
                            const SizedBox(height: 14),
                            AppSwitchButton(
                              label: 'Bật cảnh báo tự động',
                              description:
                                  'Gửi cảnh báo tự động sau thời gian trì hoãn nếu cần thiết.',
                              value: _isAutoAlertEnabled,
                              enabled: !state.isSaving,
                              onChanged: (value) {
                                setState(() => _isAutoAlertEnabled = value);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Button(
                      text: 'Lưu cài đặt',
                      isLoading: state.isSaving,
                      onPressed: canSave ? () => _onSavePressed(state) : null,
                      state: canSave
                          ? ButtonState.defaultState
                          : ButtonState.disabled,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _SafetyTimePickerField extends StatelessWidget {
  final String label;
  final String value;
  final String? errorText;
  final VoidCallback onTap;

  const _SafetyTimePickerField({
    required this.label,
    required this.value,
    required this.errorText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = errorText != null && errorText!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          preset: AppTextPreset.bodySmall,
          color: colorScheme.onSurface,
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Ink(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: hasError
                      ? colorScheme.error
                      : colorScheme.outline.withValues(alpha: 0.6),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      value,
                      preset: AppTextPreset.bodyMedium,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Icon(
                    Icons.schedule_rounded,
                    color: colorScheme.onSurface.withValues(alpha: 0.68),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          AppText(
            errorText!.trim(),
            preset: AppTextPreset.bodySmall,
            color: colorScheme.error,
          ),
        ],
      ],
    );
  }
}

class _SafetySettingsErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _SafetySettingsErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppText('Không thể tải cài đặt an toàn'),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}
