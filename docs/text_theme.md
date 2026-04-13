# Text Theme - Beacon App

## Mục tiêu

Tài liệu này mô tả hệ thống typography hiện tại trong dự án và cách sử dụng đúng chuẩn để đảm bảo UI nhất quán với thiết kế.

Nguồn code chính:
- `lib/core/theme/app_text_theme.dart`
- `lib/core/theme/app_fonts.dart`

---

## 1) Kiến trúc typography

Hệ text được tách thành 2 lớp:

1. Title presets
- `title1`: 48 / 700 / 1.17
- `title2`: 32 / 700 / 1.13
- `title3`: 24 / 700 / 1.33

2. Token generator theo ma trận 3 chiều
- Size: `large`, `regular`, `small`, `tiny`, `veryTiny`
- Spacing (theo Figma line-height): `none`, `tight`, `normal`
- Weight: `bold`, `medium`, `regular`

Hàm trung tâm:

```dart
AppTextTheme.style(
  size: AppTextSize.large,
  spacing: AppTextSpacing.tight,
  weight: AppTextWeight.bold,
)
```

---

## 2) Font family dùng chung

Font được lấy từ `AppFonts.defaultFamily` trong `app_fonts.dart`.

Hiện tại:
- `defaultFamily = Inter`

Đổi font toàn app:
1. Cập nhật `AppFonts.defaultFamily`.
2. Hoặc truyền `fontFamily` vào `AppTheme.lightTheme(fontFamily: ...)`.

---

## 3) Ma trận line-height theo Figma

Lưu ý: `none/tight/normal` trong dự án đang đại diện cho **line-height token**, không phải letter-spacing.

Bảng line-height px theo size:

| Size | none | tight | normal |
|------|------|-------|--------|
| large (18) | 18 | 20 | 24 |
| regular (16) | 16 | 20 | 24 |
| small (14) | 14 | 16 | 20 |
| tiny (12) | 12 | 14 | 16 |
| veryTiny (10) | 10 | 12 | 14 |

Trong Flutter, `TextStyle.height` là tỉ lệ, nên code đang quy đổi:

```dart
height = lineHeightPx / fontSize
```

---

## 4) Cách dùng trong UI

### A. Dùng title preset

```dart
Text(
  'Dashboard',
  style: Theme.of(context).textTheme.title1,
)
```

Các preset có sẵn:
- `Theme.of(context).textTheme.title1`
- `Theme.of(context).textTheme.title2`
- `Theme.of(context).textTheme.title3`

### B. Dùng token 3 chiều

```dart
Text(
  'Mô tả',
  style: Theme.of(context).textTheme.ui(
    size: AppTextSize.small,
    spacing: AppTextSpacing.normal,
    weight: AppTextWeight.regular,
  ),
)
```

### C. Override nhẹ khi cần

```dart
Text(
  'Nhãn',
  style: Theme.of(context).textTheme.ui(
    size: AppTextSize.tiny,
    spacing: AppTextSpacing.tight,
    weight: AppTextWeight.medium,
  ).copyWith(
    color: Theme.of(context).colorScheme.primary,
  ),
)
```

---

## 5) Mapping mặc định vào TextTheme

Trong `AppTextTheme.textTheme(...)`, một số slot Material đã được map sẵn:
- `titleLarge`
- `titleMedium`
- `bodyLarge`
- `bodyMedium`
- `bodySmall`
- `labelLarge`
- `labelMedium`
- `labelSmall`

Ngoài ra, title presets được map vào:
- `displayMedium` -> `title1`
- `headlineLarge` -> `title2`
- `headlineSmall` -> `title3`

---

## 6) Quy ước sử dụng trong team

- Không hardcode `fontSize`, `fontWeight`, `height` trực tiếp trong page trừ trường hợp đặc biệt.
- Ưu tiên `textTheme.title1/title2/title3` cho heading.
- Ưu tiên `textTheme.ui(...)` cho body/label theo token.
- Nếu phát sinh style mới lặp lại nhiều nơi, thêm vào `AppTextTheme` thay vì copy/paste.

---

## 7) Ví dụ nhanh theo nhu cầu phổ biến

1. Heading chính:

```dart
style: Theme.of(context).textTheme.title1
```

2. Nội dung đoạn văn:

```dart
style: Theme.of(context).textTheme.ui(
  size: AppTextSize.regular,
  spacing: AppTextSpacing.normal,
  weight: AppTextWeight.regular,
)
```

3. Caption nhỏ:

```dart
style: Theme.of(context).textTheme.ui(
  size: AppTextSize.veryTiny,
  spacing: AppTextSpacing.tight,
  weight: AppTextWeight.medium,
)
```

---

## 8) Checklist khi review UI

- Đã dùng token typography chưa?
- Line-height có đúng token Figma không?
- Font family có lấy từ `AppFonts` không?
- Có style nào bị hardcode có thể quy chuẩn hóa lại không?
