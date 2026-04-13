# Theme Colors - AppColors & AppTheme

## Mục tiêu

Tài liệu này mô tả cách tổ chức và sử dụng hệ màu trong dự án Beacon App thông qua:
- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_theme.dart`

Mục tiêu chính là thống nhất giao diện, tránh hardcode màu, và giúp mở rộng nhanh khi đổi design system.

---

## 1) AppColors là gì?

`AppColors` là nơi chứa toàn bộ color tokens gốc của dự án.

### Cấu trúc màu hiện tại

1. Nhóm Ink (text/dark neutral)
- `ink100` -> `ink600`

2. Nhóm Sky (light neutral/background)
- `sky100` -> `sky600`

3. Nhóm Primary (Teal)
- `teal100` -> `teal500`

4. Nhóm Secondary (Coral)
- `coral100` -> `coral500`

5. Nhóm Status
- `success`, `warning`, `danger`

6. Nhóm Semantic tokens dùng cho ThemeData
- `primary`, `onPrimary`, `primaryContainer`, `onPrimaryContainer`
- `secondary`, `onSecondary`, `secondaryContainer`, `onSecondaryContainer`
- `background`, `onBackground`, `surface`, `onSurface`
- `error`, `onError`, `outline`, `shadow`

### Quy tắc sử dụng AppColors

- Chỉ chỉnh palette tại `app_colors.dart`.
- Ở UI nghiệp vụ, ưu tiên dùng `Theme.of(context).colorScheme` thay vì gọi trực tiếp `AppColors`.
- Dùng `AppColors` trực tiếp khi viết theme, style token, hoặc widget dùng chung cấp core.

---

## 2) AppTheme là gì?

`AppTheme` là lớp lắp ghép toàn bộ màu + typography + style component vào `ThemeData`.

Hiện tại có:
- `AppTheme.lightTheme({String fontFamily = AppFonts.defaultFamily})`

### Các phần đang được cấu hình trong AppTheme

1. `ColorScheme`
- Map semantic tokens từ `AppColors` vào Material color system.

2. `scaffoldBackgroundColor`
- Dùng `AppColors.background`.

3. `textTheme`
- Dùng từ `AppTextTheme.textTheme(...)` và apply màu text toàn cục.

4. `appBarTheme`
- Đồng bộ nền/sắc chữ của AppBar.

5. `cardTheme`
- Đồng bộ bo góc, viền, surface tint, shadow.

6. `inputDecorationTheme`
- Đồng bộ style viền/focus/fill cho input.

7. `filledButtonTheme`
- Đồng bộ chiều cao tối thiểu, shape, textStyle.

---

## 3) Cách áp dụng cho toàn app

Trong `main.dart`:

```dart
MaterialApp.router(
  theme: AppTheme.lightTheme(),
  routerConfig: appRouter,
)
```

Nếu muốn đổi font toàn app:

```dart
MaterialApp.router(
  theme: AppTheme.lightTheme(fontFamily: AppFonts.inter),
)
```

---

## 4) Cách dùng màu trong UI

### Dùng qua ColorScheme (khuyến nghị)

```dart
Container(
  color: Theme.of(context).colorScheme.primaryContainer,
  child: Text(
    'Beacon',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    ),
  ),
)
```

### Dùng màu trạng thái

```dart
Text(
  'Success',
  style: TextStyle(color: AppColors.success),
)
```

---

## 5) Cách mở rộng AppColors đúng chuẩn

Khi design bổ sung màu mới:

1. Thêm token vào nhóm phù hợp trong `app_colors.dart`.
2. Nếu màu này có vai trò semantic toàn app, map thêm trong phần semantic tokens.
3. Nếu cần ảnh hưởng Material components, cập nhật tiếp trong `app_theme.dart`.

Ví dụ:

```dart
// app_colors.dart
static const Color info = Color(0xFF3B82F6);
```

---

## 6) Cách mở rộng AppTheme đúng chuẩn

Khi cần style mới toàn app:

1. Thêm vào `ThemeData` trong `AppTheme.lightTheme(...)`.
2. Ưu tiên dùng token từ `AppColors` và `AppTextTheme`.
3. Không hardcode màu lặp lại trong từng page.

Ví dụ các khu vực thường mở rộng:
- `elevatedButtonTheme`
- `outlinedButtonTheme`
- `chipTheme`
- `dividerTheme`
- `snackBarTheme`

---

## 7) Checklist khi review code UI

- Có hardcode `Colors.xxx` trong page không?
- Có dùng `Theme.of(context).colorScheme` đúng ngữ nghĩa không?
- Component dùng chung có bám `ThemeData` không?
- Thay đổi màu đã đi qua `app_colors.dart` chưa?
- Thay đổi component style đã đi qua `app_theme.dart` chưa?

---

## 8) Tóm tắt

- `AppColors`: nguồn token màu duy nhất.
- `AppTheme`: nơi áp token vào Material theme và component theme.
- UI nên đọc từ `Theme.of(context)` để đảm bảo nhất quán và dễ scale.