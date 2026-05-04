import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/button/icon_circle_button.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../feed/presentation/pages/feed_page.dart';
import '../widgets/home/home_body.dart';
import '../widgets/home/home_streak_chip.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, this.autoCaptureOnOpen = false});

  final bool autoCaptureOnOpen;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  static const int _streakDays = 7;

  /// 🔥 Track lifecycle to refresh when returning to this page
  AppLifecycleState? _lastLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final profile = ref.read(meProfileProvider).valueOrNull;
      if (profile == null) {
        ref.read(meProfileProvider.notifier).fetchProfile();
      }

      ref.read(homeCheckinNotifierProvider.notifier).load();
      ref.read(feedProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 🔥 Refresh data when app returns to resumed state (e.g., returning from another page)
    if (_lastLifecycleState == AppLifecycleState.paused &&
        state == AppLifecycleState.resumed &&
        mounted) {
      ref.read(homeCheckinNotifierProvider.notifier).load(forceRefresh: true);
    }
    _lastLifecycleState = state;
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(meProfileProvider).valueOrNull;
    final colorScheme = Theme.of(context).colorScheme;

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
        title: HomeStreakChip(days: _streakDays),
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
                context.pushNamed(AppRoutes.messageListName);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: const HomeBody(),
      ),
    );
  }
}
