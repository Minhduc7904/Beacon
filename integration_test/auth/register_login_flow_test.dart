import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../config/register_login_test_user.dart';
import '../helpers/integration_test_app.dart';
import '../robots/auth_flow_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('registers a new account, logs in, and lands on Home', (
    tester,
  ) async {
    final app = await pumpBeaconIntegrationApp(
      tester,
      autoLoginAfterRegister: false,
    );
    final robot = AuthFlowRobot(tester);
    const user = RegisterLoginTestUser.defaultUser;

    await robot.openRegisterFromOnboarding();
    await robot.submitRegistration(user);
    await robot.expectLoginVisible();
    await robot.login(user);
    await robot.expectHomeVisible();

    expect(app.authRepository.registerCallCount, 1);
    expect(app.authRepository.loginCallCount, 1);
  });
}
