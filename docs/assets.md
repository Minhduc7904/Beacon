# Hướng dẫn sử dụng Assets (Hình ảnh, Icon, Animation)

## Cấu trúc thư mục

```
assets/
├── images/         ← Ảnh PNG/JPG (logo, placeholder, onboarding,...)
├── icons/          ← Icon SVG/PNG (social login, tab bar,...)
└── animations/     ← Lottie JSON (loading, success, error,...)
```

Toàn bộ đường dẫn được tập trung tại:
```
lib/core/constants/app_images.dart
```

> **Quy tắc:** Không bao giờ hardcode path asset trực tiếp trong widget. Luôn dùng qua `AppImages`.

---

## Thêm ảnh mới

### 1. Đặt file vào đúng thư mục

| Loại | Thư mục |
|------|---------|
| Ảnh PNG/JPG | `assets/images/` |
| Icon SVG/PNG | `assets/icons/` |
| Lottie JSON | `assets/animations/` |

### 2. Khai báo trong `app_images.dart`

```dart
// Ví dụ thêm ảnh banner
static const String banner = '$_base/banner.png';
```

> `pubspec.yaml` đã khai báo toàn bộ thư mục nên **không cần sửa** khi thêm file mới:
> ```yaml
> assets:
>   - assets/images/
>   - assets/icons/
>   - assets/animations/
> ```

---

## Sử dụng trong Widget

### Ảnh PNG / JPG

```dart
// Hiển thị ảnh thường
Image.asset(AppImages.logo)

// Với kích thước cố định
Image.asset(
  AppImages.onboarding1,
  width: 200,
  height: 200,
  fit: BoxFit.contain,
)

// Dùng như background
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage(AppImages.placeholder),
      fit: BoxFit.cover,
    ),
  ),
)
```

---

### Icon SVG

Cần thêm package `flutter_svg`:

```yaml
# pubspec.yaml
dependencies:
  flutter_svg: ^2.0.0
```

```dart
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beacon_app/core/constants/app_images.dart';

// Hiển thị icon SVG
SvgPicture.asset(
  AppImages.icGoogle,
  width: 24,
  height: 24,
)

// Đổi màu icon SVG
SvgPicture.asset(
  AppImages.icApple,
  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
  width: 24,
)
```

---

### Lottie Animation

Cần thêm package `lottie`:

```yaml
# pubspec.yaml
dependencies:
  lottie: ^3.0.0
```

```dart
import 'package:lottie/lottie.dart';
import 'package:beacon_app/core/constants/app_images.dart';

// Phát một lần rồi dừng
Lottie.asset(AppImages.successAnimation, repeat: false)

// Lặp vô hạn (loading)
Lottie.asset(
  AppImages.loadingAnimation,
  width: 100,
  height: 100,
  repeat: true,
)
```

---

## Logo theo theme (sáng / tối)

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;

Image.asset(
  isDark ? AppImages.logoDark : AppImages.logoLight,
  height: 48,
)
```

---

## Quy trình đổi logo (UI + App Icon)

Khi bạn muốn đổi logo toàn bộ app, làm theo đúng thứ tự sau:

### Bước 1: Chuẩn bị file logo gốc

- Đặt file logo mới tại: `assets/logo/logo.png`
- Khuyến nghị ảnh vuông (1024x1024) để generate app icon đẹp hơn.

### Bước 2: Cập nhật logo hiển thị trong UI

Dự án đang dùng các constant sau trong `AppImages`:
- `AppImages.logo` -> `assets/images/logo.png`
- `AppImages.logoLight` -> `assets/images/logo_light.png`
- `AppImages.logoDark` -> `assets/images/logo_dark.png`

Bạn chỉ cần thay 3 file này bằng logo mới:
- `assets/images/logo.png`
- `assets/images/logo_light.png`
- `assets/images/logo_dark.png`

Sau đó các màn đang dùng `AppLogoImage` sẽ tự nhận logo mới.

### Bước 3: Generate lại app icon Android / iOS / Web

Project đã cấu hình `flutter_launcher_icons` trong `pubspec.yaml` với nguồn:
- `image_path: assets/logo/logo.png`

Chạy lệnh:

```bash
flutter pub get
dart run flutter_launcher_icons
```

Lệnh này sẽ cập nhật icon launcher cho:
- Android
- iOS
- Web

### Bước 4: Verify nhanh

- Chạy app và kiểm tra logo ở Splash/Login.
- Build lại app và kiểm tra icon ngoài màn hình thiết bị.
- Nếu icon chưa đổi, clean rồi build lại:

```bash
flutter clean
flutter pub get
flutter run
```

### Ghi chú quan trọng

- iOS App Store không cho icon có alpha, project đã bật `remove_alpha_ios: true`.
- Không hardcode đường dẫn logo trong widget, luôn dùng qua `AppImages` hoặc `AppLogoImage`.

---

## Quy ước đặt tên file

| Loại | Prefix | Ví dụ |
|------|--------|-------|
| Ảnh chung | _(không có)_ | `banner.png`, `onboarding_1.png` |
| Icon | `ic_` | `ic_google.svg`, `ic_home.svg` |
| Lottie | _(tên trạng thái)_ | `loading.json`, `success.json` |
| Logo | `logo` | `logo.png`, `logo_dark.png` |

---

## Danh sách asset hiện có

### `assets/images/`

| Constant | File | Mô tả |
|----------|------|-------|
| `AppImages.logo` | `logo.png` | Logo chính |
| `AppImages.logoLight` | `logo_light.png` | Logo nền sáng |
| `AppImages.logoDark` | `logo_dark.png` | Logo nền tối |
| `AppImages.placeholder` | `placeholder.png` | Ảnh giữ chỗ |
| `AppImages.avatarPlaceholder` | `avatar_placeholder.png` | Avatar mặc định |
| `AppImages.onboarding1` | `onboarding_1.png` | Onboarding trang 1 |
| `AppImages.onboarding2` | `onboarding_2.png` | Onboarding trang 2 |
| `AppImages.onboarding3` | `onboarding_3.png` | Onboarding trang 3 |

### `assets/icons/`

| Constant | File | Mô tả |
|----------|------|-------|
| `AppImages.icGoogle` | `ic_google.svg` | Icon Google |
| `AppImages.icApple` | `ic_apple.svg` | Icon Apple |
| `AppImages.icFacebook` | `ic_facebook.svg` | Icon Facebook |

### `assets/animations/`

| Constant | File | Mô tả |
|----------|------|-------|
| `AppImages.loadingAnimation` | `loading.json` | Vòng xoay loading |
| `AppImages.successAnimation` | `success.json` | Thành công |
| `AppImages.errorAnimation` | `error.json` | Lỗi |
