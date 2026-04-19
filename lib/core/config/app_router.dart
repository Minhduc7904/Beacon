import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/logout_page.dart';
import '../../features/auth/presentation/pages/register/register_page_email.dart';
import '../../features/dashboard/page/dashboard_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/widgets/presentation/page/shared_widgets_page.dart';
import '../observers/app_route_stack_observer.dart';
import '../pages/not_found_page.dart';
import '../widgets/auth_guard.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

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
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.registerName,
      builder: (context, state) => const RegisterPageEmail(),
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
