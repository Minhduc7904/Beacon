import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: const SafeArea(child: HomeBody()),
    );
  }
}
