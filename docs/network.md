# Network Layer

## Tổng quan

Network layer nằm trong `core/network/`, chịu trách nhiệm toàn bộ giao tiếp HTTP giữa app và server.  
Sử dụng thư viện **Dio** với cơ chế interceptor để xử lý token và logging tập trung.

---

## Cấu trúc file

```
core/network/
├── dio_client.dart       ← HTTP client chính
├── api_endpoints.dart    ← Tập trung toàn bộ URL
├── interceptor.dart      ← AuthInterceptor + LoggingInterceptor
└── network_info.dart     ← Kiểm tra kết nối mạng
```

---

## Chi tiết từng file

### `api_endpoints.dart`

Nơi khai báo toàn bộ endpoint URL. Không hardcode URL trong repository hay datasource.

```dart
class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com';
  static const String login   = '/auth/login';
  // ...
}
```

---

### `interceptor.dart`

#### `AuthInterceptor`

- Nhận `AuthLocalDatasource` qua constructor.
- `onRequest`: đọc `accessToken` từ SharedPreferences, gắn vào header:
  ```
  Authorization: Bearer <token>
  ```
- `onError`: bắt lỗi `401 Unauthorized` để xử lý refresh token hoặc redirect về màn login.

#### `LoggingInterceptor`

Log toàn bộ traffic HTTP ra console theo format:

```
──────────────────────────────────────────
→ REQUEST [POST]
   URL     : https://api.example.com/auth/login
   BODY    : {email: ..., password: ...}
──────────────────────────────────────────

──────────────────────────────────────────
← RESPONSE [200]
   URL     : https://api.example.com/auth/login
   DATA    : {accessToken: ..., refreshToken: ...}
──────────────────────────────────────────

──────────────────────────────────────────
✕ ERROR [401] — badResponse
   URL     : https://api.example.com/auth/login
   MESSAGE : ...
──────────────────────────────────────────
```

> Chỉ dùng trong môi trường **debug**. Có thể bọc bằng `kDebugMode` khi cần.

---

### `dio_client.dart`

Wrapper bao quanh `Dio`, cung cấp các method chuẩn hoá:

| Method | Mô tả |
|--------|-------|
| `get(path, {queryParameters, options})` | HTTP GET |
| `post(path, {data, queryParameters, options})` | HTTP POST |
| `put(path, {data, queryParameters, options})` | HTTP PUT |
| `delete(path, {data, queryParameters, options})` | HTTP DELETE |

**Khởi tạo:**
```dart
// Cần inject AuthLocalDatasource
final dioClient = DioClient(authLocalDatasource);
```

**Cấu hình mặc định:**
- `connectTimeout`: 15 giây
- `receiveTimeout`: 15 giây
- `Content-Type`: `application/json`
- Interceptors: `AuthInterceptor` → `LoggingInterceptor`

---

### `network_info.dart`

Kiểm tra trạng thái kết nối internet trước khi gọi API.

```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
```

Impl dùng `connectivity_plus`:
```dart
final isOnline = await networkInfo.isConnected;
if (!isOnline) throw NetworkException();
```

---

## Dependency graph

```
DioClient
  ├── AuthInterceptor ──→ AuthLocalDatasource ──→ LocalStorage (SharedPrefs)
  └── LoggingInterceptor

Repository
  └── NetworkInfo ──→ Connectivity (connectivity_plus)
```
