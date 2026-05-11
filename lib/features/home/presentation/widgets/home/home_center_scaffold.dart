import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_images.dart';
import '../../../../../core/providers/providers.dart';
import 'home_app_bar_content.dart';
import 'home_body.dart';

class HomeCenterScaffold extends ConsumerWidget {
  const HomeCenterScaffold({
    super.key,
    required this.onOpenProfile,
    required this.onOpenMessages,
    required this.streakDays,
    required this.unreadMessages,
  });

  final VoidCallback onOpenProfile;
  final VoidCallback onOpenMessages;
  final int streakDays;
  final int unreadMessages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(meProfileProvider).valueOrNull;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.surface.withValues(alpha: 0),
        surfaceTintColor: colorScheme.surface.withValues(alpha: 0),
        shadowColor: colorScheme.surface.withValues(alpha: 0),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: HomeAppBarContent(
          avatarUrl: profile?.avatarUrl,
          givenName: profile?.givenName,
          streakDays: streakDays,
          unreadMessages: unreadMessages,
          onOpenProfile: onOpenProfile,
          onOpenMessages: onOpenMessages,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.homeBackground,
            fit: BoxFit.cover,
          ),
          const SafeArea(child: HomeBody()),
        ],
      ),
    );
  }
}
