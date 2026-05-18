# Beacon App — Copilot Instructions (Repo-level)

Mục tiêu của tài liệu này là giúp AI Agent tạo thay đổi **đúng kiến trúc hiện tại**, giảm lệch chuẩn khi thêm tính năng hoặc sửa lỗi.

## 1) Bối cảnh kỹ thuật của dự án
- Framework: Flutter (Dart SDK `>=3.10.0 <4.0.0` theo `pubspec.yaml`)
- State management + DI: Riverpod (`flutter_riverpod`)
- Routing: GoRouter (`go_router`)
- Network: Dio (`dio`)
- Local storage: SharedPreferences (`shared_preferences`)
- Functional error handling: `Either<Failure, T>` từ `dartz`

## 2) Quy tắc ưu tiên khi viết code
1. Luôn giữ flow theo Clean Architecture trong `features/*`: `data -> domain -> presentation`.
2. Không hardcode route string, endpoint, storage key, asset path.
3. Mọi dependency mới phải đi qua `lib/core/providers/providers.dart`.
4. Khi hiển thị phản hồi người dùng, ưu tiên dùng global message (`appMessageProvider`) thay vì tạo snackbar rời rạc.
5. Ưu tiên thay đổi nhỏ, đúng phạm vi yêu cầu; không refactor lan rộng nếu không được yêu cầu.

## 3) Các nguồn sự thật (source of truth)
- Route constants: `lib/core/config/app_routes.dart`
- Router graph: `lib/core/config/app_router.dart`
- DI graph: `lib/core/providers/providers.dart`
- API endpoints: `lib/core/network/api_endpoints.dart`
- Storage keys: `lib/core/constants/storage_keys.dart`
- Shared UI primitives: `lib/core/widgets/`

## 4) Quy tắc triển khai theo layer

### Data layer
- Tạo/đổi API call tại `features/<feature>/data/datasources/*_remote_datasource_impl.dart`.
- Parse response bằng `ApiHandler.handle<T>()`.
- Không ném `Failure` từ data layer; chỉ ném `Exception` phù hợp.

### Domain layer
- UseCase trả về `Future<Either<Failure, T>>`.
- Validation nghiệp vụ đặt trong usecase (ví dụ như `login_usecase.dart`).

### Presentation layer
- State quản lý bằng `StateNotifier` + state class rõ ràng (`Loading/Success/Error/...`).
- Side effects UI (toast message) đi qua `AppMessageNotifier`.

## 5) Quy tắc routing
- Thêm route mới theo thứ tự:
	1) khai báo trong `app_routes.dart`
	2) đăng ký trong `app_router.dart`
	3) điều hướng bằng `context.go(AppRoutes.xxx)` hoặc `goNamed/pushNamed` với `AppRoutes.xxxName`.
- Route cần xác thực phải có guard phù hợp (hiện có `AuthGuard`).

## 6) Quy tắc network + error handling
- Trước call API trong repository, kiểm tra mạng qua `NetworkInfo` nếu nghiệp vụ yêu cầu.
- Map lỗi qua extension `ExceptionToFailure` trong `lib/core/errors/failures.dart`.
- Không nuốt lỗi im lặng, trừ các trường hợp đã có chủ đích nghiệp vụ (ví dụ logout API fail vẫn clear token local).

## 7) Quy tắc storage
- Chỉ thao tác key thông qua `StorageKeys`.
- Không truy cập trực tiếp `SharedPreferences` trong feature; đi qua abstraction `LocalStorage` / datasource.

## 8) Quy tắc UI
- Ưu tiên tái sử dụng shared widgets trong `lib/core/widgets/`.
- Không thêm màu/spacing tùy tiện nếu đã có theme primitive.
- Nếu cần thông báo toàn cục, dùng `appMessageProvider.notifier.addSuccess/addError/...`.
- Với task UI mới hoặc đổi design, ưu tiên đọc `.agents/instructions/ui-design.instructions.md` và dùng `ui-design-skill`.

## 9) Kiểm tra trước khi kết thúc task
Sau khi sửa code, ưu tiên chạy:
1. `flutter analyze`
2. `flutter test` (nếu thay đổi ảnh hưởng test)
3. kiểm tra luồng chính liên quan trên app (login/logout/navigation hoặc flow được chỉnh sửa)

## 10) Quy tắc commit/PR
- Theo Conventional Commits (tham chiếu `docs/git_workflow.md`): `feat|fix|refactor|docs|chore|test|perf`.
- Scope bám module/layer (`auth`, `network`, `storage`, `router`, `providers`, `ui`, ...).

## 11) Không được làm
- Không đổi cấu trúc thư mục lớn nếu không có yêu cầu rõ ràng.
- Không tự ý thêm package mới nếu không cần thiết.
- Không sửa các phần không liên quan yêu cầu.

