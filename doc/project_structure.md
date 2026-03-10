# Cấu Trúc Dự Án - Beacon App

## Thư mục `lib/`

```
lib/
├── main.dart
├── core/
│   ├── config/
│   │   ├── app_router.dart
│   │   └── app_routes.dart
│   ├── constants/
│   │   ├── app_images.dart
│   │   └── storage_keys.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── messages/
│   │   ├── app_message.dart
│   │   └── app_message_notifier.dart
│   ├── network/
│   │   ├── api_endpoints.dart
│   │   ├── api_handler.dart
│   │   ├── api_response.dart
│   │   ├── dio_client.dart
│   │   ├── interceptor.dart
│   │   └── network_info.dart
│   ├── pages/
│   │   └── not_found_page.dart
│   ├── preferences/
│   │   ├── app_preferences.dart
│   │   └── app_preferences_impl.dart
│   ├── providers/
│   │   └── providers.dart
│   ├── storage/
│   │   ├── local_storage.dart
│   │   └── shared_prefs_storage.dart
│   └── widgets/
│       ├── auth_guard.dart
│       ├── global_message_overlay.dart
│       └── message_toast.dart
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── auth_local_datasource.dart
    │   │   │   ├── auth_local_datasource_impl.dart
    │   │   │   ├── auth_remote_datasource.dart
    │   │   │   └── auth_remote_datasource_impl.dart
    │   │   ├── models/
    │   │   │   ├── auth_response_model.dart
    │   │   │   ├── tokens_model.dart
    │   │   │   └── user_model.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── auth_result.dart
    │   │   │   ├── tokens.dart
    │   │   │   └── user.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecase/
    │   │       ├── login_usecase.dart
    │   │       └── logout_usecase.dart
    │   └── presentation/
    │       ├── controllers/
    │       │   ├── auth_notifier.dart
    │       │   └── auth_state.dart
    │       ├── pages/
    │       │   ├── login_page.dart
    │       │   └── logout_page.dart
    │       └── widgets/
    │           ├── login_button.dart
    │           ├── login_form.dart
    │           └── login_text_field.dart
    └── dashboard/
        └── page/
            └── dashboard_page.dart
```

---

## Mô tả

### `main.dart`
Điểm khởi đầu của ứng dụng. Khởi tạo `SharedPreferences` trước `runApp`, inject vào `ProviderScope` qua override. Bọc `MaterialApp.router` trong `GlobalMessageOverlay`.

---

### `core/`
Các thành phần dùng chung toàn bộ ứng dụng.

#### `config/`
| File | Mô tả |
|------|-------|
| `app_routes.dart` | Hằng số đường dẫn route: `login`, `home`, `logout` |
| `app_router.dart` | Cấu hình `GoRouter` với tất cả routes và `errorBuilder` |

#### `constants/`
| File | Mô tả |
|------|-------|
| `storage_keys.dart` | Tập trung toàn bộ key của `SharedPreferences` |
| `app_images.dart` | Hằng số đường dẫn assets (images, icons, animations) |

#### `errors/`
| File | Mô tả |
|------|-------|
| `exceptions.dart` | Định nghĩa exceptions: `ServerException`, `NetworkException`, `CacheException`, `UnauthorizedException` |
| `failures.dart` | Định nghĩa failures cho domain layer: `ServerFailure`, `NetworkFailure`, `CacheFailure`, `UnauthorizedFailure`, `ValidationFailure` + extension `ExceptionToFailure` (map `DioException` và các exception ra đúng `Failure`) |

#### `messages/`
| File | Mô tả |
|------|-------|
| `app_message.dart` | Model `AppMessage` với `id`, `message`, `MessageType` (success/error/info/warning) |
| `app_message_notifier.dart` | `StateNotifier<List<AppMessage>>` — `addSuccess/addError/addInfo/addWarning/removeMessage` |

#### `network/`
| File | Mô tả |
|------|-------|
| `api_endpoints.dart` | Tập trung toàn bộ URL endpoints |
| `api_handler.dart` | Parse `Response` → `ApiResponse<T>`, throw exception theo status code |
| `api_response.dart` | Generic wrapper `ApiResponse<T> { success, message, data }` |
| `dio_client.dart` | Khởi tạo Dio, bọc `get/post/put/delete` |
| `interceptor.dart` | `AuthInterceptor` (gắn Bearer token async), `LoggingInterceptor` (log request/response) |
| `network_info.dart` | Abstract `NetworkInfo` + `NetworkInfoImpl` kiểm tra kết nối mạng |

#### `pages/`
| File | Mô tả |
|------|-------|
| `not_found_page.dart` | Trang 404 — hiển thị khi route không tồn tại |

#### `preferences/`
| File | Mô tả |
|------|-------|
| `app_preferences.dart` | Abstract: `setDarkMode`, `isDarkMode` |
| `app_preferences_impl.dart` | Impl sử dụng `LocalStorage` |

#### `providers/`
| File | Mô tả |
|------|-------|
| `providers.dart` | Toàn bộ DI graph của Riverpod: providers cho SharedPreferences, Storage, Network, Datasources, Repository, UseCases, Controllers, Messages |

#### `storage/`
| File | Mô tả |
|------|-------|
| `local_storage.dart` | Abstract: `setString`, `getString`, `setBool`, `getBool`, `remove`, `clearAll` |
| `shared_prefs_storage.dart` | Impl sử dụng `shared_preferences` |

#### `widgets/`
| File | Mô tả |
|------|-------|
| `auth_guard.dart` | Bọc trang cần đăng nhập — kiểm tra `accessToken` + `refreshToken`, tự redirect về `/login` nếu thiếu |
| `global_message_overlay.dart` | `Stack` overlay toàn app — hiển thị danh sách toast từ `appMessageProvider` |
| `message_toast.dart` | Animated toast: slide-in từ trên, tự dismiss sau 3s, tap để đóng sớm |

---

### `features/`
Mỗi feature theo kiến trúc **Clean Architecture**: `data` → `domain` → `presentation`.

#### `auth/` — Xác thực người dùng

**`data/datasources/`**
| File | Mô tả |
|------|-------|
| `auth_local_datasource.dart` | Abstract: `saveAccessToken`, `getAccessToken`, `saveRefreshToken`, `getRefreshToken`, `clearTokens` |
| `auth_local_datasource_impl.dart` | Impl sử dụng `LocalStorage` + `StorageKeys` |
| `auth_remote_datasource.dart` | Abstract: `login`, `register`, `logout({refreshToken})`, `refreshToken` |
| `auth_remote_datasource_impl.dart` | Impl sử dụng `DioClient` + `ApiHandler` |

**`data/models/`**
| File | Mô tả |
|------|-------|
| `auth_response_model.dart` | Parse `{ tokens, user }` từ API response |
| `tokens_model.dart` | Parse `{ accessToken, refreshToken }`, extends `Tokens` |
| `user_model.dart` | Parse `{ userId, firstName, lastName }`, extends `User` |

**`data/repositories/`**
| File | Mô tả |
|------|-------|
| `auth_repository_impl.dart` | Impl `AuthRepository`: kiểm tra mạng, gọi datasource, lưu/xoá token |

**`domain/entities/`**
| File | Mô tả |
|------|-------|
| `user.dart` | Entity `User { userId, firstName, lastName }` |
| `tokens.dart` | Entity `Tokens { accessToken, refreshToken }` |
| `auth_result.dart` | Entity `AuthResult { tokens, user }` |

**`domain/repositories/`**
| File | Mô tả |
|------|-------|
| `auth_repository.dart` | Abstract: `login(...)`, `logout()` → `Either<Failure, T>` |

**`domain/usecase/`**
| File | Mô tả |
|------|-------|
| `login_usecase.dart` | `LoginParams { username, password }` + validation, trả `Either<Failure, AuthResult>` |
| `logout_usecase.dart` | Gọi `repository.logout()`, trả `Either<Failure, String>` |

**`presentation/controllers/`**
| File | Mô tả |
|------|-------|
| `auth_state.dart` | Sealed class: `AuthInitial`, `AuthLoading`, `AuthSuccess(user)`, `AuthError(message)`, `AuthValidationError(message)` |
| `auth_notifier.dart` | `StateNotifier<AuthState>` — `login()`, `logout()`, `reset()` + gọi `AppMessageNotifier` khi có kết quả |

**`presentation/pages/`**
| File | Mô tả |
|------|-------|
| `login_page.dart` | Form đăng nhập, lắng nghe `AuthState`, navigate khi `AuthSuccess` |
| `logout_page.dart` | Trang trung gian chỉ có loading — gọi `logout()` rồi luôn redirect về `/login` |

**`presentation/widgets/`**
| File | Mô tả |
|------|-------|
| `login_form.dart` | Form với `_ErrorBanner` cho `AuthValidationError` |
| `login_text_field.dart` | Reusable `TextFormField` |
| `login_button.dart` | Button với `CircularProgressIndicator` khi loading |

---

#### `dashboard/` — Trang chủ sau đăng nhập

| File | Mô tả |
|------|-------|
| `dashboard_page.dart` | Bọc bởi `AuthGuard`. Hiển thị `_WelcomeCard` (tên user), `_StatsRow` (3 stat cards), nút logout → navigate `/logout` |

---

## Thư viện sử dụng

| Package | Version | Mục đích |
|---------|---------|----------|
| `dio` | ^5.7.0 | HTTP client |
| `connectivity_plus` | ^6.1.1 | Kiểm tra kết nối mạng |
| `shared_preferences` | ^2.3.4 | Lưu trữ token và tuỳ chọn người dùng |
| `dartz` | ^0.10.1 | Functional programming — `Either<Failure, T>` |
| `flutter_riverpod` | ^2.6.1 | State management & dependency injection |
| `go_router` | ^14.6.3 | Navigation & routing |
