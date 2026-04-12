# Skill: Tích hợp API và Interface trong Beacon

## Mục tiêu

Thêm hoặc chỉnh sửa API mà vẫn giữ contract rõ ràng giữa datasource, repository, usecase và UI.

## Khi dùng

- Có endpoint mới từ backend
- Thay đổi schema request/response
- Mở rộng luồng lấy dữ liệu trong feature hiện có

## Đầu vào tối thiểu

1. Endpoint + method
2. Request payload
3. Response payload mẫu
4. Rule nghiệp vụ lỗi

## Quy trình thực thi

### 1) Cập nhật endpoint constant
- Thêm vào `lib/core/network/api_endpoints.dart`.
- Không để URL/path rải rác trong datasource.

### 2) Remote datasource
- Gọi qua `DioClient`.
- Parse qua `ApiHandler.handle<T>()`.
- Trả model nhất quán.

### 3) Model mapping
- Tạo/cập nhật model trong `data/models`.
- Xác nhận mapping nullability, kiểu dữ liệu, key name.

### 4) Repository contract
- Check mạng qua `NetworkInfo` nếu cần.
- `try/catch` exception ở repository và map bằng `toFailure()`.
- Trả `Either<Failure, T>` đúng chuẩn domain.

### 5) Nối lên usecase/notifier
- Validation nghiệp vụ đặt ở usecase.
- Notifier chuyển state theo `fold`.
- Thông điệp UI đi qua `appMessageProvider.notifier`.

## Red flags

- Parse JSON trong UI.
- Trả `DioException` thẳng ra presentation.
- Thêm dependency mới mà không wiring providers.

## Verify bắt buộc

1. Test thủ công case thành công + thất bại + mất mạng
2. `flutter analyze`
3. Kiểm tra luồng liên quan không bị regress

## Done khi

- API chạy đúng contract ở cả success và error path
- Message lỗi hiển thị rõ cho người dùng
- Không phá flow auth/network hiện hữu
