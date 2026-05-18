---
name: architecture-rules
description: "Use when: enforcing Beacon clean architecture, provider wiring, routing, network, storage, and error-handling rules."
applyTo: "lib/**/*.dart"
---

# Architecture Rules — Beacon App

Tài liệu này là checklist bắt buộc cho AI Agent khi thêm tính năng hoặc sửa lỗi.

## 1) Quy tắc layer (bắt buộc)

Áp dụng cho mọi feature trong `lib/features/<feature>/`:

- `data`: datasource/model/repository impl
- `domain`: entity/repository abstract/usecase
- `presentation`: notifier/state/page/widget

Không đảo chiều phụ thuộc:
- `presentation` không import trực tiếp datasource.
- `domain` không phụ thuộc Flutter UI.
- `data` không trả về `Failure` trực tiếp; map exception ở repository.

## 2) Quy tắc thêm dependency (bắt buộc)

Mọi dependency phải được wiring tại:
- `lib/core/providers/providers.dart`

Không tạo singleton rời rạc hoặc khởi tạo dependency trực tiếp trong page/widget trừ object UI thuần.

## 3) Quy tắc routing

Khi thêm route mới, luôn làm đủ 3 bước:
1. Thêm constant trong `lib/core/config/app_routes.dart`
2. Đăng ký route trong `lib/core/config/app_router.dart`
3. Điều hướng bằng `context.go(AppRoutes.xxx)` hoặc `goNamed`

Route private phải có guard phù hợp (hiện tại dùng `AuthGuard`).

## 4) Quy tắc network

- Endpoint mới khai báo tại `lib/core/network/api_endpoints.dart`
- Gọi API thông qua `DioClient`
- Parse bằng `ApiHandler.handle<T>()`
- Không hardcode URL ở datasource/repository/page

## 5) Quy tắc error handling

- Repository trả về `Future<Either<Failure, T>>`
- Map `Exception -> Failure` qua extension `toFailure()` trong `lib/core/errors/failures.dart`
- Không nuốt lỗi im lặng, trừ nơi có chủ đích nghiệp vụ rõ ràng (ví dụ logout)

## 6) Quy tắc storage

- Chỉ dùng key qua `StorageKeys`
- Truy cập local storage qua abstraction (`LocalStorage`, datasource)
- Không gọi `SharedPreferences` trực tiếp trong feature layers

## 7) Quy tắc UI và feedback

- Ưu tiên tái sử dụng shared widgets trong `lib/core/widgets/`
- Thông báo người dùng qua global message:
  - `ref.read(appMessageProvider.notifier).addSuccess(...)`
  - `ref.read(appMessageProvider.notifier).addError(...)`
- Không tạo snackbar/toast ad-hoc nếu đã có global message flow

## 8) Quy tắc triển khai task

1. Xác định file nguồn sự thật cần cập nhật.
2. Thay đổi tối thiểu, không refactor lan rộng.
3. Nếu doc và code lệch nhau, ưu tiên code thực tế và ghi chú lại trong báo cáo.
4. Sau khi sửa xong, chạy tối thiểu:
   - `flutter analyze`
   - `flutter test` (nếu task ảnh hưởng test)

## 9) Definition of Done (DoD)

Task được coi là hoàn thành khi:
- Không phá vỡ flow hiện tại (auth/navigation/message)
- Không hardcode route/endpoint/storage key
- Đã cập nhật providers/router nếu có thành phần mới
- Không có lỗi analyze mới do thay đổi vừa tạo
