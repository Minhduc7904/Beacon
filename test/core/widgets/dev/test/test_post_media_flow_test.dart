import 'package:beacon_app/core/widgets/dev/test/test_post_media.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TestPostMediaFlow', () {
    test('start returns none when username or password is empty', () {
      final flow = TestPostMediaFlow();

      final actionWithEmptyUsername = flow.start(username: ' ', password: '123');
      final actionWithEmptyPassword = flow.start(username: 'user', password: '');

      expect(actionWithEmptyUsername, TestPostMediaNavigationAction.none);
      expect(actionWithEmptyPassword, TestPostMediaNavigationAction.none);
      expect(flow.state.isRunning, isFalse);
      expect(flow.state.stepCounter, 0);
    });

    test('start initializes step 1 and navigates to logout', () {
      final flow = TestPostMediaFlow();

      final action = flow.start(username: ' user_1 ', password: 'secret');

      expect(action, TestPostMediaNavigationAction.goLogout);
      expect(flow.state.isRunning, isTrue);
      expect(flow.state.username, 'user_1');
      expect(flow.state.stepCounter, 1);
      expect(flow.state.stepLogs, isNotEmpty);
      expect(flow.state.stepLogs.last.message, contains('Step 1:'));
    });

    test('continue maps step 2 to 5 actions from definition', () {
      final flow = TestPostMediaFlow();
      flow.start(username: 'user', password: 'secret');

      expect(flow.continueStep(), TestPostMediaNavigationAction.pushLogin);
      expect(flow.state.stepCounter, 2);

      expect(
        flow.continueStep(),
        TestPostMediaNavigationAction.prefillAndSubmitLogin,
      );
      expect(flow.state.stepCounter, 3);

      expect(flow.continueStep(), TestPostMediaNavigationAction.goHomeAndCapture);
      expect(flow.state.stepCounter, 4);

      expect(
        flow.continueStep(),
        TestPostMediaNavigationAction.triggerPostPreviewSend,
      );
      expect(flow.state.stepCounter, 5);

      expect(flow.continueStep(), TestPostMediaNavigationAction.none);
      expect(flow.state.stepCounter, 5);
    });

    test('post send success marks completed and blocks next continue', () {
      final flow = TestPostMediaFlow();
      flow.start(username: 'user', password: 'secret');
      flow.continueStep();
      flow.continueStep();
      flow.continueStep();
      flow.continueStep();

      final appended = flow.appendPostSendSuccessLog(message: 'Done');

      expect(appended, isTrue);
      expect(flow.state.isCompleted, isTrue);
      expect(flow.continueStep(), TestPostMediaNavigationAction.none);
    });

    test('error log marks blocking and blocks next continue', () {
      final flow = TestPostMediaFlow();
      flow.start(username: 'user', password: 'secret');

      final appended = flow.appendErrorLog(errorMessage: 'boom');

      expect(appended, isTrue);
      expect(flow.state.hasBlockingError, isTrue);
      expect(flow.continueStep(), TestPostMediaNavigationAction.none);
    });

    test('restart resets to step 1 when running', () {
      final flow = TestPostMediaFlow();
      flow.start(username: 'user', password: 'secret');
      flow.continueStep();
      flow.continueStep();

      final action = flow.restart();

      expect(action, TestPostMediaNavigationAction.goLogout);
      expect(flow.state.stepCounter, 1);
      expect(flow.state.isCompleted, isFalse);
      expect(flow.state.hasBlockingError, isFalse);
      expect(flow.state.stepLogs.last.message, contains('Step 1:'));
    });
  });
}
