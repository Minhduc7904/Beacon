# Routing với GoRouter

## Mục tiêu

Tài liệu này hướng dẫn:
- Cách khai báo route tập trung.
- Cách đăng ký route trong GoRouter.
- Cách điều hướng giữa các màn hình.
- Ví dụ thực tế theo cấu trúc hiện tại của Beacon App.

---

## 1) Cấu trúc file routing

```
lib/core/config/
├── app_routes.dart   // Khai báo hằng số path
└── app_router.dart   // Khởi tạo GoRouter và đăng ký danh sách route
```

---

## 2) Khai báo path route trong `app_routes.dart`

Mục đích: tránh hardcode chuỗi path nhiều nơi.

Ví dụ hiện tại:

```dart
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String logout = '/logout';
}
```

Quy ước khuyến nghị:
- Mỗi route là một hằng số `static const`.
- Tên ngắn gọn, cùng phong cách đặt tên với màn hình.
- Không dùng trực tiếp chuỗi `'/xxx'` trong UI.

---

## 3) Đăng ký route trong `app_router.dart`

Ví dụ hiện tại:

```dart
final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) =>
          const AuthGuard(child: DashboardPage()),
    ),
    GoRoute(
      path: AppRoutes.logout,
      name: AppRoutes.logout,
      builder: (context, state) => const LogoutPage(),
    ),
  ],
);
```

Ý nghĩa các thành phần chính:
- `initialLocation`: màn hình vào app lần đầu.
- `errorBuilder`: fallback khi vào route không tồn tại.
- `path`: URL path của route.
- `name`: tên route để dùng với `goNamed` hoặc `pushNamed`.
- `builder`: tạo widget cho route.

Ghi chú:
- `home` đang được bọc `AuthGuard` để chặn truy cập khi chưa đăng nhập.

---

## 4) Cách thêm route mới

Ví dụ: thêm route `profile`.

### Bước 1: Khai báo trong `app_routes.dart`

```dart
static const String profile = '/profile';
```

### Bước 2: Đăng ký trong `app_router.dart`

```dart
GoRoute(
  path: AppRoutes.profile,
  name: AppRoutes.profile,
  builder: (context, state) => const ProfilePage(),
),
```

### Bước 3: Điều hướng từ UI

```dart
context.go(AppRoutes.profile);
```

---

## 5) Điều hướng trong UI

### `go` (thay thế route hiện tại)

```dart
context.go(AppRoutes.home);
```

Dùng khi:
- Chuyển màn hình chính sau login.
- Không muốn quay lại màn trước bằng nút back.

### `push` (đẩy thêm route mới lên stack)

```dart
context.push(AppRoutes.home);
```

Dùng khi:
- Muốn có thể back về màn hình trước đó.

### `goNamed` (điều hướng bằng tên route)

```dart
context.goNamed(AppRoutes.logout);
```

Dùng khi:
- Ưu tiên name thay vì path string.
- Chuẩn bị tốt cho trường hợp path thay đổi nhưng name giữ nguyên.

---

## 6) Ví dụ luồng thực tế trong Beacon App

### Login thành công -> vào Home

```dart
context.go(AppRoutes.home);
```

### Nhấn nút logout ở Dashboard -> sang trang Logout

```dart
context.go(AppRoutes.logout);
```

### Truy cập route sai -> NotFoundPage

Ví dụ người dùng mở URL không tồn tại:

```
/abc-xyz
```

Kết quả:
- `errorBuilder` trả về `NotFoundPage()`.

---

## 7) Ví dụ route có tham số (tham khảo)

Nếu cần route chi tiết theo id, có thể khai báo:

```dart
GoRoute(
  path: '/users/:id',
  name: 'user-detail',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return UserDetailPage(userId: id);
  },
),
```

Điều hướng:

```dart
context.go('/users/123');
// hoặc
context.goNamed('user-detail', pathParameters: {'id': '123'});
```

---

## 8) Lỗi thường gặp

- Quên khai báo route trong `routes` của `GoRouter`.
- Dùng nhầm giữa `go` và `push`, dẫn tới hành vi back không như mong đợi.
- Hardcode path trong nhiều file, khó bảo trì khi đổi URL.
- Route cần bảo vệ nhưng quên bọc `AuthGuard`.

---

## 9) Best practices đề xuất cho dự án

- Giữ `AppRoutes` là nguồn duy nhất cho path constants.
- Dùng `goNamed` hoặc `pushNamed` khi số lượng route tăng.
- Chỉ bật `debugLogDiagnostics` ở môi trường phát triển.
- Với route private, luôn bọc guard (hoặc dùng redirect tập trung nếu mở rộng sau này).

---

## 10) Tóm tắt nhanh

- Khai báo path trong `app_routes.dart`.
- Đăng ký route trong `app_router.dart`.
- Điều hướng bằng `context.go`, `context.push`, `context.goNamed`.
- Dùng `AuthGuard` cho màn hình cần đăng nhập.
- Dùng `errorBuilder` để xử lý route không hợp lệ.