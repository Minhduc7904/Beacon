import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../widgets/home_action_button.dart';
import '../widgets/home_camera_box.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
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

      ref.read(homeNotifierProvider.notifier).initializeCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ref.read(homeNotifierProvider.notifier).disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(homeNotifierProvider.notifier).onLifecycleChanged(state);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(meProfileProvider).valueOrNull;

    ref.listen(homeNotifierProvider, (previous, next) {
      final previousPath = previous?.capturedImagePath;
      final nextPath = next.capturedImagePath;

      if (nextPath == null || nextPath.isEmpty || nextPath == previousPath) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) {
          return;
        }

        await context.pushNamed(AppRoutes.postPreviewName, extra: nextPath);
        if (!mounted) {
          return;
        }

        ref.read(homeNotifierProvider.notifier).clearCapturedImage();
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => context.pushNamed(AppRoutes.profileName),
              child: UserAvatar(
                avatarUrl: profile?.avatarUrl,
                givenName: profile?.givenName,
                size: 34,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: AppScreenLayout(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const Spacer(),
              const HomeCameraBox(),
              const SizedBox(height: 24),
              const HomeActionButton(),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
