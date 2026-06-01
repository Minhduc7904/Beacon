import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/icons/app_icon.dart';
import '../../../../../core/theme/icons/app_icons.dart';
import '../../../../../core/widgets/button/icon_circle_button.dart';
import '../../../../../core/widgets/emoji/app_emoji.dart';
import '../../../../../core/widgets/emoji/app_emoji_picker_sheet.dart';
import '../../../../safety/presentation/widgets/safety_mood_calendar_button.dart';

typedef HomeCheckinCallback = Future<bool> Function(String? mood);

class HomeActionRow extends StatefulWidget {
  const HomeActionRow({
    super.key,
    required this.isCheckingIn,
    required this.canCheckin,
    required this.onCheckin,
    required this.onCameraPressed,
  });

  final bool isCheckingIn;
  final bool canCheckin;
  final HomeCheckinCallback? onCheckin;
  final VoidCallback onCameraPressed;

  @override
  State<HomeActionRow> createState() => _HomeActionRowState();
}

class _HomeActionRowState extends State<HomeActionRow> {
  static const List<String> _suggestedMoods = [
    '\u{1F60A}',
    '\u{1F60C}',
    '\u{1F970}',
    '\u{1F604}',
    '\u{1F60E}',
  ];

  final LayerLink _moodPickerLink = LayerLink();
  OverlayEntry? _moodPickerOverlay;
  bool _isMoodPickerVisible = false;
  bool _isEmojiPickerOpen = false;
  String? _selectedMood;

  @override
  void dispose() {
    _removeMoodPickerOverlay();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeActionRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.canCheckin && widget.onCheckin != null) {
      return;
    }

    _removeMoodPickerOverlay();
    _isMoodPickerVisible = false;
    _selectedMood = null;
  }

  void _openMoodPicker() {
    if (_isMoodPickerVisible) {
      return;
    }

    setState(() {
      _isMoodPickerVisible = true;
    });
    _insertMoodPickerOverlay();
  }

  void _closeMoodPicker() {
    if (!_isMoodPickerVisible && _selectedMood == null) {
      return;
    }

    _removeMoodPickerOverlay();
    if (!mounted) {
      _isMoodPickerVisible = false;
      _selectedMood = null;
      return;
    }

    setState(() {
      _isMoodPickerVisible = false;
      _selectedMood = null;
    });
  }

  void _selectMood(String mood) {
    setState(() {
      _isMoodPickerVisible = true;
      _selectedMood = mood;
    });
    _moodPickerOverlay?.markNeedsBuild();
  }

  Future<void> _selectMoreMood() async {
    if (_isEmojiPickerOpen) {
      return;
    }

    setState(() {
      _isEmojiPickerOpen = true;
    });
    _moodPickerOverlay?.markNeedsBuild();

    final emoji = await showAppEmojiPickerSheet(
      context,
      useRootNavigator: true,
    );
    if (!mounted) {
      _isEmojiPickerOpen = false;
      return;
    }

    final trimmedEmoji = emoji?.trim();
    if (trimmedEmoji == null || trimmedEmoji.isEmpty) {
      setState(() {
        _isEmojiPickerOpen = false;
      });
      _moodPickerOverlay?.markNeedsBuild();
      return;
    }

    setState(() {
      _isEmojiPickerOpen = false;
      _isMoodPickerVisible = true;
      _selectedMood = trimmedEmoji;
    });
    _moodPickerOverlay?.markNeedsBuild();
    if (_moodPickerOverlay == null) {
      _insertMoodPickerOverlay();
    } else {
      _moodPickerOverlay?.markNeedsBuild();
    }
  }

  Future<void> _handleCheckinPressed() async {
    final onCheckin = widget.onCheckin;
    if (!widget.canCheckin || onCheckin == null || widget.isCheckingIn) {
      return;
    }

    if (!_isMoodPickerVisible) {
      _openMoodPicker();
      return;
    }

    final didCheckin = await onCheckin(_selectedMood);
    if (!mounted || !didCheckin) {
      return;
    }

    _closeMoodPicker();
  }

  void _insertMoodPickerOverlay() {
    if (_moodPickerOverlay != null) {
      return;
    }

    final entry = OverlayEntry(
      builder: (context) {
        if (_isEmojiPickerOpen) {
          return const SizedBox.shrink();
        }

        return Positioned.fill(
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _moodPickerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.topCenter,
                followerAnchor: Alignment.bottomCenter,
                offset: const Offset(0, -10),
                child: _HomeMoodPicker(
                  selectedMood: _selectedMood,
                  suggestedMoods: _suggestedMoods,
                  onMoodSelected: _selectMood,
                  onClearPressed: _closeMoodPicker,
                  onMoreMoodPressed: () => unawaited(_selectMoreMood()),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(entry);
    _moodPickerOverlay = entry;
  }

  void _removeMoodPickerOverlay() {
    _moodPickerOverlay?.remove();
    _moodPickerOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SafetyMoodCalendarButton(enabled: !widget.isCheckingIn),
          CompositedTransformTarget(
            link: _moodPickerLink,
            child: _HomeCheckinActionButton(
              isLoading: widget.isCheckingIn,
              isEnabled: widget.canCheckin,
              isConfirming: _isMoodPickerVisible,
              selectedMood: _selectedMood,
              onPressed: _handleCheckinPressed,
            ),
          ),
          IconCircleButton(
            icon: AppIcons.camera,
            size: 60,
            iconSize: 32,
            backgroundColor: AppColors.sky100,
            borderColor: AppColors.teal100,
            iconColor: AppColors.teal400,
            borderWidth: 4,
            onPressed: widget.onCameraPressed,
          ),
        ],
      ),
    );
  }
}

class _HomeMoodPicker extends StatelessWidget {
  const _HomeMoodPicker({
    required this.selectedMood,
    required this.suggestedMoods,
    required this.onMoodSelected,
    required this.onClearPressed,
    required this.onMoreMoodPressed,
  });

  final String? selectedMood;
  final List<String> suggestedMoods;
  final ValueChanged<String> onMoodSelected;
  final VoidCallback onClearPressed;
  final VoidCallback onMoreMoodPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Material(
        color: AppColors.ink500.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MoodOptionButton(
                  isSelected: false,
                  onPressed: onClearPressed,
                  child: const AppIcon(
                    AppIcons.close,
                    size: 18,
                    color: AppColors.sky100,
                  ),
                ),
                for (final mood in suggestedMoods)
                  _MoodOptionButton(
                    isSelected: selectedMood == mood,
                    onPressed: () => onMoodSelected(mood),
                    child: AppEmoji(emoji: mood, size: 24),
                  ),
                _MoodOptionButton(
                  isSelected:
                      selectedMood != null &&
                      !suggestedMoods.contains(selectedMood),
                  onPressed: onMoreMoodPressed,
                  child: const AppIcon(
                    AppIcons.plus,
                    size: 18,
                    color: AppColors.sky100,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodOptionButton extends StatelessWidget {
  const _MoodOptionButton({
    required this.isSelected,
    required this.onPressed,
    required this.child,
  });

  final bool isSelected;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isSelected
            ? AppColors.teal400.withValues(alpha: 0.92)
            : Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(width: 36, height: 36, child: Center(child: child)),
        ),
      ),
    );
  }
}

class _HomeCheckinActionButton extends StatelessWidget {
  const _HomeCheckinActionButton({
    required this.isLoading,
    required this.isEnabled,
    required this.isConfirming,
    required this.selectedMood,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isEnabled;
  final bool isConfirming;
  final String? selectedMood;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final transparentSurface = AppColors.sky100.withValues(alpha: 0);
    final stateAlpha = isEnabled ? 1.0 : 0.45;
    final outerColor = AppColors.teal200.withValues(alpha: stateAlpha);
    final innerColor = AppColors.teal400.withValues(alpha: stateAlpha);
    final iconColor = AppColors.sky100.withValues(alpha: stateAlpha);

    return SizedBox(
      width: 128,
      height: 128,
      child: Material(
        color: transparentSurface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          customBorder: const CircleBorder(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: outerColor, width: 4),
                ),
              ),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: innerColor,
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation(iconColor),
                          ),
                        )
                      : _CheckinButtonIcon(
                          isConfirming: isConfirming,
                          selectedMood: selectedMood,
                          iconColor: iconColor,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckinButtonIcon extends StatelessWidget {
  const _CheckinButtonIcon({
    required this.isConfirming,
    required this.selectedMood,
    required this.iconColor,
  });

  final bool isConfirming;
  final String? selectedMood;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    if (!isConfirming) {
      return AppIcon(AppIcons.shieldPhosphor, size: 60, color: iconColor);
    }

    if (selectedMood == null) {
      return AppIcon(AppIcons.check, size: 58, color: iconColor);
    }

    return AppEmoji(emoji: selectedMood!, size: 52);
  }
}
