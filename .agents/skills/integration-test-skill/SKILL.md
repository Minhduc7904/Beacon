---
name: integration-test-skill
description: "Use when: adding or extending Flutter integration/E2E tests for Beacon with fake backend, ProviderScope overrides, and reusable test robots."
---

# Skill: Integration Test cho Beacon Flutter

## Mục tiêu

Viết integration test deterministic cho các flow nhiều màn hình của Beacon mà không gọi API/realtime/notification/storage thật, trừ khi task yêu cầu test environment riêng.

## Khi dùng

- Thêm flow `integration_test/`.
- Verify auth/session/routing guard/splash bootstrap.
- Thêm smoke regression trước release.
- Mở rộng flow forgot password, refresh token, notification, safety setting, check-in.

## Context bắt buộc

1. `.agents/copilot-instructions.md`
2. `.agents/instructions/project-context.md`
3. `.agents/instructions/architecture-rules.md`
4. `docs/integration-tests.md`
5. `lib/core/providers/providers.dart`
6. `lib/core/config/app_routes.dart`
7. `lib/core/config/app_router.dart`
8. Flow/page/controller liên quan trong `lib/features/<feature>/`

Nếu GitNexus index stale, chạy `npx gitnexus analyze` trước. Trước khi sửa production symbol, chạy impact analysis theo AGENTS.md.

## Cấu trúc chuẩn

```text
integration_test/
  <feature>/
    <flow>_test.dart
  config/
  fakes/
  helpers/
  robots/
```

Không tạo cây thư mục rỗng. Chỉ tạo file/folder khi flow cần.

## Nguyên tắc fake/mock

- Fake tại boundary: repository, datasource, realtime service, notification service, local storage.
- Không fake page/widget nội bộ nếu flow đang verify UI thật.
- Fake có state khi cần test nhiều bước liên tiếp, ví dụ register tạo account rồi login account đó.
- Test data đặt trong `integration_test/config/`.
- Nếu dùng backend test thật, phải có env riêng, seed/cleanup deterministic, và không dùng production account.

## Robot convention

- Mỗi flow nhiều bước nên có robot trong `integration_test/robots/`.
- Robot chứa các thao tác người dùng: open screen, enter form, submit, wait/assert navigation.
- Test file chỉ nên đọc như kịch bản nghiệp vụ.
- Tránh `pumpAndSettle()` trên màn có timer/animation lặp lại. Dùng `pumpUntilFound`, `pumpUntilTextFieldCount`, hoặc helper có timeout rõ ràng.
- Khi finder bằng text dễ vỡ do encoding/copy, ưu tiên helper gom candidate labels; nếu production đã có key ổn định thì ưu tiên key.

## App harness convention

- Pump `MyApp` thật trong `ProviderScope`.
- Override provider boundary trong helper, không override từng widget.
- Tắt dev UI bằng `dotenv.testLoad(fileInput: 'APP_ENV=production\n')`.
- Dùng `SharedPreferences.setMockInitialValues({})` cho mỗi test.
- Không gọi `main()` trong integration test; tự khởi tạo dependency cần thiết trong harness.

## Verify bắt buộc

1. `flutter analyze integration_test`
2. `flutter test --no-pub integration_test\<feature>\<flow>_test.dart -r expanded`
3. `flutter test` nếu thay đổi có nguy cơ ảnh hưởng unit/widget test hiện có
4. `gitnexus_detect_changes(scope: "all")` trước commit

## Done khi

- Flow test đọc được như hành vi người dùng.
- Fake backend không gọi network/realtime/notification thật.
- Test có data/config riêng, không hard-code rải rác.
- Docs hoặc skill được cập nhật nếu thêm convention mới.
