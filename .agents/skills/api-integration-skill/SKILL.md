---
name: api-integration-skill
description: "Use when: integrating or modifying backend APIs, endpoint contracts, request/response mapping, and business error-code handling in Beacon."
---

# Skill: Tích hợp API và Interface trong Beacon (Chi tiết)

## Mục tiêu

Triển khai hoặc chỉnh sửa API theo đúng Clean Architecture của dự án Beacon, giữ contract rõ ràng từ data đến UI, đồng thời đảm bảo luồng xử lý lỗi nhất quán.

Tài liệu này lấy auth login làm chuẩn tham chiếu để áp dụng cho các feature khác.

## Khi dùng

- Có endpoint mới từ backend.
- Backend đổi schema request/response.
- API bổ sung trường `code` lỗi nghiệp vụ.
- Cần đưa dữ liệu mới lên UI theo flow datasource -> repository -> usecase -> notifier/page.

## Đầu vào tối thiểu

1. HTTP method + endpoint path.
2. Request payload (field bắt buộc/tuỳ chọn).
3. Response payload mẫu (success + error).
4. Danh sách business error code (nếu có).
5. Rule nghiệp vụ validate input ở client.

## Flow chuẩn cần bám

```text
Page/Widget
	-> Notifier
	-> UseCase
	-> Repository (domain contract)
	-> RemoteDatasource
	-> DioClient
	-> ApiHandler
	-> Exception -> Failure
	-> Notifier fold
	-> UI state + AppMessage
```

## Quy trình thực thi chi tiết

### 1) Cập nhật endpoint constant

- Thêm endpoint vào `lib/core/network/api_endpoints.dart`.
- Không hardcode URL/path trong datasource hoặc UI.
- Đặt tên rõ nghiệp vụ, ví dụ: `login`, `register`, `refreshToken`.

### 2) Cập nhật model data layer

- Tạo/cập nhật model trong `features/<feature>/data/models`.
- Mapping đúng key name từ backend, chú ý nullability.
- Chỉ parse JSON ở data layer, không parse trong usecase/notifier/UI.

### 3) Remote datasource contract + implementation

- Khai báo method ở `*_remote_datasource.dart`.
- Implement tại `*_remote_datasource_impl.dart` bằng `DioClient`.
- Parse response qua `ApiHandler.handle<T>()`.

Mẫu:

```dart
final response = await _dioClient.post(
	ApiEndpoints.login,
	data: {'username': username, 'password': password},
);

final result = ApiHandler.handle<AuthResponseModel>(
	response,
	fromJsonT: (json) => AuthResponseModel.fromJson(json as Map<String, dynamic>),
);

return result.data!;
```

### 4) Mapping lỗi theo code (ưu tiên trước status code)

Nếu backend có `code` lỗi nghiệp vụ:

- Tạo mapper trong `data/mappers`, ví dụ `auth_error_code_mapper.dart`.
- Áp vào `ApiHandler.handle` qua `codeMessageMapper`.
- Với trường hợp non-2xx do Dio throw sớm, dùng `ApiHandler.rethrowDioException(...)` để vẫn map theo `code`.

Thứ tự ưu tiên message:

1. Message map từ `code` (nếu có và match).
2. `message` từ API response.
3. Fallback theo `statusCode`.

Ví dụ login codes:

- `VALIDATION_ERROR`
- `INVALID_CREDENTIALS`
- `ACCOUNT_INACTIVE`

### 5) Repository implementation

- Interface domain trả `Future<Either<Failure, T>>`.
- Repository impl check mạng qua `NetworkInfo` nếu use case yêu cầu.
- Bọc `try/catch` và map exception bằng `toFailure()`.
- Không để `DioException` hoặc `Response` rò rỉ lên domain/presentation.

Mẫu:

```dart
try {
	final data = await _remoteDatasource.login(...);
	return Right(mappedResult);
} on Exception catch (e) {
	return Left(e.toFailure());
}
```

### 6) Use case (validation nghiệp vụ)

- Đặt validation input tại usecase.
- Fail sớm bằng `ValidationFailure` khi dữ liệu không hợp lệ.
- Chỉ gọi repository khi validate pass.

### 7) Notifier + state

- Notifier set loading trước khi gọi usecase.
- Dùng `fold` để tách success/failure.
- Failure: map về state lỗi phù hợp.
- Success: cập nhật state thành công.
- UI message đi qua `appMessageProvider.notifier`.

### 8) Page/Widget integration

- Widget gọi action qua notifier, không gọi trực tiếp datasource/repository.
- `ref.watch` để render state hiện tại.
- `ref.listen` để xử lý side effect như navigation sau thành công.

### 9) DI wiring

- Mọi dependency mới phải khai báo trong `lib/core/providers/providers.dart`.
- Không new thủ công datasource/repository/usecase trong widget.

## Checklist nhanh theo tầng

### Data

1. Endpoint constant đã khai báo.
2. Model parse đúng schema.
3. Datasource gọi DioClient + ApiHandler.
4. Có code mapper nếu backend trả code nghiệp vụ.

### Domain

1. Repository contract trả `Either<Failure, T>`.
2. Usecase có validation cần thiết.

### Presentation

1. Notifier xử lý đủ loading/success/error.
2. Message hiển thị qua app message notifier.
3. UI không chứa logic parse/network.

## Red flags (không được làm)

- Parse JSON trong UI hoặc notifier.
- Throw/propagate `DioException` trực tiếp lên presentation.
- Hardcode endpoint hoặc storage key ngoài core constants.
- Bỏ qua `NetworkInfo` trong nghiệp vụ cần check mạng.
- Thêm dependency nhưng không wiring vào `providers.dart`.

## Verify bắt buộc

1. Test thủ công 3 case: success, API error, no network.
2. Kiểm tra message hiển thị đúng theo code lỗi backend.
3. `flutter analyze`.
4. Nếu chạm logic hiện có, chạy test liên quan (`flutter test` khi cần).
5. Kiểm tra luồng chính không regress (login/logout/navigation).

## Done khi

- API chạy đúng contract ở success và error path.
- Error message nhất quán, ưu tiên map theo `code` nếu có.
- Dữ liệu đi đúng tầng, không rò rỉ chi tiết network lên UI.
- Không phá flow auth/network hiện hữu.
