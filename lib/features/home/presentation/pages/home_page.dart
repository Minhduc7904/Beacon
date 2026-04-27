import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/button/icon_circle_button.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/text/text.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../controllers/home_checkin_state.dart';
import '../widgets/home_countdown_bubble.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, this.autoCaptureOnOpen = false});

  final bool autoCaptureOnOpen;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const int _streakDays = 7;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final profile = ref.read(meProfileProvider).valueOrNull;
      if (profile == null) {
        ref.read(meProfileProvider.notifier).fetchProfile();
      }

      ref.read(homeCheckinNotifierProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(meProfileProvider).valueOrNull;
    final state = ref.watch(homeCheckinNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final canCheckin =
        state.phase == HomeCheckinPhase.pending ||
        state.phase == HomeCheckinPhase.grace;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () => context.pushNamed(AppRoutes.profileName),
            child: UserAvatar(
              avatarUrl: profile?.avatarUrl,
              givenName: profile?.givenName,
              size: 38,
            ),
          ),
        ),
        title: _StreakChip(days: _streakDays),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconCircleButton(
              icon: Icons.chat_bubble_outline_rounded,
              size: 40,
              iconSize: 18,
              backgroundColor: colorScheme.surface,
              borderColor: colorScheme.outline,
              iconColor: colorScheme.onSurface,
              onPressed: () {
                ref
                    .read(appMessageProvider.notifier)
                    .addInfo('Chat sẽ sớm ra mắt');
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: AppScreenLayout(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: Center(child: HomeCountdownBubble(state: state)),
              ),
              const SizedBox(height: 20),
              _ActionRow(
                isCheckingIn: state.isCheckingIn,
                canCheckin: canCheckin,
                onCheckin: canCheckin
                    ? () => ref
                          .read(homeCheckinNotifierProvider.notifier)
                          .checkin()
                    : null,
                onMoodPressed: () {
                  ref
                      .read(appMessageProvider.notifier)
                      .addInfo('Mood check-in sẽ sớm có');
                },
                onCameraPressed: () =>
                    context.pushNamed(AppRoutes.cameraScreenName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final transparentSurface = colorScheme.surface.withValues(alpha: 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 6),
          AppText(
            '$days ngày',
            size: AppTextSize.tiny,
            spacing: AppTextSpacing.tight,
            weight: AppTextWeight.bold,
            color: colorScheme.onPrimaryContainer,
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.isCheckingIn,
    required this.canCheckin,
    required this.onCheckin,
    required this.onMoodPressed,
    required this.onCameraPressed,
  });

  final bool isCheckingIn;
  final bool canCheckin;
  final VoidCallback? onCheckin;
  final VoidCallback onMoodPressed;
  final VoidCallback onCameraPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconCircleButton(
          icon: Icons.emoji_emotions_rounded,
          size: 52,
          iconSize: 22,
          backgroundColor: colorScheme.surface,
          borderColor: colorScheme.outline,
          iconColor: colorScheme.onSurface,
          onPressed: onMoodPressed,
        ),
        _CheckinActionButton(
          isLoading: isCheckingIn,
          isEnabled: canCheckin,
          onPressed: onCheckin,
        ),
        IconCircleButton(
          icon: Icons.camera_alt_rounded,
          size: 52,
          iconSize: 22,
          backgroundColor: colorScheme.surface,
          borderColor: colorScheme.outline,
          iconColor: colorScheme.onSurface,
          onPressed: onCameraPressed,
        ),
      ],
    );
  }
}

class _CheckinActionButton extends StatelessWidget {
  const _CheckinActionButton({
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isEnabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final transparentSurface = colorScheme.surface.withValues(alpha: 0);
    final outerColor = isEnabled
        ? colorScheme.primary
        : colorScheme.outline.withValues(alpha: 0.6);
    final innerRing = isEnabled
        ? colorScheme.primary.withValues(alpha: 0.2)
        : colorScheme.outline.withValues(alpha: 0.2);
    final centerColor = isEnabled ? colorScheme.primary : colorScheme.outline;
    final iconColor = isEnabled ? colorScheme.onPrimary : colorScheme.onSurface;

    return SizedBox(
      width: 92,
      height: 92,
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
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: outerColor, width: 2),
                ),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: innerRing,
                  border: Border.all(
                    color: outerColor.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: centerColor,
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(iconColor),
                          ),
                        )
                      : Icon(Icons.shield_rounded, size: 24, color: iconColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
