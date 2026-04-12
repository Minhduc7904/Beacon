# Skill: Thêm Feature Flutter cho Beacon

## Mục tiêu

Tạo feature mới hoặc mở rộng feature hiện có theo đúng kiến trúc `data -> domain -> presentation`, không phá flow auth/router/providers hiện tại.

## Khi dùng

- Tạo module mới trong `lib/features/*`
- Thêm page/notifier/usecase/repository
- Bổ sung route và điều hướng cho màn hình mới

## Đầu vào tối thiểu

1. Tên feature
2. User story và điều kiện thành công
3. Có dùng API hay local-only
4. Có route mới hay không

## Quy trình thực thi

### 1) Chốt phạm vi thay đổi nhỏ
- Xác định đúng lớp cần sửa, tránh lan toàn module.
- Nếu task lớn, chia thành nhiều lát cắt triển khai độc lập.

### 2) Thiết kế theo domain trước
- Tạo/điều chỉnh entity, repository abstract, usecase.
- Usecase phải trả `Future<Either<Failure, T>>`.

### 3) Triển khai data layer
- Tạo datasource interface + impl.
- API parse qua `ApiHandler.handle<T>()`.
- Repository impl map exception sang failure bằng `toFailure()`.

### 4) Triển khai presentation layer
- Dùng `StateNotifier` + state class rõ ràng.
- UI state tối thiểu phải có: `Loading`, `Success`, `Error`.
- Feedback người dùng dùng `appMessageProvider.notifier`.

### 5) Wiring dependency
- Bắt buộc thêm vào `lib/core/providers/providers.dart`.
- Không khởi tạo dependency trực tiếp trong widget/page.

### 6) Routing (nếu có)
- Khai báo trong `app_routes.dart`.
- Đăng ký trong `app_router.dart`.
- Điều hướng bằng route constant.

## Cấm làm

- Hardcode path route, endpoint, storage key, asset path.
- Để presentation gọi trực tiếp datasource.
- Dùng snackbar/toast rời rạc khi đã có global message.

## Verify bắt buộc

1. `flutter analyze`
2. Chạy flow chính liên quan trên app
3. Nếu có test liên quan: cập nhật/chạy test

## Done khi

- Feature chạy end-to-end đúng user story
- Không phát sinh lỗi analyze mới từ thay đổi
- Không phá vỡ flow đăng nhập/đăng xuất/điều hướng
