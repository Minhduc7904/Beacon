# Storage & Preferences

## Tổng quan

Lớp lưu trữ cục bộ nằm trong `core/storage/` và `core/preferences/`.  
Thiết kế theo **Dependency Inversion**: tầng trên chỉ phụ thuộc vào abstract, không phụ thuộc trực tiếp vào `SharedPreferences`.

---

## Cấu trúc file

```
core/
├── constants/
│   └── storage_keys.dart          ← Tập trung toàn bộ key
├── storage/
│   ├── local_storage.dart         ← Abstract interface
│   └── shared_prefs_storage.dart  ← Impl bằng shared_preferences
└── preferences/
    ├── app_preferences.dart       ← Abstract: tuỳ chọn ứng dụng
    └── app_preferences_impl.dart  ← Impl

features/auth/data/datasources/
├── auth_local_datasource.dart      ← Abstract: quản lý token
└── auth_local_datasource_impl.dart ← Impl
```

---

## Chi tiết từng file

### `storage_keys.dart`

Tập trung toàn bộ key tránh lỗi typo, dễ refactor.

| Constant | Key | Dùng cho |
|----------|-----|----------|
| `StorageKeys.accessToken` | `access_token` | JWT access token |
| `StorageKeys.refreshToken` | `refresh_token` | JWT refresh token |
| `StorageKeys.isDarkMode` | `is_dark_mode` | Chế độ tối/sáng |

---

### `local_storage.dart`

Interface generic cho key-value storage:

```dart
abstract class LocalStorage {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);

  Future<void> setBool(String key, {required bool value});
  Future<bool?> getBool(String key);

  Future<void> remove(String key);
  Future<void> clearAll();
}
```

---

### `shared_prefs_storage.dart`

Implement `LocalStorage` bằng `SharedPreferences`.

**Khởi tạo:**
```dart
final prefs = await SharedPreferences.getInstance();
final storage = SharedPrefsStorage(prefs);
```

---

### `auth_local_datasource.dart` / `_impl.dart`

Quản lý vòng đời token xác thực.

| Method | Mô tả |
|--------|-------|
| `saveAccessToken(token)` | Lưu access token |
| `getAccessToken()` | Lấy access token hiện tại |
| `saveRefreshToken(token)` | Lưu refresh token |
| `getRefreshToken()` | Lấy refresh token hiện tại |
| `clearTokens()` | Xoá cả hai token (khi logout) |

**Ví dụ sử dụng khi login thành công:**
```dart
await authLocalDatasource.saveAccessToken(response.accessToken);
await authLocalDatasource.saveRefreshToken(response.refreshToken);
```

**Khi logout:**
```dart
await authLocalDatasource.clearTokens();
```

---

### `app_preferences.dart` / `_impl.dart`

Quản lý tuỳ chọn hiển thị của ứng dụng.

| Method | Mô tả |
|--------|-------|
| `setDarkMode({required bool isDark})` | Lưu chế độ tối/sáng |
| `isDarkMode()` | Lấy trạng thái hiện tại, mặc định `false` (sáng) |

**Ví dụ sử dụng:**
```dart
// Đọc khi khởi động app
final darkMode = await appPreferences.isDarkMode();

// Lưu khi người dùng toggle
await appPreferences.setDarkMode(isDark: true);
```

---

## Dependency graph

```
AuthInterceptor
  └── AuthLocalDatasource (abstract)
        └── AuthLocalDatasourceImpl
              └── LocalStorage (abstract)
                    └── SharedPrefsStorage
                          └── SharedPreferences

AppPreferencesImpl
  └── LocalStorage (abstract)
        └── SharedPrefsStorage
              └── SharedPreferences
```
