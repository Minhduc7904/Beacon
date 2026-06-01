import 'package:beacon_app/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../config/register_login_test_user.dart';
import '../helpers/integration_test_app.dart';
import '../robots/auth_flow_robot.dart';
import '../robots/post_flow_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('logs in, captures a photo, adds a caption, and creates a post', (
    tester,
  ) async {
    final app = await pumpBeaconIntegrationApp(tester);
    final authRobot = AuthFlowRobot(tester);
    final postRobot = PostFlowRobot(tester);
    const user = RegisterLoginTestUser.seededLoginUser;
    final caption = 'N2N post caption ${DateTime.now().millisecondsSinceEpoch}';

    await authRobot.openLoginFromOnboarding();
    await authRobot.login(user);
    await authRobot.expectHomeVisible();

    await postRobot.openCameraFromHome();
    await postRobot.capturePhoto();
    await postRobot.enterCaption(caption);
    await postRobot.submitPost();

    await expectBackendPostWithCaption(app, caption);
  });
}

Future<void> expectBackendPostWithCaption(
  BeaconIntegrationTestApp app,
  String caption,
) async {
  final token = await app.authLocalDatasource.getAccessToken();
  expect(token, isNotNull);
  expect(token, isNotEmpty);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      headers: {'Authorization': 'Bearer $token'},
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (_) => true,
    ),
  );

  final response = await dio.get<dynamic>(
    '/posts/me',
    queryParameters: {'limit': 20},
  );

  expect(response.statusCode, 200);
  final body = response.data as Map<String, dynamic>;
  final data = body['data'] as Map<String, dynamic>;
  final items = data['items'] as List<dynamic>;

  final hasPost = items.whereType<Map<String, dynamic>>().any(
    (post) => post['caption'] == caption,
  );

  expect(hasPost, isTrue);
}
