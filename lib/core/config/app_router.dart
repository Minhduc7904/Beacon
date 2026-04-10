import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/logout_page.dart';
import '../../features/dashboard/page/dashboard_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/widgets/page/shared_widgets_page.dart';
import '../pages/not_found_page.dart';
import '../widgets/auth_guard.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) => const AuthGuard(child: DashboardPage()),
    ),
    GoRoute(
      path: AppRoutes.logout,
      name: AppRoutes.logout,
      builder: (context, state) => const LogoutPage(),
    ),
    GoRoute(
      path: AppRoutes.widgets,
      name: AppRoutes.widgets,
      builder: (context, state) => const SharedWidgetsPage(),
    ),
  ],
);
