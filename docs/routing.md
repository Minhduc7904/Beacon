# Routing với GoRouter (Beacon)

## Mục tiêu

Tài liệu này mô tả routing theo code hiện tại của Beacon và quy tắc thêm route mới đúng chuẩn.

## 1) Cấu trúc file routing

```
lib/core/config/
├── app_routes.dart
└── app_router.dart
```

## 2) Source of truth route constants

Tất cả path và route name được khai báo trong `app_routes.dart`.

Nhóm route chính đang có:

- Splash: `/`
- Onboarding: `/onboarding`
- Login: `/login`
- Register flow: `/register`, `/register/phone-number`, `/register/password`, `/register/name`, `/register/username`
- Home: `/home`
- Post preview: `/post-preview`
- Logout: `/logout`
- Shared widgets demo: `/widgets`

Ngoài path, mỗi route có `xxxName` để điều hướng bằng `goNamed/pushNamed`.

## 3) Đăng ký route trong app_router

Router hiện tại dùng:

- `initialLocation: AppRoutes.splash`
- `errorBuilder: NotFoundPage`
- `observers: [appRouteStackObserver]`

Các guard quan trọng:

- `AuthGuard(child: HomePage())` cho route home
- `AuthGuard(child: PostPreviewPage(...))` cho route post preview

Các route có validation `state.extra`:

- `post-preview` yêu cầu `extra` là `String filePath` không rỗng
- register step routes yêu cầu `RegisterDraftData` hợp lệ theo thứ tự bước

## 4) Điều hướng trong UI

Khuyến nghị ưu tiên dùng constants trong `AppRoutes`.

Ví dụ:

```dart
context.go(AppRoutes.home);
context.goNamed(AppRoutes.logoutName);
await context.pushNamed(AppRoutes.postPreviewName, extra: filePath);
```

Phân biệt nhanh:

- `go`: thay thế route hiện tại
- `push/pushNamed`: đẩy route mới, có thể back

## 5) Cách thêm route mới

1. Thêm constant path + name trong `app_routes.dart`
2. Đăng ký `GoRoute` trong `app_router.dart`
3. Áp guard nếu là route private
4. Điều hướng bằng `AppRoutes.xxx` hoặc `AppRoutes.xxxName`

Ví dụ:

```dart
// app_routes.dart
static const String profile = '/profile';
static const String profileName = 'profile';

// app_router.dart
GoRoute(
  path: AppRoutes.profile,
  name: AppRoutes.profileName,
  builder: (context, state) => const ProfilePage(),
)
```

## 6) Các flow thực tế đang dùng

- Login thành công -> `context.go(AppRoutes.home)`
- Capture xong ảnh ở home -> `pushNamed(AppRoutes.postPreviewName, extra: path)`
- Logout flow -> điều hướng route logout và quay về login sau khi hoàn tất

## 7) Lỗi thường gặp

- Hardcode path string trực tiếp trong page/widget
- Quên route name khi dùng `goNamed/pushNamed`
- Route cần `extra` nhưng không validate kiểu dữ liệu
- Route private không bọc guard

## 8) Best practices cho Beacon

- Không hardcode route string ngoài `app_routes.dart`
- Luôn đăng ký route tại `app_router.dart`
- Route private phải có guard phù hợp
- Route phụ thuộc `state.extra` phải validate đầu vào trước khi render page