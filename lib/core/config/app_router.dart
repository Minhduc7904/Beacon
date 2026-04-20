import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/logout_page.dart';
import '../../features/auth/presentation/pages/register/register_draft_data.dart';
import '../../features/auth/presentation/pages/register/register_page_email.dart';
import '../../features/auth/presentation/pages/register/register_page_name.dart';
import '../../features/auth/presentation/pages/register/register_page_phone_number.dart';
import '../../features/auth/presentation/pages/register/register_page_password.dart';
import '../../features/auth/presentation/pages/register/register_page_username.dart';
import '../../features/home/presentation/pages/home.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/post_preview/presentation/pages/post_preview_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/widgets/presentation/page/shared_widgets_page.dart';
import '../observers/app_route_stack_observer.dart';
import '../pages/not_found_page.dart';
import '../widgets/auth_guard.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

CustomTransitionPage<void> _buildSlidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

CustomTransitionPage<void> _buildCenterScalePage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scale = Tween<double>(begin: 0.9, end: 1.0).chain(
        CurveTween(curve: Curves.easeOutCubic),
      );
      final fade = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.easeOut),
      );

      return FadeTransition(
        opacity: animation.drive(fade),
        child: ScaleTransition(
          scale: animation.drive(scale),
          child: child,
        ),
      );
    },
  );
}

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  observers: [appRouteStackObserver],
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splashName,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboardingName,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      pageBuilder: (context, state) {
        LoginAutoFillData? autoFillData;
        final extra = state.extra;
        if (extra is Map<String, dynamic>) {
          final username = extra['username'];
          final password = extra['password'];
          final autoSubmit = extra['autoSubmit'];

          if (username is String &&
              password is String &&
              username.trim().isNotEmpty) {
            autoFillData = LoginAutoFillData(
              username: username,
              password: password,
              autoSubmit: autoSubmit == true,
            );
          }
        }

        return _buildSlidePage(
          state,
          LoginPage(autoFillData: autoFillData),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.registerName,
      pageBuilder: (context, state) =>
          _buildSlidePage(state, const RegisterPageEmail()),
    ),
    GoRoute(
      path: AppRoutes.registerPhoneNumber,
      name: AppRoutes.registerPhoneNumberName,
      pageBuilder: (context, state) {
        final draft = state.extra;
        if (draft is! RegisterDraftData || !draft.hasEmail) {
          return _buildSlidePage(state, const RegisterPageEmail());
        }

        return _buildSlidePage(state, RegisterPagePhoneNumber(draft: draft));
      },
    ),
    GoRoute(
      path: AppRoutes.registerPassword,
      name: AppRoutes.registerPasswordName,
      pageBuilder: (context, state) {
        final draft = state.extra;
        if (draft is! RegisterDraftData ||
            !draft.hasEmail ||
            !draft.hasPhoneNumber) {
          return _buildSlidePage(state, const RegisterPageEmail());
        }

        return _buildSlidePage(state, RegisterPagePassword(draft: draft));
      },
    ),
    GoRoute(
      path: AppRoutes.registerNameStep,
      name: AppRoutes.registerNameStepName,
      pageBuilder: (context, state) {
        final draft = state.extra;
        if (draft is! RegisterDraftData ||
            !draft.hasEmail ||
            !draft.hasPhoneNumber ||
            !draft.hasPassword) {
          return _buildSlidePage(state, const RegisterPageEmail());
        }

        return _buildSlidePage(state, RegisterPageName(draft: draft));
      },
    ),
    GoRoute(
      path: AppRoutes.registerUsername,
      name: AppRoutes.registerUsernameName,
      pageBuilder: (context, state) {
        final draft = state.extra;
        if (draft is! RegisterDraftData ||
            !draft.hasEmail ||
            !draft.hasPhoneNumber ||
            !draft.hasPassword ||
            !draft.hasName) {
          return _buildSlidePage(state, const RegisterPageEmail());
        }

        return _buildSlidePage(state, RegisterPageUsername(draft: draft));
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.homeName,
      builder: (context, state) {
        var autoCaptureOnOpen = false;
        final extra = state.extra;

        if (extra is Map<String, dynamic>) {
          autoCaptureOnOpen = extra['autoCaptureOnOpen'] == true;
        }

        return AuthGuard(
          child: HomePage(autoCaptureOnOpen: autoCaptureOnOpen),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.postPreview,
      name: AppRoutes.postPreviewName,
      pageBuilder: (context, state) {
        String? filePath;

        final extra = state.extra;
        if (extra is String) {
          filePath = extra;
        } else if (extra is Map<String, dynamic>) {
          final path = extra['filePath'];
          if (path is String) {
            filePath = path;
          }
        }

        if (filePath == null || filePath.trim().isEmpty) {
          return _buildSlidePage(state, const NotFoundPage());
        }

        return _buildCenterScalePage(
          state,
          AuthGuard(child: PostPreviewPage(filePath: filePath)),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.logout,
      name: AppRoutes.logoutName,
      builder: (context, state) => const LogoutPage(),
    ),
    GoRoute(
      path: AppRoutes.widgets,
      name: AppRoutes.widgetsName,
      builder: (context, state) => const SharedWidgetsPage(),
    ),
  ],
);
