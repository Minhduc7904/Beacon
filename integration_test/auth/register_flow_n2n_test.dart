import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../config/register_login_test_user.dart';
import '../helpers/integration_test_app.dart';
import '../robots/auth_flow_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'registers a new account against the dev backend and lands on Home',
    (tester) async {
      await pumpBeaconIntegrationApp(tester);
      final robot = AuthFlowRobot(tester);
      const user = RegisterLoginTestUser.defaultUser;

      await robot.openRegisterFromOnboarding();
      await robot.submitRegistration(user);
      await robot.expectHomeVisible();
    },
  );
}
