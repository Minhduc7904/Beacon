import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/image/logo_image.dart';

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
    final localDatasource = ref.read(authLocalDatasourceProvider);

    final accessToken = await localDatasource.getAccessToken();
    final refreshToken = await localDatasource.getRefreshToken();

    if (!mounted) {
      return;
    }

    final isAuthenticated =
        accessToken != null && accessToken.isNotEmpty &&
        refreshToken != null && refreshToken.isNotEmpty;

    context.go(isAuthenticated ? AppRoutes.home : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
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
    );
  }
}
