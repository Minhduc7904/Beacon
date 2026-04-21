import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/presentation/controllers/auth_state.dart';

import '../../config/app_router.dart';
import '../../config/app_routes.dart';
import '../../providers/providers.dart';
import 'dev_api_menu_sheet.dart';
import 'dev_layout_menu_sheet.dart';
import 'dev_main_menu_sheet.dart';
import 'dev_models.dart';
import 'dev_routes_menu_sheet.dart';
import 'dev_test_menu_sheet.dart';
import 'dev_test_post_media_sheet.dart';
import 'dev_test_runner_sheet.dart';
import 'test/test_post_media.dart';
import 'test/test_post_media_runner_controller.dart';
import 'test/test_post_media_send_signal_provider.dart';
import 'test/test_post_media_state_listener_helpers.dart';

class DevSettingsBubble extends ConsumerStatefulWidget {
  const DevSettingsBubble({super.key});

  @override
  ConsumerState<DevSettingsBubble> createState() => _DevSettingsBubbleState();
}

class _DevSettingsBubbleState extends ConsumerState<DevSettingsBubble> {
  DevNavigationMode _mode = DevNavigationMode.push;
  bool _isMenuOpen = false;
  final TestPostMediaRunnerController _runnerController =
      TestPostMediaRunnerController();

  Future<void> _openMainMenu() async {
    if (_isMenuOpen) {
      return;
    }

    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    setState(() {
      _isMenuOpen = true;
    });

    try {
      await showModalBottomSheet<void>(
        context: navigatorContext,
        builder: (sheetContext) {
          return DevMainMenuSheet(
            showLayoutMenu: kDebugMode,
            onOpenRoutes: () {
              Navigator.of(sheetContext).pop();
              _openRoutesMenu();
            },
            onOpenApi: () {
              Navigator.of(sheetContext).pop();
              _openApiMenu();
            },
            onOpenTest: () {
              Navigator.of(sheetContext).pop();
              _openTestMenu();
            },
            onOpenLayout: () {
              Navigator.of(sheetContext).pop();
              _openLayoutMenu();
            },
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isMenuOpen = false;
        });
      }
    }
  }

  Future<void> _openLayoutMenu() async {
    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: navigatorContext,
      builder: (sheetContext) {
        return const DevLayoutMenuSheet();
      },
    );
  }

  Future<void> _openRoutesMenu() async {
    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: navigatorContext,
      isScrollControlled: true,
      builder: (sheetContext) {
        return DevRoutesMenuSheet(
          initialMode: _mode,
          onModeChanged: (mode) {
            setState(() {
              _mode = mode;
            });
          },
        );
      },
    );
  }

  Future<void> _openApiMenu() async {
    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: navigatorContext,
      isScrollControlled: true,
      builder: (sheetContext) {
        return const DevApiMenuSheet();
      },
    );
  }

  Future<void> _openTestMenu() async {
    if (_runnerController.flowState.isRunning) {
      _openRunnerControlSheet();
      return;
    }

    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: navigatorContext,
      builder: (sheetContext) {
        return DevTestMenuSheet(
          onOpenTestPostMedia: () {
            Navigator.of(sheetContext).pop();
            _openTestPostMediaSheet();
          },
        );
      },
    );
  }

  Future<void> _openTestPostMediaSheet() async {
    if (_runnerController.flowState.isRunning) {
      _openRunnerControlSheet();
      return;
    }

    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: navigatorContext,
      isScrollControlled: true,
      builder: (sheetContext) {
        return DevTestPostMediaSheet(
          onStart: (username, password) {
            Navigator.of(sheetContext).pop();
            _startTestPostMediaRunner(username: username, password: password);
          },
        );
      },
    );
  }

  void _startTestPostMediaRunner({
    required String username,
    required String password,
  }) {
    final navigationAction = _runnerController.start(
      username: username,
      password: password,
    );
    if (navigationAction == TestPostMediaNavigationAction.none) {
      return;
    }

    _refreshRunnerUi();

    _executeRunnerNavigation(navigationAction);
    _openRunnerControlSheet();
  }

  void _continueRunnerStep() {
    final navigationAction = _runnerController.continueStep();
    if (navigationAction == TestPostMediaNavigationAction.none &&
        !_runnerController.flowState.isRunning) {
      return;
    }

    _refreshRunnerUi();

    _executeRunnerNavigation(navigationAction);
  }

  void _restartRunner() {
    final navigationAction = _runnerController.restart();
    if (navigationAction == TestPostMediaNavigationAction.none) {
      return;
    }

    _refreshRunnerUi();

    _executeRunnerNavigation(navigationAction);
  }

  void _stopRunner() {
    if (_runnerController.stopRunAllIfNeeded()) {
      _refreshRunnerUi();
      return;
    }

    _runnerController.stopRunner();
    _refreshRunnerUi();

    appRouter.go(AppRoutes.logout);
  }

  void _openRunnerControlSheet() {
    if (!_runnerController.flowState.isRunning) {
      return;
    }

    _runnerController.openRunnerSheet();
    _refreshRunnerUi();
  }

  Future<void> _runAllSteps() async {
    final session = _runnerController.startRunAllSession();
    if (session == null) {
      return;
    }

    _refreshRunnerUi();

    while (mounted && _runnerController.isRunAllSessionActive(session)) {
      if (_runnerController.shouldStopRunAllLoop()) {
        break;
      }

      final navigationAction = _runnerController.continueStepForRunAll();
      if (navigationAction == TestPostMediaNavigationAction.none &&
          !_runnerController.flowState.isRunning) {
        break;
      }

      final triggeredStep = _runnerController.flowState.stepCounter;
      final baselineLogCount = _runnerController.flowState.stepLogs.length;

      _refreshRunnerUi();

      _executeRunnerNavigation(navigationAction);

      final canContinue = await _waitForRunAllStepCompletion(
        step: triggeredStep,
        baselineLogCount: baselineLogCount,
        session: session,
      );
      if (!canContinue) {
        break;
      }

      final after = _runnerController.flowState;
      if (!after.isRunning ||
          after.hasBlockingError ||
          after.isCompleted ||
          after.stepCounter >= 5) {
        break;
      }

      await Future<void>.delayed(const Duration(seconds: 1));
    }

    if (!mounted) {
      return;
    }

    _runnerController.finishRunAllSession(session);
    _refreshRunnerUi();
  }

  Future<bool> _waitForRunAllStepCompletion({
    required int step,
    required int baselineLogCount,
    required int session,
  }) async {
    // Step 2 is navigation-only, so no async completion signal is expected.
    if (step <= 2) {
      return true;
    }

    const timeout = Duration(seconds: 45);
    const pollInterval = Duration(milliseconds: 100);
    var elapsed = Duration.zero;

    while (mounted && _runnerController.isRunAllSessionActive(session)) {
      final current = _runnerController.flowState;
      if (!current.isRunning || current.hasBlockingError || current.isCompleted) {
        return true;
      }

      if (current.stepLogs.length > baselineLogCount) {
        return true;
      }

      if (elapsed >= timeout) {
        _runnerController.appendErrorLog(
          errorMessage: 'Step $step: Hết thời gian chờ hoàn tất',
        );

        _runnerController.finishRunAllSession(session);
        _refreshRunnerUi();
        return false;
      }

      await Future<void>.delayed(pollInterval);
      elapsed += pollInterval;
    }

    return false;
  }

  void _refreshRunnerUi() {
    if (!mounted) {
      return;
    }

    setState(() {
      // Trigger rebuild after runner state changes.
    });
  }

  void _syncRunAllWhenFlowDoneOrBlocked() {
    _runnerController.stopRunAllWhenFlowDoneOrBlocked();
  }

  void _executeRunnerNavigation(
    TestPostMediaNavigationAction action,
  ) {
    if (action == TestPostMediaNavigationAction.none) {
      return;
    }

    switch (action) {
      case TestPostMediaNavigationAction.none:
        break;
      case TestPostMediaNavigationAction.goLogout:
        appRouter.go(AppRoutes.logout);
        break;
      case TestPostMediaNavigationAction.pushLogin:
        appRouter.pushNamed(AppRoutes.loginName);
        break;
      case TestPostMediaNavigationAction.prefillAndSubmitLogin:
        appRouter.pushNamed(
          AppRoutes.loginName,
          extra: <String, dynamic>{
            'username': _runnerController.flowState.username,
            'password': _runnerController.flowState.password,
            'autoSubmit': true,
          },
        );
        break;
      case TestPostMediaNavigationAction.goHomeAndCapture:
        appRouter.goNamed(
          AppRoutes.homeName,
          extra: <String, dynamic>{
            'autoCaptureOnOpen': true,
          },
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_runnerController.flowState.isRunning) {
            return;
          }

          ref.read(homeNotifierProvider.notifier).capturePhoto(
                minimumPublishDelay: const Duration(milliseconds: 300),
              );
        });
        break;
      case TestPostMediaNavigationAction.triggerPostPreviewSend:
        final current = ref.read(testPostMediaSendSignalProvider);
        ref.read(testPostMediaSendSignalProvider.notifier).state = current + 1;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      final added = handleAuthStateForPostMediaTest(
        controller: _runnerController,
        state: state,
      );
      if (!added) {
        return;
      }

      _syncRunAllWhenFlowDoneOrBlocked();
      _refreshRunnerUi();
    });

    ref.listen(homeNotifierProvider, (previous, next) {
      final added = handleHomeStateForPostMediaTest(
        controller: _runnerController,
        previous: previous,
        next: next,
      );
      if (!added) {
        return;
      }

      _syncRunAllWhenFlowDoneOrBlocked();
      _refreshRunnerUi();
    });

    ref.listen(postPreviewNotifierProvider, (previous, next) {
      final added = handlePostPreviewStateForPostMediaTest(
        controller: _runnerController,
        previous: previous,
        next: next,
      );
      if (!added) {
        return;
      }

      _syncRunAllWhenFlowDoneOrBlocked();
      _refreshRunnerUi();
    });

    final flowState = _runnerController.flowState;
    final isRunnerBubbleVisible = flowState.isRunning;

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            right: 16,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FloatingActionButton.small(
                  heroTag: 'dev_settings_bubble',
                  onPressed: _isMenuOpen ? null : _openMainMenu,
                  child: const Icon(Icons.settings_rounded),
                ),
              ),
            ),
          ),
          if (isRunnerBubbleVisible && _runnerController.isRunnerSheetVisible)
            Positioned.fill(
              child: DevTestRunnerSheet(
                stepLogs: flowState.stepLogs,
                isContinueBlocked: flowState.hasBlockingError,
                isFlowCompleted: flowState.isCompleted,
                isRunAllRunning: _runnerController.isRunAllRunning,
                onContinue: _continueRunnerStep,
                onRunAll: _runAllSteps,
                onRestart: _restartRunner,
                onStop: _stopRunner,
              ),
            ),
        ],
      ),
    );
  }
}
