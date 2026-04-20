import 'test_post_media.dart';

class TestPostMediaRunnerController {
  TestPostMediaRunnerController({TestPostMediaFlow? flow})
    : _flow = flow ?? TestPostMediaFlow();

  final TestPostMediaFlow _flow;

  bool _isRunnerSheetVisible = false;
  bool _isRunAllRunning = false;
  int _runAllSession = 0;

  TestPostMediaFlowState get flowState => _flow.state;
  bool get isRunnerSheetVisible => _isRunnerSheetVisible;
  bool get isRunAllRunning => _isRunAllRunning;

  TestPostMediaNavigationAction start({
    required String username,
    required String password,
  }) {
    final action = _flow.start(username: username, password: password);
    if (action == TestPostMediaNavigationAction.none) {
      return action;
    }

    cancelRunAll();
    return action;
  }

  TestPostMediaNavigationAction continueStep() {
    if (_isRunAllRunning) {
      return TestPostMediaNavigationAction.none;
    }

    return _flow.continueStep();
  }

  TestPostMediaNavigationAction continueStepForRunAll() {
    return _flow.continueStep();
  }

  TestPostMediaNavigationAction restart() {
    final action = _flow.restart();
    if (action == TestPostMediaNavigationAction.none) {
      return action;
    }

    cancelRunAll();
    return action;
  }

  bool stopRunAllIfNeeded() {
    if (!_isRunAllRunning) {
      return false;
    }

    cancelRunAll();
    return true;
  }

  void stopRunner() {
    _flow.stop();
    cancelRunAll();
    _isRunnerSheetVisible = false;
  }

  void openRunnerSheet() {
    if (!_flow.state.isRunning) {
      return;
    }

    _isRunnerSheetVisible = true;
  }

  int? startRunAllSession() {
    final state = _flow.state;
    if (_isRunAllRunning ||
        !state.isRunning ||
        state.hasBlockingError ||
        state.isCompleted) {
      return null;
    }

    _runAllSession += 1;
    _isRunAllRunning = true;
    return _runAllSession;
  }

  bool isRunAllSessionActive(int session) {
    return _isRunAllRunning && session == _runAllSession;
  }

  bool shouldStopRunAllLoop() {
    final state = _flow.state;
    return !state.isRunning ||
        state.hasBlockingError ||
        state.isCompleted ||
        state.stepCounter >= 5;
  }

  void finishRunAllSession(int session) {
    if (session != _runAllSession) {
      return;
    }

    _isRunAllRunning = false;
  }

  void stopRunAllWhenFlowDoneOrBlocked() {
    final state = _flow.state;
    if (state.hasBlockingError || state.isCompleted) {
      _isRunAllRunning = false;
    }
  }

  bool appendLoginSuccessLog({String? apiMessage}) {
    return _flow.appendLoginSuccessLog(apiMessage: apiMessage);
  }

  bool appendCaptureSuccessLog() {
    return _flow.appendCaptureSuccessLog();
  }

  bool appendPostSendSuccessLog({String? message}) {
    return _flow.appendPostSendSuccessLog(message: message);
  }

  bool appendPostSendErrorLog({required String errorMessage}) {
    return _flow.appendPostSendErrorLog(errorMessage: errorMessage);
  }

  bool appendErrorLog({required String errorMessage}) {
    return _flow.appendErrorLog(errorMessage: errorMessage);
  }

  void cancelRunAll() {
    _runAllSession += 1;
    _isRunAllRunning = false;
  }
}
