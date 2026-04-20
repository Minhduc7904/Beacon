# Auth Login Workflow (Datasource → UI)

Tài liệu này mô tả luồng triển khai đăng nhập theo Clean Architecture trong dự án Beacon, đi từ Data layer lên UI layer, kèm checklist để mở rộng cho API mới.

---

## 1) Mục tiêu

- Chuẩn hóa cách tạo luồng login theo cấu trúc hiện tại của dự án.
- Đảm bảo tách vai trò đúng tầng: data -> domain -> presentation.
- Xử lý lỗi nhất quán: parse response ở network/data, map exception -> failure ở core/errors, hiển thị message ở presentation.

---

## 2) Sơ đồ luồng tổng quát

```text
LoginPage/LoginForm
    ↓ gọi action
AuthNotifier.login()
    ↓
LoginUseCase.call(params)
    ↓
AuthRepository.login()
    ↓
AuthRemoteDatasource.login()
    ↓
DioClient.post(ApiEndpoints.login)
    ↓
ApiHandler.handle<T>() / ApiHandler.rethrowDioException()
    ↓ throw Exception (nếu fail)
Repository catch Exception -> toFailure()
    ↓
Either<Failure, AuthResult>
    ↓
AuthNotifier cập nhật AuthState + AppMessageNotifier
    ↓
UI rebuild / navigate / hiển thị toast
```

---

## 3) Data Layer

### 3.1. Tạo contract cho Remote Datasource

File: lib/features/auth/data/datasources/auth_remote_datasource.dart

- Khai báo rõ input/output của API login:
  - Input: username, password
  - Output: AuthResponseModel

```dart
abstract class AuthRemoteDatasource {
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  });
}
```

### 3.2. Cài đặt Remote Datasource

File: lib/features/auth/data/datasources/auth_remote_datasource_impl.dart

Nhiệm vụ chính:
1. Gọi endpoint qua DioClient.
2. Parse response qua ApiHandler.
3. Map code lỗi của BE (nếu có) ngay tại data/network layer.
4. Trả model thành công, hoặc throw exception có message phù hợp.

```dart
final response = await _dioClient.post(
  ApiEndpoints.login,
  data: {'username': username, 'password': password},
);

final result = ApiHandler.handle<AuthResponseModel>(
  response,
  fromJsonT: (json) => AuthResponseModel.fromJson(json as Map<String, dynamic>),
  codeMessageMapper: AuthErrorCodeMapper.mapLoginCode,
);

return result.data!;
```

Với trường hợp Dio ném lỗi non-2xx trước khi vào handle:

```dart
} on DioException catch (e) {
  ApiHandler.rethrowDioException(
    e,
    codeMessageMapper: AuthErrorCodeMapper.mapLoginCode,
  );
}
```

### 3.3. Khai báo mapper code lỗi cho login

File: lib/features/auth/data/mappers/auth_error_code_mapper.dart

- VALIDATION_ERROR -> Username hoặc password để trống hoặc vượt quá độ dài cho phép.
- INVALID_CREDENTIALS -> Sai username hoặc password.
- ACCOUNT_INACTIVE -> Tài khoản đã bị vô hiệu hóa.
- Không có code hoặc code chưa hỗ trợ -> trả null để fallback theo message/status code.

---

## 4) Domain Layer

### 4.1. Repository interface

File: lib/features/auth/domain/repositories/auth_repository.dart

- Login luôn trả Either<Failure, AuthResult>.
- Domain không biết Dio, Response, JSON.

### 4.2. Repository implementation

File: lib/features/auth/data/repositories/auth_repository_impl.dart

Nhiệm vụ chính:
1. Kiểm tra kết nối mạng (NetworkInfo).
2. Gọi remote datasource.
3. Lưu token qua local datasource.
4. Catch Exception và map sang Failure bằng extension toFailure().

```dart
try {
  final authResponse = await _remoteDatasource.login(...);
  await _localDatasource.saveAccessToken(authResponse.tokens.accessToken);
  await _localDatasource.saveRefreshToken(authResponse.tokens.refreshToken);
  return Right(AuthResult(tokens: authResponse.tokens, user: authResponse.user));
} on Exception catch (e) {
  return Left(e.toFailure());
}
```

### 4.3. Use case

File: lib/features/auth/domain/usecase/login_usecase.dart

- Validate nghiệp vụ đầu vào (rỗng, độ dài mật khẩu...).
- Nếu invalid -> trả ValidationFailure ngay, không gọi repository.
- Nếu hợp lệ -> gọi repository.login().

---

## 5) Presentation Layer

### 5.1. Auth state

File: lib/features/auth/presentation/controllers/auth_state.dart

- Trạng thái chuẩn: initial, loading, success, error, validationError.

### 5.2. Auth notifier

File: lib/features/auth/presentation/controllers/auth_notifier.dart

Nhiệm vụ chính khi login:
1. set loading.
2. gọi LoginUseCase.
3. fold kết quả:
   - Failure: set state lỗi phù hợp + addError qua AppMessageNotifier.
   - Success: set AuthSuccess + addSuccess.

```dart
result.fold(
  (failure) {
    if (failure is LoginValidationFailure) {
      state = AuthValidationError(...);
    } else {
      _messageNotifier.addError(failure.message);
      state = AuthError(failure.message);
    }
  },
  (authResult) {
    _messageNotifier.addSuccess('Chào mừng ${authResult.user.fullName}!');
    state = AuthSuccess(authResult.user);
  },
);
```

### 5.3. Login page và form

Files:
- lib/features/auth/presentation/pages/login_page.dart
- lib/features/auth/presentation/widgets/login/login_form.dart

Luồng UI:
1. Người dùng nhập username/password.
2. Nhấn button -> gọi notifier.login().
3. UI watch auth state để hiển thị loading/error.
4. UI listen auth state để navigate khi success.

```dart
ref.listen<AuthState>(authNotifierProvider, (_, state) {
  if (state is AuthSuccess) {
    context.go(AppRoutes.home);
  }
});
```

---

## 6) DI Wiring (Riverpod)

File: lib/core/providers/providers.dart

Khi tạo feature mới hoặc mở rộng login, cần đảm bảo đủ chuỗi provider:
1. DioClient provider
2. Datasource provider
3. Repository provider
4. UseCase provider
5. Notifier provider

Nguyên tắc: dependency mới phải đi qua providers.dart, không khởi tạo thủ công trong widget.

---

## 7) Quy tắc xử lý lỗi cho API login

Thứ tự ưu tiên message:
1. code từ BE đã được map (nếu có)
2. message từ API response
3. fallback theo status code

Ví dụ code login hỗ trợ:
- null: thành công (success = true)
- VALIDATION_ERROR
- INVALID_CREDENTIALS
- ACCOUNT_INACTIVE

Lợi ích:
- Message hiển thị ổn định dù BE thay đổi wording message.
- Dễ mở rộng code mới theo từng nghiệp vụ.

---

## 8) Checklist khi thêm API auth mới

1. Khai báo endpoint ở core/network/api_endpoints.dart.
2. Tạo method ở auth_remote_datasource.dart.
3. Implement tại auth_remote_datasource_impl.dart.
4. Parse response bằng ApiHandler.handle<T>().
5. Nếu API có error code riêng, tạo/điều chỉnh mapper code tại data/mappers.
6. Bổ sung method repository interface + implementation.
7. Tạo/điều chỉnh use case cho validation nghiệp vụ.
8. Cập nhật notifier/state cho side effects UI.
9. Cập nhật UI (page/widget) theo state.
10. Chạy flutter analyze và test luồng chính.

---

## 9) Gợi ý mở rộng

- Tách mapper code theo từng endpoint nếu logic khác nhau:
  - mapLoginCode
  - mapRegisterCode
  - mapRefreshTokenCode
- Viết unit test cho:
  - LoginUseCase validation
  - AuthRepositoryImpl (success/failure mapping)
  - AuthErrorCodeMapper
