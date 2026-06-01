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
- Local database hiện đã có trong dự án:
  - Isar local database.
  - `UserProfileCache` cho auth/profile cache.
  - `UserProfileLocalDatasource` / mapper cache đã được wiring qua DI.
  - Auth repository hiện có thể cache profile sau `getMe`/`updateMe` và đọc profile cache khi phù hợp.
- Token/session vẫn dùng SecureStorage/AuthLocalDatasource; không chuyển access token/refresh token sang Isar.
- Onboarding completion flag vẫn là state riêng của onboarding/local preferences; không suy luận onboarding hoàn tất chỉ từ việc có `UserProfileCache`.


Vấn đề hiện tại:
- `SplashPage` đang vừa là branding screen vừa làm startup routing.
- Có `Future.delayed(Duration(seconds: 2))`, không tốt cho UX.
- `SplashPage` đọc trực tiếp `authLocalDatasourceProvider`, lệch Clean Architecture.
- Nếu đã hoàn tất onboarding nhưng chưa login, app đang đi `/onboarding` thay vì `/login`.
- Android native splash cần được kiểm tra lại để đồng bộ với branding và tránh flash trắng/đen.
- Android 12+ chưa thấy cấu hình splash riêng.
- SignalR/FCM sync không nên block startup navigation.
- iOS hiện chưa nằm trong scope task này, không chỉnh file iOS.
- Sau khi có local database, startup flow cần xác định rõ vai trò của cache:
  - Token/session là nguồn quyết định authenticated route.
  - Onboarding local flag là nguồn quyết định đã qua onboarding hay chưa.
  - `UserProfileCache` chỉ dùng để hydrate UI/home/auth state nhanh sau khi vào `/home`, không dùng một mình để cho user vào `/home`.

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
6. Local database chỉ hỗ trợ bootstrap sau khi đã xác định authenticated:
   - Splash/startup gate có thể đọc trạng thái tối thiểu từ domain/usecase, nhưng không đọc trực tiếp Isar/datasource.
   - Không để local profile cache quyết định login state nếu token không hợp lệ/không tồn tại.
   - Khi authenticated, có thể hydrate `MeProfile`/auth profile state từ `UserProfileCache` sớm để giảm blank UI, rồi refresh remote non-blocking nếu kiến trúc hiện tại cho phép.
   - Local DB lỗi/corrupt/missing cache không được làm kẹt app ở splash; fallback an toàn là đi theo token/onboarding decision và log lỗi ở repository/service.

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


F. Local database / UserProfileCache
- Rà soát các file local DB hiện có trước khi sửa startup flow:
  - `lib/core/database/isar_collections.dart`
  - `lib/core/providers/providers.dart`
  - `lib/features/auth/data/local_models/user_profile_cache.dart`
  - `lib/features/auth/data/mappers/user_profile_cache_mapper.dart`
  - `lib/features/auth/data/datasources/user_profile_local_datasource.dart`
  - `lib/features/auth/data/datasources/user_profile_local_datasource_impl.dart`
  - `lib/features/auth/data/repositories/auth_repository_impl.dart`
  - các test liên quan nếu có.
- Không để `SplashPage` hoặc presentation layer gọi trực tiếp `UserProfileLocalDatasource`, `Isar`, `AuthLocalDatasource`, `SecureStorage`, hoặc data model cache.
- `ResolveStartupDestinationUseCase` chỉ nên quyết định route dựa trên domain-level abstraction:
  - onboarding completed hay chưa;
  - có local auth session hợp lệ tối thiểu hay chưa.
- Bổ sung abstraction/usecase nếu cần:
  - `HasLocalAuthSessionUseCase` hoặc method domain `AuthRepository.hasLocalSession()` để kiểm tra access token + refresh token.
  - `GetCachedMeUseCase` / `GetCachedUserProfileUseCase` chỉ nếu cần hydrate state sau khi đã vào authenticated area.
  - `AuthenticatedAppBootstrapUseCase` nếu muốn gom các tác vụ sau khi xác định user đã authenticated.
- Không dùng `UserProfileCache` như điều kiện login:
  - Có profile cache nhưng thiếu token -> đi `/login`.
  - Có token nhưng thiếu profile cache -> vẫn có thể đi `/home`, sau đó hydrate remote/profile theo flow hiện tại.
  - Có token + cache profile -> đi `/home`, có thể set cached profile vào state trước để UI ít trống.
  - Cache lỗi/corrupt -> không crash, không kẹt splash; log/debug và tiếp tục theo token/onboarding.
- Remote refresh profile không được block startup navigation:
  - Sau khi vào `/home`, có thể trigger `getMe`/profile refresh non-blocking nếu repository/notifier hiện tại hỗ trợ.
  - Nếu remote profile khác cache, repository phải cập nhật `UserProfileCache` theo behavior cache hiện có.
- Logout phải clear đúng session và cache liên quan:
  - clear access token + refresh token;
  - clear cached current user profile hoặc ít nhất clear cache scope dành cho current authenticated user, tùy thiết kế hiện tại;
  - restart app sau logout phải vào `/login`, không vào `/home` vì còn cache.
- Không mở rộng local DB ngoài phạm vi startup/auth profile trong task này. Không cache feed/posts/safety trong task splash nếu chưa có plan riêng.

E. SignalR và FCM
- Không chờ SignalR/FCM trước khi vào `/home`.
- Nếu user authenticated, chạy:
  - `signalRService.connect()`
  - `pushNotificationService.syncCurrentDeviceTokenIfAuthorized()`
  dưới dạng `unawaited`.
- Ưu tiên đặt logic này ở một service/usecase/provider phù hợp như authenticated app bootstrap, hoặc tối thiểu giữ non-blocking và không làm page startup phình to.

G. Báo cáo sau khi triển khai

- Sau khi hoàn thành code, tạo một file markdown báo cáo ngắn gọn bằng tiếng Việt có dấu.
- File báo cáo nên đặt trong `docs/` hoặc vị trí phù hợp theo convention hiện tại của project.
- Tên file gợi ý:
  - `docs/splash_startup_refactor_report.md`
- Nội dung báo cáo cần có:
  - Tóm tắt mục tiêu task.
  - Danh sách file đã thêm/sửa.
  - Giải thích ngắn gọn thay đổi chính:
    - Android native splash đã chỉnh gì.
    - Flutter `SplashPage` được giữ/xóa/refactor như thế nào và vì sao.
    - Startup destination được resolve ở đâu.
    - Local database/cache có được dùng trong startup flow không, dùng như thế nào.
    - SignalR/FCM có còn block navigation không.
  - Các lệnh verify đề xuất cho người dùng chạy thủ công.
  - Các phần chưa làm hoặc nằm ngoài scope, ví dụ iOS.

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
- Local database không làm sai routing:
  - Có `UserProfileCache` nhưng không có access/refresh token -> login.
  - Có token nhưng không có `UserProfileCache` -> home.
  - Cache lỗi/missing không làm kẹt splash.
- `SplashPage` không import/gọi `UserProfileLocalDatasource`, Isar collection/model, `AuthLocalDatasource`, hoặc storage trực tiếp.
- Nếu authenticated và có cache profile, app có thể hydrate profile state từ cache trước, nhưng refresh/network/SignalR/FCM vẫn non-blocking.
- Logout clear session/cache liên quan để restart không quay lại home do cache cũ.

Verification:
1. Không chạy các lệnh flutter, dart khi thực hiện code vì sẽ bị stuck, nếu thực sự cần thiết thì liệt kê ra các lệnh để tôi chạy thủ công
2. Manual verify Android:
   - clear app data -> mở app -> onboarding.
   - complete onboarding, chưa login -> restart app -> login.
   - login thành công -> restart app -> home.
   - logout -> restart app -> login, không quay lại onboarding.
   - có token nhưng xóa/missing `UserProfileCache` -> restart app -> home, không crash.
   - còn `UserProfileCache` nhưng đã clear token/logout -> restart app -> login.
   - cache profile cũ, remote `getMe` trả profile mới -> cache được cập nhật theo behavior repository hiện có.
3. Kiểm tra Android native splash trên emulator/device, ưu tiên cả Android 12+.
4. Báo cáo rõ:
   - Đã giữ hay xóa Flutter `SplashPage`, vì sao.
   - Files đã đổi.
   - iOS chưa nằm trong scope.
   - Lệnh verify đã chạy và kết quả.
5. Test cần bổ sung nếu sửa domain/repository/local DB:
   - Unit test `ResolveStartupDestinationUseCase`:
     - onboarding chưa hoàn tất -> `StartupDestination.onboarding`;
     - onboarding hoàn tất + không có local session -> `StartupDestination.login`;
     - onboarding hoàn tất + có access token + refresh token -> `StartupDestination.home`;
     - lỗi đọc cache profile không ảnh hưởng quyết định route.
   - Unit test `HasLocalAuthSessionUseCase`/`AuthRepository.hasLocalSession()`:
     - thiếu access token -> false;
     - thiếu refresh token -> false;
     - đủ access + refresh -> true;
     - storage exception -> false hoặc Failure theo convention hiện tại, nhưng không crash presentation.
   - Nếu thêm cached profile bootstrap:
     - cache hit trả profile domain đúng;
     - cache miss trả null/none;
     - cache corrupt/mapper lỗi được xử lý an toàn.
