Bạn là senior Flutter engineer trong repo Beacon tại `d:\CODE\Beacon`.

Nhiệm vụ: review và refactor toàn bộ splash/startup flow theo best practice mobile app, đúng Clean Architecture hiện tại của Beacon. Trong task này chỉ triển khai native splash cho Android trước, iOS chưa làm.

Bối cảnh dự án:
- Flutter + Riverpod + GoRouter + Dio + SharedPreferences/SecureStorage.
- Source of truth:
  - Routes: `lib/core/config/app_routes.dart`
  - Router: `lib/core/config/app_router.dart`
  - DI: `lib/core/providers/providers.dart`
  - Assets: `lib/core/constants/app_images.dart`
  - Theme colors: `lib/core/theme/color/app_colors.dart`
- Không hardcode route string, storage key, asset path.
- Dependency mới phải wiring qua `providers.dart`.
- Presentation không được đọc trực tiếp datasource/data layer nếu có thể tránh.

Vấn đề hiện tại:
- `SplashPage` đang vừa là branding screen vừa làm startup routing.
- Có `Future.delayed(Duration(seconds: 2))`, không tốt cho UX.
- `SplashPage` đọc trực tiếp `authLocalDatasourceProvider`, lệch Clean Architecture.
- Nếu đã hoàn tất onboarding nhưng chưa login, app đang đi `/onboarding` thay vì `/login`.
- Android native splash cần được kiểm tra lại để đồng bộ với branding và tránh flash trắng/đen.
- Android 12+ chưa thấy cấu hình splash riêng.
- SignalR/FCM sync không nên block startup navigation.
- iOS hiện chưa nằm trong scope task này, không chỉnh file iOS.

Mục tiêu best practice:
1. Android native splash là splash thật của OS:
   - Hiển thị ngay khi app mở.
   - Nền và logo khớp branding Beacon.
   - Không chạy logic ở native splash.
   - Không có flash trắng/đen giữa native splash và Flutter first frame.
2. Flutter route đầu tiên chỉ là startup gate:
   - Không dùng để giữ logo 2 giây.
   - Không delay cố định.
   - Chỉ resolve destination rồi điều hướng.
3. Flow startup đúng:
   - First install/chưa complete onboarding -> `/onboarding`
   - Đã complete onboarding nhưng chưa có local session -> `/login`
   - Có access token + refresh token -> `/home`
4. Authenticated background startup:
   - SignalR connect và FCM token sync chạy non-blocking.
   - Không block điều hướng vào home.
5. Giữ thay đổi nhỏ, đúng phạm vi. Không refactor lan rộng nếu không cần.

Phạm vi platform:
- Chỉ triển khai và verify native splash cho Android trước.
- Chưa làm iOS trong task này.
- Không chỉnh các file iOS, trừ khi cần đọc để đối chiếu hiện trạng.
- Có thể ghi chú iOS đang lệch/chưa hoàn thiện trong báo cáo cuối, nhưng không sửa.

Yêu cầu triển khai:

A. Native splash Android-only
- Chỉ chỉnh native splash Android trong task này.
- Kiểm tra và cập nhật các file:
  - `android/app/src/main/res/values/styles.xml`
  - `android/app/src/main/res/values-night/styles.xml`
  - `android/app/src/main/res/drawable/launch_background.xml`
  - `android/app/src/main/res/drawable-v21/launch_background.xml`
  - `android/app/src/main/AndroidManifest.xml`
  - thêm `values-v31/styles.xml` hoặc resource Android 12+ nếu cần.
- Đồng bộ Android native splash background với Beacon primary `#66D0BC`.
- Android `NormalTheme` background nên tránh trắng/đen flash trước Flutter first frame.
- Android 12+ cần có cấu hình splash phù hợp nếu project target/Flutter embedding yêu cầu.
- Nếu thêm `flutter_native_splash` là lựa chọn hợp lý nhất, chỉ generate/update Android output. Không generate iOS trong task này.
- Không chỉnh `ios/Runner/...` trong task này.

B. Flutter startup gate
- Không xóa startup gate nếu chưa có cơ chế thay thế tương đương. Native splash không thể tự quyết định onboarding/login/home.
- Có thể giữ `SplashPage`, nhưng refactor nó thành startup gate tối giản.
- Xóa `Future.delayed(const Duration(seconds: 2))`.
- Không render logo lớn như một branding splash nếu native splash đã xử lý branding. Có thể render `Scaffold(backgroundColor: AppColors.primary)` hoặc loading tối giản trong thời gian rất ngắn.
- `SplashPage` không đọc trực tiếp `authLocalDatasourceProvider`.

C. Clean Architecture
- Tạo model/usecase rõ ràng cho startup destination, ví dụ:
  - `StartupDestination { onboarding, login, home }`
  - `ResolveStartupDestinationUseCase`
- Usecase phải nằm đúng layer, ví dụ trong `features/splash/domain/usecase/`.
- Usecase không phụ thuộc route constants; route mapping nằm ở presentation/router layer.
- Để check session, không để presentation gọi datasource. Hãy thêm method/usecase phù hợp ở auth domain/repository nếu cần, ví dụ:
  - `AuthRepository.hasLocalSession()`
  - `HasLocalAuthSessionUseCase`
- Repository impl có thể dùng `AuthLocalDatasource` nội bộ để đọc access/refresh token.
- Wire tất cả dependency mới trong `lib/core/providers/providers.dart`.

D. Routing
- Giữ `initialLocation: AppRoutes.splash` nếu vẫn dùng startup gate.
- Sau resolve:
  - `StartupDestination.onboarding` -> `context.go(AppRoutes.onboarding)`
  - `StartupDestination.login` -> `context.go(AppRoutes.login)`
  - `StartupDestination.home` -> `context.go(AppRoutes.home)`
- Dùng `context.go`, không dùng `pushReplacement` cho startup routing.
- Nếu quyết định xóa `SplashPage`, phải thay bằng cơ chế startup route an toàn:
  - pre-resolve initial route trước khi build router, hoặc
  - router redirect có trạng thái bootstrap rõ ràng.
  - Sau đó xóa route/file/docs liên quan sạch sẽ.
- Không xóa splash route chỉ vì native splash tồn tại nếu app vẫn cần async startup decision.

E. SignalR và FCM
- Không chờ SignalR/FCM trước khi vào `/home`.
- Nếu user authenticated, chạy:
  - `signalRService.connect()`
  - `pushNotificationService.syncCurrentDeviceTokenIfAuthorized()`
  dưới dạng `unawaited`.
- Ưu tiên đặt logic này ở một service/usecase/provider phù hợp như authenticated app bootstrap, hoặc tối thiểu giữ non-blocking và không làm page startup phình to.

Acceptance criteria:
- Fresh install -> Android native splash -> onboarding.
- Đã complete onboarding + chưa login -> login.
- Có access token + refresh token -> home.
- Không có delay cố định 2 giây.
- `SplashPage` không import/gọi data datasource trực tiếp.
- Không có route string hardcode.
- Android native splash đồng bộ màu/logo, gồm Android 12+ nếu áp dụng.
- Không có flash trắng/đen dễ thấy giữa Android native splash và Flutter first frame.
- SignalR/FCM không block navigation.
- Không chỉnh iOS trong task này.
- Không refactor unrelated files.

Verification:
1. Chạy `flutter analyze`.
2. Chạy `flutter test` nếu thêm/chỉnh usecase/repository logic có test hoặc có thể test.
3. Manual verify Android:
   - clear app data -> mở app -> onboarding.
   - complete onboarding, chưa login -> restart app -> login.
   - login thành công -> restart app -> home.
   - logout -> restart app -> login, không quay lại onboarding.
4. Kiểm tra Android native splash trên emulator/device, ưu tiên cả Android 12+.
5. Báo cáo rõ:
   - Đã giữ hay xóa Flutter `SplashPage`, vì sao.
   - Files đã đổi.
   - iOS chưa nằm trong scope.
   - Lệnh verify đã chạy và kết quả.