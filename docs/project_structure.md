# Cấu Trúc Dự Án - Beacon App

Tài liệu này mô tả snapshot cấu trúc hiện tại của dự án để AI agent và dev mới nắm nhanh context trước khi code.

## 1) Cấu trúc lib (mức cao)

```
lib/
├── main.dart
├── core/
│   ├── config/
│   ├── constants/
│   ├── errors/
│   ├── messages/
│   ├── network/
│   ├── observers/
│   ├── pages/
│   ├── preferences/
│   ├── providers/
│   ├── storage/
│   ├── theme/
│   ├── utils/
│   └── widgets/
└── features/
    ├── auth/
    ├── home/
    ├── onboarding/
    ├── post_preview/
    ├── splash/
    └── widgets/
```

## 2) Source of truth quan trọng

- Routes: `lib/core/config/app_routes.dart`
- Router graph: `lib/core/config/app_router.dart`
- Providers/DI: `lib/core/providers/providers.dart`
- API endpoints: `lib/core/network/api_endpoints.dart`
- Storage keys: `lib/core/constants/storage_keys.dart`

## 3) Điểm vào ứng dụng

`lib/main.dart`:

1. `WidgetsFlutterBinding.ensureInitialized()`
2. Load `.env`
3. Khởi tạo `SharedPreferences`
4. Override `sharedPreferencesProvider` trong `ProviderScope`
5. `MaterialApp.router(routerConfig: appRouter)`
6. `GlobalMessageOverlay` chỉ được bọc ở môi trường dev (`AppEnv.isDev`)

## 4) Core layer

### `core/config/`

- `app_routes.dart`: route names + route paths
- `app_router.dart`: đăng ký toàn bộ `GoRoute`, guard, transition, observer

### `core/network/`

- `dio_client.dart`, `api_handler.dart`, `api_response.dart`
- `api_endpoints.dart` là nơi khai báo endpoint constants
- `interceptor.dart` cho auth/logging concerns
- `network_info.dart` để kiểm tra kết nối

### `core/messages/`

- `app_message.dart`
- `app_message_notifier.dart`

Hiển thị UI thông điệp qua:

- `lib/core/widgets/message_toast/global_message_overlay.dart`
- `lib/core/widgets/message_toast/message_toast.dart`

### `core/providers/`

- `providers.dart` chứa DI graph chính của app
- Mọi dependency mới cần được wiring tại đây

### `core/storage/` + `core/preferences/`

- `local_storage.dart` + `shared_prefs_storage.dart`
- `app_preferences.dart` + `app_preferences_impl.dart`

## 5) Feature map hiện tại

Mỗi feature bám Clean Architecture: `data -> domain -> presentation`.

### `features/auth/`

- Login, register nhiều bước, logout, get profile (`get_me`)
- Usecases hiện có: `login`, `logout`, `register`, `get_me`, `check_email_availability`, `check_phone_availability`

### `features/home/`

- Home page và camera flow
- Controller: `home_notifier.dart`, `home_state.dart`

### `features/post_preview/`

- Preview media và gửi bài
- Usecase: `upload_post_media_usecase.dart`

### `features/onboarding/`

- Luồng onboarding và persistence trạng thái
- Usecases: `should_show_onboarding`, `complete_onboarding`

### `features/splash/`

- Trang splash khởi động

### `features/widgets/`

- Trang demo shared widgets

## 6) Ghi chú vận hành

1. Không hardcode route/endpoint/storage key ngoài source-of-truth.
2. Không khởi tạo dependency trực tiếp trong page/widget nếu đã có provider.
3. Với thay đổi lớn về kiến trúc, cập nhật lại tài liệu trong `docs/` và `.github/` cùng lúc.
