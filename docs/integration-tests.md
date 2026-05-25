# Integration Test Guide

## Mục tiêu

Integration test của Beacon dùng để verify các flow P0 nhiều màn hình: auth/session, routing guard, splash bootstrap, notification entrypoint, safety setting và các regression trước release.

Flow mẫu hiện có:

```text
Splash -> Onboarding -> Register -> Login -> Splash bootstrap -> Home
```

Lưu ý thực tế: production repository hiện lưu token ngay sau `register`. Flow mẫu đặt `autoLoginAfterRegister: false` trong fake backend để bước login được exercise riêng theo yêu cầu E2E. Nếu product muốn verify auto-login sau register, bật `autoLoginAfterRegister: true` trong test harness và bỏ bước login.

## Package cần cài

`pubspec.yaml` đã thêm:

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

Lệnh cài đặt:

```powershell
flutter pub get
```

Trên Windows, nếu gặp lỗi `Building with plugins requires symlink support`, bật Developer Mode:

```powershell
start ms-settings:developers
```

Sau khi bật Developer Mode, chạy lại `flutter pub get`.

## Cấu trúc thư mục

```text
integration_test/
  auth/
    register_login_flow_test.dart
  config/
    register_login_test_user.dart
  fakes/
    fake_auth_backend.dart
    fake_feature_repositories.dart
    fake_realtime_services.dart
  helpers/
    integration_test_app.dart
  robots/
    auth_flow_robot.dart
```

Quy ước mở rộng:

- `auth/`: flow auth/session như register, login, logout, forgot password, refresh token.
- `config/`: test data và config dùng chung, không hard-code rải rác trong test.
- `fakes/`: fake repository/service ở boundary API, storage, realtime, notification.
- `helpers/`: app harness và ProviderScope overrides.
- `robots/`: thao tác UI theo domain language, tránh lặp lại finder/tap/enter text trong từng test.

## Cách fake API

Flow mẫu không gọi API thật. `BeaconIntegrationTestApp` override các provider boundary:

- `authRepositoryProvider`
- `authLocalDatasourceProvider`
- `checkinRepositoryProvider`
- `safetyRepositoryProvider`
- `postsRepositoryProvider`
- `friendsRepositoryProvider`
- `messageGroupsRepositoryProvider`
- realtime service providers
- `pushNotificationServiceProvider`

`FakeAuthRepository` là fake có state:

- `checkEmailAvailable` và `checkPhoneAvailable` trả về availability từ account đã tạo trong memory.
- `register` tạo account trong memory.
- `login` verify account đã tạo và lưu token vào `InMemoryAuthLocalDatasource`.
- `getMe` trả về profile của account đang login.

Với flow cần backend test thật, tạo environment riêng thay vì dùng production API. Yêu cầu tối thiểu:

- data seed deterministic;
- user test có thể tạo/xóa lặp lại;
- endpoint/base URL cấu hình qua env;
- không dùng account production;
- clean-up sau test nếu backend có state thật.

## Cách chạy

Chạy flow mới:

```powershell
flutter test --no-pub integration_test\auth\register_login_flow_test.dart -r expanded
```

Chạy toàn bộ integration test:

```powershell
flutter test integration_test -r expanded
```

Nếu cần chạy trên device/emulator cụ thể:

```powershell
flutter devices
flutter test integration_test\auth\register_login_flow_test.dart -d <device-id> -r expanded
```

## Cách flow hoạt động

1. Test pump `MyApp` thật với `ProviderScope` overrides.
2. Splash thấy onboarding chưa complete và điều hướng sang onboarding.
3. Robot bấm đăng ký, nhập email, phone, password, name, username.
4. Fake backend tạo account nhưng không lưu token, để app đi qua màn login.
5. Robot login bằng account vừa tạo.
6. Fake backend lưu token vào fake local datasource.
7. Login success quay về Splash, Splash bootstrap session và điều hướng Home.
8. Test assert `HomePage` hiển thị và fake backend có đúng 1 lần register, 1 lần login.

## Checklist khi thêm flow mới

- Dùng `integration_test/<feature>/<flow>_test.dart`.
- Đưa dữ liệu test vào `integration_test/config/`.
- Thêm fake ở repository/service boundary, không mock widget nội bộ.
- Thêm robot nếu flow có nhiều bước UI.
- Không dùng `pumpAndSettle()` trên màn có timer/animation lặp lại; dùng helper `pumpUntilFound`.
- Không gọi API, storage, notification, realtime thật trừ khi flow đang test environment riêng.
- Đặt tên test theo behavior người dùng.
- Chạy `flutter analyze integration_test`.
- Chạy file integration test liên quan.
- Chạy `flutter test` để đảm bảo unit test hiện có không bị vỡ.
