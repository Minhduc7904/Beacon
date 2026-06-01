# Báo cáo refactor splash/startup flow

## Mục tiêu

Refactor splash/startup flow để Android native splash là splash branding thật, còn Flutter `SplashPage` chỉ làm startup gate: resolve onboarding/login/home nhanh, không delay cố định và không đọc trực tiếp datasource.

## File đã thêm/sửa

- `android/app/src/main/res/values/colors.xml`
- `android/app/src/main/res/values/styles.xml`
- `android/app/src/main/res/values-night/styles.xml`
- `android/app/src/main/res/values-v31/styles.xml`
- `android/app/src/main/res/values-night-v31/styles.xml`
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/drawable-v21/launch_background.xml`
- `lib/core/providers/providers.dart`
- `lib/core/widgets/auth_guard.dart`
- `lib/features/auth/domain/repositories/auth_repository.dart`
- `lib/features/auth/domain/usecase/has_local_auth_session_usecase.dart`
- `lib/features/auth/data/repositories/auth_repository_impl.dart`
- `lib/features/splash/domain/entities/startup_destination.dart`
- `lib/features/splash/domain/usecase/resolve_startup_destination_usecase.dart`
- `lib/features/splash/presentation/pages/splash_page.dart`
- `test/features/auth/domain/usecase/has_local_auth_session_usecase_test.dart`
- `test/features/auth/data/repositories/auth_repository_impl_test.dart`
- `test/features/splash/domain/usecase/resolve_startup_destination_usecase_test.dart`

## Thay đổi chính

- Android native splash dùng `@color/beacon_primary` (`#66D0BC`) cho launch background và `NormalTheme` để giảm flash trắng/đen trước Flutter first frame.
- Đã thêm cấu hình `values-v31` và `values-night-v31` cho Android 12+ với `windowSplashScreenBackground`, `windowSplashScreenAnimatedIcon` và `postSplashScreenTheme`.
- `SplashPage` được giữ lại làm startup gate vì app vẫn cần quyết định async onboarding/login/home. Page không render logo lớn và không còn `Future.delayed`.
- Startup destination được resolve trong `ResolveStartupDestinationUseCase`, trả về `StartupDestination.onboarding/login/home`; mapping sang `AppRoutes` nằm ở `SplashPage`.
- `SplashPage` và `AuthGuard` không đọc `AuthLocalDatasource` trực tiếp; session check đi qua `HasLocalAuthSessionUseCase` và `AuthRepository.hasLocalSession()`.
- Local database/UserProfileCache không tham gia quyết định route. Route authenticated chỉ dựa trên access token + refresh token; cache profile vẫn thuộc behavior hiện có của `AuthRepository.getMe()` và logout vẫn clear cache scope liên quan.
- SignalR connect, FCM token sync, profile/home preload chạy non-blocking bằng `unawaited`; navigation vào `/home` không chờ các tác vụ này.
- `AndroidManifest.xml` đã được kiểm tra, đang trỏ `LaunchTheme` và `NormalTheme` đúng nên không cần chỉnh.

## Verify

Không chạy `flutter` hoặc `dart` theo yêu cầu task. Đã kiểm tra tĩnh bằng `rg` để xác nhận `SplashPage` không còn `Future.delayed`, `pushReplacement`, hoặc gọi datasource/cache trực tiếp. Các XML Android mới/sửa đã parse hợp lệ bằng PowerShell `[xml]`.

Lệnh đề xuất chạy thủ công:

```powershell
flutter analyze
flutter test test/features/splash/domain/usecase/resolve_startup_destination_usecase_test.dart test/features/auth/domain/usecase/has_local_auth_session_usecase_test.dart test/features/auth/data/repositories/auth_repository_impl_test.dart
flutter test
```

Manual verify Android:

- Clear app data -> mở app -> onboarding.
- Complete onboarding, chưa login -> restart app -> login.
- Login thành công -> restart app -> home.
- Logout -> restart app -> login, không quay lại onboarding.
- Có token nhưng xóa/missing `UserProfileCache` -> restart app -> home, không crash.
- Còn `UserProfileCache` nhưng đã clear token/logout -> restart app -> login.
- Kiểm tra native splash trên Android 12+ để xác nhận nền/logo đồng bộ và không flash trắng/đen dễ thấy.

## Ngoài scope

- iOS chưa nằm trong scope task này và không được chỉnh.
- Không mở rộng local DB cho feed/posts/safety trong task splash.
