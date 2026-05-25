import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/entities/user_profile.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/logout/logout_page.dart';
import '../../features/auth/presentation/pages/profile/edit_profile_page.dart';
import '../../features/auth/presentation/pages/profile/profile_page.dart';
import '../../features/auth/presentation/pages/register/register_draft_data.dart';
import '../../features/auth/presentation/pages/register/register_page_email.dart';
import '../../features/auth/presentation/pages/register/register_page_name.dart';
import '../../features/auth/presentation/pages/register/register_page_phone_number.dart';
import '../../features/auth/presentation/pages/register/register_page_password.dart';
import '../../features/auth/presentation/pages/register/register_page_username.dart';
import '../../features/home/presentation/pages/camera_screen.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/friends/presentation/pages/add_friends_page.dart';
import '../../features/message_groups/presentation/pages/message_group_list_page.dart';
import '../../features/message_groups/presentation/pages/group_chat_detail_page.dart';
import '../../features/message_groups/presentation/pages/message_group_add_members_page.dart';
import '../../features/message_groups/presentation/pages/message_group_info_page.dart';
import '../../features/message_groups/presentation/pages/message_group_members_page.dart';
import '../../features/message_groups/presentation/pages/message_group_notification_page.dart';
import '../../features/message_groups/presentation/pages/message_group_nicknames_page.dart';
import '../../features/message_groups/presentation/pages/message_group_search_results_page.dart';
import '../../features/message_groups/domain/entities/message_group.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/post_preview/presentation/pages/post_preview_page.dart';
import '../../features/safety/presentation/pages/safety_settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/widgets/presentation/page/shared_widgets_page.dart';
import '../observers/app_route_stack_observer.dart';
import '../pages/not_found_page.dart';
import '../widgets/auth_guard.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

String _resolvePageName(GoRouterState state) {
  final routeName = state.name?.trim();
  if (routeName != null && routeName.isNotEmpty) {
    return routeName;
  }

  final path = state.uri.path.trim();
  if (path.isNotEmpty) {
    return path;
  }

  return state.uri.toString();
}

CustomTransitionPage<void> _buildSlidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    name: _resolvePageName(state),
    arguments: state.extra,
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

CustomTransitionPage<void> _buildSlideFromLeftPage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    name: _resolvePageName(state),
    arguments: state.extra,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<Offset>(
        begin: const Offset(-1, 0),
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
    name: _resolvePageName(state),
    arguments: state.extra,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scale = Tween<double>(
        begin: 0.9,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      final fade = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOut));

      return FadeTransition(
        opacity: animation.drive(fade),
        child: ScaleTransition(scale: animation.drive(scale), child: child),
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

        return _buildSlidePage(state, LoginPage(autoFillData: autoFillData));
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
        String? targetPostId;
        final extra = state.extra;

        if (extra is Map<String, dynamic>) {
          autoCaptureOnOpen = extra['autoCaptureOnOpen'] == true;
          final postId = extra['targetPostId'];
          if (postId is String && postId.trim().isNotEmpty) {
            targetPostId = postId.trim();
          }
        }

        return AuthGuard(
          child: HomePage(
            autoCaptureOnOpen: autoCaptureOnOpen,
            targetPostId: targetPostId,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.cameraScreen,
      name: AppRoutes.cameraScreenName,
      builder: (context, state) {
        var autoCaptureOnOpen = false;
        final extra = state.extra;

        if (extra is Map<String, dynamic>) {
          autoCaptureOnOpen = extra['autoCaptureOnOpen'] == true;
        }

        return AuthGuard(
          child: CameraScreen(autoCaptureOnOpen: autoCaptureOnOpen),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: AppRoutes.profileName,
      pageBuilder: (context, state) =>
          _buildSlideFromLeftPage(state, const AuthGuard(child: ProfilePage())),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      name: AppRoutes.editProfileName,
      pageBuilder: (context, state) {
        final profile = state.extra;
        if (profile is! UserProfile) {
          return _buildSlidePage(state, const NotFoundPage());
        }

        return _buildSlidePage(
          state,
          AuthGuard(child: EditProfilePage(profile: profile)),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.safetySettings,
      name: AppRoutes.safetySettingsName,
      pageBuilder: (context, state) =>
          _buildSlidePage(state, const AuthGuard(child: SafetySettingsPage())),
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
    GoRoute(
      path: AppRoutes.messageList,
      name: AppRoutes.messageListName,
      pageBuilder: (context, state) => _buildSlidePage(
        state,
        const AuthGuard(child: MessageGroupListPage()),
      ),
    ),
    GoRoute(
      path: AppRoutes.chatDetail,
      name: AppRoutes.chatDetailName,
      pageBuilder: (context, state) {
        final group = state.extra;
        if (group is! MessageGroup) {
          return _buildSlidePage(state, const NotFoundPage());
        }

        return _buildSlidePage(
          state,
          AuthGuard(child: GroupChatDetailPage(group: group)),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.messageGroupInfo,
      name: AppRoutes.messageGroupInfoName,
      pageBuilder: (context, state) {
        final group = state.extra;
        if (group is! MessageGroup) {
          return _buildSlidePage(state, const NotFoundPage());
        }

        return _buildSlidePage(
          state,
          AuthGuard(child: MessageGroupInfoPage(group: group)),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.messageGroupMembers,
      name: AppRoutes.messageGroupMembersName,
      pageBuilder: (context, state) {
        final args = state.extra;
        if (args is! MessageGroupMembersPageArgs) {
          return _buildSlidePage(state, const NotFoundPage());
        }

        return _buildSlidePage(
          state,
          AuthGuard(
            child: MessageGroupMembersPage(
              group: args.group,
              detail: args.detail,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.messageGroupNicknames,
      name: AppRoutes.messageGroupNicknamesName,
      pageBuilder: (context, state) {
        final group = state.extra;
        if (group is! MessageGroup) {
          return _buildSlidePage(state, const NotFoundPage());
        }

        return _buildSlidePage(
          state,
          AuthGuard(child: MessageGroupNicknamesPage(group: group)),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.messageGroupAddMembers,
      name: AppRoutes.messageGroupAddMembersName,
      pageBuilder: (context, state) {
        final args = state.extra;
        if (args is! MessageGroupAddMembersPageArgs) {
          return _buildSlidePage(state, const NotFoundPage());
        }

        return _buildSlidePage(
          state,
          AuthGuard(
            child: MessageGroupAddMembersPage(
              group: args.group,
              detail: args.detail,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.messageGroupNotification,
      name: AppRoutes.messageGroupNotificationName,
      pageBuilder: (context, state) {
        final args = state.extra;
        if (args is! MessageGroupNotificationPageArgs) {
          return _buildSlidePage(state, const NotFoundPage());
        }

        return _buildSlidePage(
          state,
          AuthGuard(
            child: MessageGroupNotificationPage(
              groupId: args.groupId,
              initialMuted: args.isMuted,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.messageGroupSearchResults,
      name: AppRoutes.messageGroupSearchResultsName,
      pageBuilder: (context, state) {
        final args = state.extra;
        if (args is! MessageGroupSearchResultsArgs) {
          return _buildSlidePage(state, const NotFoundPage());
        }

        return _buildSlidePage(
          state,
          AuthGuard(
            child: MessageGroupSearchResultsPage(
              groupId: args.groupId,
              groupName: args.groupName,
              keyword: args.keyword,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.addFriends,
      name: AppRoutes.addFriendsName,
      pageBuilder: (context, state) =>
          _buildSlidePage(state, const AuthGuard(child: AddFriendsPage())),
    ),
  ],
);
