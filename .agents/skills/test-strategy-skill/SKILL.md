---
name: test-strategy-skill
description: "Use when: selecting Flutter test levels, planning unit/widget/integration coverage, and creating verification checklists for risky or cross-layer changes."
---

# Skill: Chiến lược test Flutter cho Beacon

## Mục tiêu

Tạo chiến lược test thực dụng cho Beacon, ưu tiên kiểm chứng logic quan trọng bằng unit test trước, sau đó bổ sung widget test và integration/E2E test cho các luồng người dùng có rủi ro cao.

## Khi dùng

- Lập kế hoạch test cho feature hoặc toàn dự án.
- Thêm/sửa logic nghiệp vụ, validation, mapping, repository, datasource, storage, auth, routing, network, hoặc state management.
- Sửa bug quan trọng cần regression test.
- Trước khi refactor vùng code có nhiều phụ thuộc.

## Nguyên tắc

- Không test máy móc tất cả mọi thứ. Chọn test theo rủi ro, độ quan trọng nghiệp vụ, tần suất thay đổi, và độ khó phát hiện lỗi thủ công.
- Unit test là lớp ưu tiên đầu tiên cho logic thuần, use case, repository/service, state notifier, model mapping, validator, formatter, helper, error mapping.
- Không unit test UI thuần như màu sắc, padding, animation, layout tĩnh nếu không có logic hoặc state branching.
- Unit test không gọi API thật, storage thật, clock thật, hoặc global state thật nếu có thể inject fake/mock.
- Test phải deterministic: cùng input phải cho cùng output, không phụ thuộc mạng, thứ tự test, thời gian hiện tại, hoặc dữ liệu bên ngoài.
- Giữ thay đổi production code nhỏ nhất cần thiết để tăng testability, ví dụ inject dependency, tách logic khỏi widget, hoặc thêm abstraction cho side effect.

## Phân biệt cấp độ test

### Unit test

Dùng cho:
- Entity/model JSON mapping, equality/value behavior nếu có.
- Validator, formatter, helper, business rule thuần.
- Use case trả `Either<Failure, T>`.
- Repository/service/datasource với mock/fake dependency.
- Riverpod `StateNotifier`/controller/provider logic bằng `ProviderContainer`.
- Error handling, exception-to-failure mapping, API response handler, storage wrapper.

Không dùng cho:
- Kiểm tra màu sắc, padding, icon, animation, layout tĩnh.
- Luồng cần render nhiều màn hình hoặc platform integration.
- Gọi network/storage thật.

### Widget test

Dùng sau unit test khi:
- Widget có branching theo state, form validation, enable/disable action, empty/loading/error/success rendering.
- Cần verify tương tác người dùng ở phạm vi một màn hình hoặc component.
- Cần verify Riverpod provider override trong UI.

Không dùng để snapshot layout chi tiết hoặc kiểm tra style thuần nếu không có rủi ro nghiệp vụ.

### Integration/E2E test

Dùng cho:
- Luồng P0 nhiều màn hình như login/logout/session restore/navigation guard.
- Luồng liên quan check-in, safety, alert, reminder, deadline nếu có logic cross-layer.
- Regression smoke test trước release.

Integration/E2E có thể dùng fake backend hoặc môi trường test ổn định; không thay thế unit test cho business logic.

## Ưu tiên test

- P0: auth/session, token/storage, network error mapping, repository/use case quan trọng, state notifier điều khiển luồng chính, business rule có hậu quả người dùng rõ ràng.
- P1: model mapping cho API response hay đổi, validators/helpers/formatters dùng nhiều nơi, provider wiring có logic, repository/service ít rủi ro hơn.
- P2: logic phụ trợ hiếm thay đổi, mapping đơn giản ít nhánh, widget state nhẹ, regression cho bug cũ không thuộc luồng chính.

## Mock, fake, fixture

- Dùng mock khi cần verify interaction, simulate exception, hoặc dependency có nhiều nhánh khó dựng state.
- Dùng fake/in-memory implementation khi behavior đơn giản và test cần đọc dễ hơn mock, ví dụ fake local storage, fake clock, fake network info.
- Dùng fixture JSON cho API payload phức tạp, nested, hoặc cần tái sử dụng. Fixture phải đặt trong `test/fixtures/` và parse bằng helper rõ ràng.
- Không mock class đang được test. Mock dependency ở boundary: datasource, client, storage, network info, repository, use case.
- Không verify quá nhiều implementation detail. Ưu tiên assert output/state/failure; chỉ verify call khi đó là behavior quan trọng.

## Cấu trúc test đề xuất

Điều chỉnh theo cấu trúc thật của project:

```text
test/
  core/
    errors/
    network/
    storage/
    utils/
  features/
    <feature>/
      data/
        datasources/
        models/
        repositories/
      domain/
        usecases/
      presentation/
        providers/
        notifiers/
  fixtures/
  helpers/
  mocks/
```

Quy ước:
- File test kết thúc bằng `_test.dart`.
- Mirror source path khi có thể, ví dụ `lib/features/auth/domain/usecases/login_usecase.dart` -> `test/features/auth/domain/usecases/login_usecase_test.dart`.
- Test helper/fake dùng chung đặt trong `test/helpers/`, `test/mocks/`, hoặc `test/fixtures/`.

## Convention viết test

- Dùng cấu trúc Arrange - Act - Assert, có thể tách bằng comment ngắn khi test dài.
- `group()` theo class/function hoặc method lớn.
- Ưu tiên tiếng Việt có dấu cho tên `test()`, mô tả, comment và dữ liệu giả khi có thể; giữ nguyên tên class/function, thuật ngữ kỹ thuật, enum, error code, API contract và expected string đến từ production behavior.
- Tên `test()` mô tả behavior: `trả về AuthUser khi thông tin đăng nhập hợp lệ`, `phát state lỗi khi repository trả về Failure`.
- Test cả happy path, error path, boundary input, null/empty/malformed response, unauthorized/network/server failure nếu liên quan.
- Với logic deadline/countdown/time-based, inject clock hoặc fake time; không phụ thuộc `DateTime.now()` thật trong unit test.
- Với Riverpod, tạo `ProviderContainer` riêng cho mỗi test và dispose sau test.
- Với async, await đầy đủ và tránh timer thật nếu có thể dùng fake time.

## Kịch bản tối thiểu cho target rủi ro

1. Happy path.
2. Error path: mất mạng, lỗi server, unauthorized, validation fail.
3. Boundary input: null/empty, min/max, malformed data, duplicate action.
4. Regression lân cận cho bug hoặc logic vừa chỉnh.
5. State transition: initial -> loading -> success/error nếu target quản lý state.

## Verify bắt buộc khi triển khai test

1. `flutter analyze`
2. `flutter test`
3. `flutter test --coverage` khi cần đo baseline hoặc trước mốc release
4. Manual smoke flow liên quan trực tiếp nếu chạm UI/navigation/session

## Done khi

- Kế hoạch hoặc test mới tập trung vào rủi ro thật, không chỉ tăng số lượng.
- Có bằng chứng chạy test/analyze hoặc lý do rõ nếu chưa chạy được.
- Các dependency test, mock/fake, fixture, và folder structure nhất quán với kiến trúc Beacon.
