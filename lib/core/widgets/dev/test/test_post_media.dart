enum TestPostMediaNavigationAction {
  none,
  goLogout,
  pushLogin,
  prefillAndSubmitLogin,
  goHomeAndCapture,
  triggerPostPreviewSend,
}

class _TestStepDefinition {
  const _TestStepDefinition({
    required this.message,
    required this.action,
  });

  final String message;
  final TestPostMediaNavigationAction action;
}

class TestPostMediaLogEntry {
  const TestPostMediaLogEntry({
    required this.message,
    this.isError = false,
  });

  final String message;
  final bool isError;
}

class TestPostMediaFlowState {
  const TestPostMediaFlowState({
    required this.isRunning,
    required this.username,
    required this.password,
    required this.hasBlockingError,
    required this.isCompleted,
    required this.stepCounter,
    required this.stepLogs,
  });

  factory TestPostMediaFlowState.initial() {
    return const TestPostMediaFlowState(
      isRunning: false,
      username: '',
      password: '',
      hasBlockingError: false,
      isCompleted: false,
      stepCounter: 0,
      stepLogs: <TestPostMediaLogEntry>[],
    );
  }

  final bool isRunning;
  final String username;
  final String password;
  final bool hasBlockingError;
  final bool isCompleted;
  final int stepCounter;
  final List<TestPostMediaLogEntry> stepLogs;

  TestPostMediaFlowState copyWith({
    bool? isRunning,
    String? username,
    String? password,
    bool? hasBlockingError,
    bool? isCompleted,
    int? stepCounter,
    List<TestPostMediaLogEntry>? stepLogs,
  }) {
    return TestPostMediaFlowState(
      isRunning: isRunning ?? this.isRunning,
      username: username ?? this.username,
      password: password ?? this.password,
      hasBlockingError: hasBlockingError ?? this.hasBlockingError,
      isCompleted: isCompleted ?? this.isCompleted,
      stepCounter: stepCounter ?? this.stepCounter,
      stepLogs: stepLogs ?? this.stepLogs,
    );
  }
}

class TestPostMediaFlow {
  TestPostMediaFlowState _state = TestPostMediaFlowState.initial();

  static const String _stepOneMessage =
      'Step 1: go tới trang logout để refresh lại phiên đăng nhập';

  static const Map<int, _TestStepDefinition> _stepDefinitions = {
    2: _TestStepDefinition(
      message: 'Step 2: Ấn nút Đăng nhập ở onboarding (push tới màn login)',
      action: TestPostMediaNavigationAction.pushLogin,
    ),
    3: _TestStepDefinition(
      message: 'Step 3: Điền tài khoản vào input login và bấm Đăng nhập',
      action: TestPostMediaNavigationAction.prefillAndSubmitLogin,
    ),
    4: _TestStepDefinition(
      message: 'Step 4: Ấn nút chụp ở trang home',
      action: TestPostMediaNavigationAction.goHomeAndCapture,
    ),
    5: _TestStepDefinition(
      message: 'Step 5: Ấn nút gửi ở trang post review',
      action: TestPostMediaNavigationAction.triggerPostPreviewSend,
    ),
  };

  TestPostMediaFlowState get state => _state;

  TestPostMediaNavigationAction start({
    required String username,
    required String password,
  }) {
    final normalizedUsername = username.trim();
    if (normalizedUsername.isEmpty || password.isEmpty) {
      return TestPostMediaNavigationAction.none;
    }

    _state = _state.copyWith(
      isRunning: true,
      username: normalizedUsername,
      password: password,
      hasBlockingError: false,
      isCompleted: false,
      stepCounter: 1,
      stepLogs: <TestPostMediaLogEntry>[
        TestPostMediaLogEntry(
          message: 'Bắt đầu test post media với tài khoản: $normalizedUsername',
        ),
        const TestPostMediaLogEntry(message: _stepOneMessage),
      ],
    );

    return TestPostMediaNavigationAction.goLogout;
  }

  TestPostMediaNavigationAction continueStep() {
    if (!_state.isRunning || _state.hasBlockingError || _state.isCompleted) {
      return TestPostMediaNavigationAction.none;
    }

    if (_state.stepCounter >= 5) {
      return TestPostMediaNavigationAction.none;
    }

    final nextStep = _state.stepCounter + 1;
    final stepDefinition = _stepDefinitions[nextStep];
    if (stepDefinition != null) {
      _state = _state.copyWith(
        stepCounter: nextStep,
        stepLogs: <TestPostMediaLogEntry>[
          ..._state.stepLogs,
          TestPostMediaLogEntry(message: stepDefinition.message),
        ],
      );
      return stepDefinition.action;
    }

    _state = _state.copyWith(
      stepCounter: nextStep,
      stepLogs: <TestPostMediaLogEntry>[
        ..._state.stepLogs,
        TestPostMediaLogEntry(message: 'Step $nextStep: Tiếp tục chạy test'),
      ],
    );

    return TestPostMediaNavigationAction.none;
  }

  TestPostMediaNavigationAction restart() {
    if (!_state.isRunning || _state.username.isEmpty) {
      return TestPostMediaNavigationAction.none;
    }

    _state = _state.copyWith(
      hasBlockingError: false,
      isCompleted: false,
      stepCounter: 1,
      stepLogs: <TestPostMediaLogEntry>[
        TestPostMediaLogEntry(
          message: 'Restart test post media với tài khoản: ${_state.username}',
        ),
        const TestPostMediaLogEntry(message: _stepOneMessage),
      ],
    );

    return TestPostMediaNavigationAction.goLogout;
  }

  bool appendLoginSuccessLog({String? apiMessage}) {
    if (!_state.isRunning) {
      return false;
    }

    final normalizedMessage = apiMessage?.trim() ?? '';
    final successMessage = normalizedMessage.isEmpty
        ? 'Step ${_state.stepCounter}: Đăng nhập thành công'
        : 'Step ${_state.stepCounter}: $normalizedMessage';

    return _appendLog(successMessage);
  }

  bool appendCaptureSuccessLog() {
    if (!_state.isRunning) {
      return false;
    }

    return _appendLog(
      'Step ${_state.stepCounter}: Chụp ảnh thành công',
    );
  }

  bool appendPostSendSuccessLog({String? message}) {
    if (!_state.isRunning) {
      return false;
    }

    final normalizedMessage = message?.trim() ?? '';
    final successMessage = normalizedMessage.isEmpty
        ? 'Step ${_state.stepCounter}: Gửi ảnh thành công'
        : 'Step ${_state.stepCounter}: $normalizedMessage';

    final appended = _appendLog(successMessage);
    if (!appended) {
      return false;
    }

    _state = _state.copyWith(isCompleted: true);
    return true;
  }

  bool appendPostSendErrorLog({required String errorMessage}) {
    if (!_state.isRunning) {
      return false;
    }

    final normalized = errorMessage.trim();
    final message = normalized.isEmpty
        ? 'Step ${_state.stepCounter}: Gửi ảnh không thành công'
        : 'Step ${_state.stepCounter}: Gửi ảnh không thành công: $normalized';

    final appended = _appendLog(message, isError: true);
    if (!appended) {
      return false;
    }

    _state = _state.copyWith(hasBlockingError: true);
    return true;
  }

  bool appendErrorLog({required String errorMessage}) {
    if (!_state.isRunning) {
      return false;
    }

    final normalized = errorMessage.trim();
    final message = normalized.isEmpty
        ? 'Step ${_state.stepCounter}: Có lỗi xảy ra'
        : (normalized.startsWith('Step ')
              ? normalized
              : 'Step ${_state.stepCounter}: $normalized');

    final appended = _appendLog(message, isError: true);
    if (!appended) {
      return false;
    }

    _state = _state.copyWith(hasBlockingError: true);
    return true;
  }

  bool _appendLog(String message, {bool isError = false}) {
    if (_state.stepLogs.isNotEmpty) {
      final last = _state.stepLogs.last;
      if (last.message == message && last.isError == isError) {
        return false;
      }
    }

    _state = _state.copyWith(
      stepLogs: <TestPostMediaLogEntry>[
        ..._state.stepLogs,
        TestPostMediaLogEntry(message: message, isError: isError),
      ],
    );
    return true;
  }

  void stop() {
    _state = TestPostMediaFlowState.initial();
  }
}
