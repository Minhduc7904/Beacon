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
import '../../features/dashboard/page/dashboard_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/widgets/presentation/page/shared_widgets_page.dart';
import '../observers/app_route_stack_observer.dart';
import '../pages/not_found_page.dart';
import '../widgets/auth_guard.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

CustomTransitionPage<void> _buildSlidePage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
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
      pageBuilder: (context, state) =>
          _buildSlidePage(state, const LoginPage()),
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
      builder: (context, state) => const AuthGuard(child: DashboardPage()),
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
