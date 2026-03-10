# Cấu Trúc Dự Án - Beacon App

## Thư mục `lib/`

```
lib/
├── main.dart
├── core/
│   ├── config/
│   ├── constants/
│   │   └── storage_keys.dart
│   ├── errors/
│   │   └── exceptions.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── api_endpoints.dart
│   │   ├── interceptor.dart
│   │   └── network_info.dart
│   ├── preferences/
│   │   ├── app_preferences.dart
│   │   └── app_preferences_impl.dart
│   ├── storage/
│   │   ├── local_storage.dart
│   │   └── shared_prefs_storage.dart
│   └── utils/
└── features/
    └── auth/
        ├── data/
        │   └── datasources/
        │       ├── auth_local_datasource.dart
        │       └── auth_local_datasource_impl.dart
        ├── domain/
        └── presentation/
```

## Mô tả

### `main.dart`
Điểm khởi đầu của ứng dụng.

### `core/`
Chứa các thành phần dùng chung toàn bộ ứng dụng.

| Thư mục / File | Mô tả |
|----------------|-------|
| `config/` | Cấu hình ứng dụng (theme, routes, env,...) |
| `constants/storage_keys.dart` | Tập trung toàn bộ key của SharedPreferences |
| `errors/exceptions.dart` | Định nghĩa các Exception: `ServerException`, `NetworkException`, `CacheException`, `UnauthorizedException` |
| `network/dio_client.dart` | Khởi tạo và cấu hình Dio, bọc các method GET/POST/PUT/DELETE |
| `network/api_endpoints.dart` | Tập trung toàn bộ URL endpoints của API |
| `network/interceptor.dart` | `AuthInterceptor` (gắn token), `LoggingInterceptor` (log request/response) |
| `network/network_info.dart` | Kiểm tra trạng thái kết nối mạng qua `connectivity_plus` |
| `preferences/app_preferences.dart` | Abstract: quản lý tuỳ chọn ứng dụng (theme sáng/tối) |
| `preferences/app_preferences_impl.dart` | Impl `AppPreferences` sử dụng `LocalStorage` |
| `storage/local_storage.dart` | Abstract: interface lưu trữ key-value (String, Bool) |
| `storage/shared_prefs_storage.dart` | Impl `LocalStorage` dùng `shared_preferences` |
| `utils/` | Các hàm tiện ích dùng chung |

### `features/`
Chứa các tính năng của ứng dụng, mỗi feature tuân theo kiến trúc Clean Architecture.

#### `auth/`
Tính năng xác thực người dùng.

| Thư mục / File | Mô tả |
|----------------|-------|
| `data/datasources/auth_local_datasource.dart` | Abstract: lưu/lấy/xoá `accessToken`, `refreshToken` |
| `data/datasources/auth_local_datasource_impl.dart` | Impl sử dụng `LocalStorage` |
| `data/` | Repository impl, models |
| `domain/` | Entities, repository interfaces, use cases |
| `presentation/` | UI: pages, widgets, BLoC/Cubit |

## Thư viện sử dụng

| Package | Version | Mục đích |
|---------|---------|----------|
| `dio` | ^5.7.0 | HTTP client |
| `connectivity_plus` | ^6.1.1 | Kiểm tra kết nối mạng |
| `shared_preferences` | ^2.3.4 | Lưu trữ token và tuỳ chọn người dùng |
