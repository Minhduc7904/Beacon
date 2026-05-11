import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/image/logo_image.dart';
import '../../../../core/widgets/layout/screen_layout.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final shouldShowOnboarding = await ref
        .read(shouldShowOnboardingUseCaseProvider)
        .call();

    if (!mounted) {
      return;
    }

    if (shouldShowOnboarding) {
      context.pushReplacement(AppRoutes.onboarding);
      return;
    }

    final localDatasource = ref.read(authLocalDatasourceProvider);

    final accessToken = await localDatasource.getAccessToken();
    final refreshToken = await localDatasource.getRefreshToken();

    if (!mounted) {
      return;
    }

    final isAuthenticated =
        accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    if (isAuthenticated) {
      unawaited(_connectSignalR());
      unawaited(
        ref
            .read(pushNotificationServiceProvider)
            .syncCurrentDeviceTokenIfAuthorized(),
      );
      context.go(AppRoutes.home);
      return;
    }

    if (!mounted) {
      return;
    }

    context.go(AppRoutes.onboarding);
  }

  Future<void> _connectSignalR() async {
    await ref.read(signalRServiceProvider).connect();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
        child: AppScreenLayout(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogoImage(
                  width: 359,
                  height: 380,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
