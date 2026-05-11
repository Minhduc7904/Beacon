# Text Theme - Beacon App

## Mục tiêu

Tài liệu này mô tả typography system hiện tại của Beacon và cách dùng đúng chuẩn để UI nhất quán với Figma/design system.

Nguồn code chính:
- `lib/core/theme/text/app_text_theme.dart`
- `lib/core/theme/text/app_fonts.dart`
- `lib/core/widgets/text/text.dart`
- `lib/core/theme/app/app_theme.dart`

---

## 1) Kiến trúc typography

Typography được chia thành 3 phần:

1. Title presets
- `title1`: `48 / 700 / 56`
- `title2`: `32 / 700 / 36`
- `title3`: `24 / 700 / 32`

2. Token generator theo ma trận 3 chiều
- Size: `large`, `regular`, `small`, `tiny`, `veryTiny`
- Spacing: `none`, `tight`, `normal`
- Weight: `bold`, `medium`, `regular`

3. UI wrapper
- `AppText` là widget text dùng chung cho page/screen.
- `Theme.of(context).textTheme.ui(...)` dùng để lấy `TextStyle` theo token, đặc biệt hữu ích trong reusable widget.

---

## 2) Font family

Font mặc định lấy từ `AppFonts.defaultFamily`.

Hiện tại:

```dart
AppFonts.defaultFamily = AppFonts.inter
```

`AppFonts.resolveTextTheme(...)` dùng `GoogleFonts.getTextTheme(...)` để áp font family vào `TextTheme`.

Lưu ý:
- `AppFonts.sfPro` hiện được fallback sang `Inter`.
- Nếu cần đổi font toàn app, truyền `fontFamily` vào `AppTheme.lightTheme(...)` / `AppTheme.darkTheme(...)` hoặc cập nhật `AppFonts.defaultFamily`.

---

## 3) Title styles

Trong Figma, title được định nghĩa theo dạng:

```text
fontSize / lineHeight
```

Flutter `TextStyle.height` không nhận line height px trực tiếp, mà nhận tỉ lệ:

```dart
height = lineHeightPx / fontSize
```

Mapping hiện tại:

| Token | Font size | Font weight | Line height px | Flutter height |
|---|---:|---:|---:|---:|
| `title1` | 48 | 700 | 56 | `56 / 48` |
| `title2` | 32 | 700 | 36 | `36 / 32` |
| `title3` | 24 | 700 | 32 | `32 / 24` |

Title presets được map vào `TextTheme` như sau:

| App token | TextTheme slot |
|---|---|
| `title1` | `displayMedium` |
| `title2` | `headlineLarge` |
| `title3` | `headlineSmall` |

Extension getter:

```dart
Theme.of(context).textTheme.title1
Theme.of(context).textTheme.title2
Theme.of(context).textTheme.title3
```

---

## 4) Body text matrix

`none/tight/normal` trong dự án là line-height token, không phải letter spacing.

Mỗi tổ hợp dưới đây có 3 weight:
- `bold` = `FontWeight.w700`
- `medium` = `FontWeight.w500`
- `regular` = `FontWeight.w400`

| Size token | Font size | None | Tight | Normal |
|---|---:|---:|---:|---:|
| `large` | 18 | 18 | 20 | 24 |
| `regular` | 16 | 16 | 20 | 24 |
| `small` | 14 | 14 | 16 | 20 |
| `tiny` | 12 | 12 | 14 | 16 |
| `veryTiny` | 10 | 10 | 12 | 14 |

Tổng số body text token có thể tạo:

```text
5 sizes x 3 spacings x 3 weights = 45 styles
```

Hàm trung tâm:

```dart
AppTextTheme.style(
  size: AppTextSize.regular,
  spacing: AppTextSpacing.normal,
  weight: AppTextWeight.regular,
)
```

`AppTextTheme.style(...)` tự quy đổi line height px sang Flutter height:

```dart
height = lineHeightPx / fontSize
```

---

## 5) AppText

`AppText` là wrapper chính nên dùng trong page/screen thay cho `Text` trực tiếp khi text thuộc design system.

### Dùng preset

```dart
AppText(
  'Hồ sơ',
  preset: AppTextPreset.title2,
)
```

### Dùng token 3 chiều

```dart
AppText(
  'Thông tin cá nhân',
  size: AppTextSize.regular,
  spacing: AppTextSpacing.none,
  weight: AppTextWeight.medium,
)
```

### Override màu, căn lề, maxLines

```dart
AppText(
  'Mô tả',
  size: AppTextSize.small,
  spacing: AppTextSpacing.normal,
  weight: AppTextWeight.regular,
  color: AppColors.ink500,
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

### Thứ tự resolve style trong AppText

1. Nếu có `preset`, dùng `AppTextPreset`.
2. Nếu có đủ `size`, `spacing`, `weight`, dùng `textTheme.ui(...)`.
3. Nếu không có gì, fallback về `Theme.of(context).textTheme.bodyMedium`.
4. Nếu có `color`, `fontWeight`, `style`, merge override sau cùng.

Lưu ý:
- Không truyền cả `preset` và `size/spacing/weight` cho cùng một `AppText`; `preset` sẽ được ưu tiên.
- Chỉ dùng `fontWeight` hoặc `style` override khi có lý do rõ ràng từ design, vì có thể bypass token.

---

## 6) AppTextPreset

Các preset hiện có:

| Preset | Mapping |
|---|---|
| `title1` | `textTheme.title1` |
| `title2` | `textTheme.title2` |
| `title3` | `textTheme.title3` |
| `titleLarge` | `textTheme.titleLarge` |
| `titleMedium` | `textTheme.titleMedium` |
| `bodyLarge` | `textTheme.bodyLarge` |
| `bodyMedium` | `textTheme.bodyMedium` |
| `bodySmall` | `textTheme.bodySmall` |
| `labelLarge` | `textTheme.labelLarge` |
| `labelMedium` | `textTheme.labelMedium` |
| `labelSmall` | `textTheme.labelSmall` |

---

## 7) Mapping mặc định vào Material TextTheme

`AppTextTheme.textTheme(...)` map một số token vào slot Material để các widget Material và reusable widget dùng được theme chung.

| TextTheme slot | Token |
|---|---|
| `displayMedium` | `title1` |
| `headlineLarge` | `title2` |
| `headlineSmall` | `title3` |
| `titleLarge` | `large / none / bold` |
| `titleMedium` | `regular / none / medium` |
| `bodyLarge` | `regular / normal / regular` |
| `bodyMedium` | `small / none / regular` |
| `bodySmall` | `tiny / none / regular` |
| `labelLarge` | `small / tight / bold` |
| `labelMedium` | `tiny / none / medium` |
| `labelSmall` | `veryTiny / normal / regular` |

---

## 8) Dùng TextStyle trong reusable widget

Trong page/screen, ưu tiên `AppText`.

Trong reusable widget, nếu widget cần nhận `TextStyle?` từ bên ngoài và có default style, dùng `Theme.of(context).textTheme.ui(...)`.

Ví dụ:

```dart
class ExampleTile extends StatelessWidget {
  const ExampleTile({
    super.key,
    required this.title,
    this.textStyle,
  });

  final String title;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final resolvedTextStyle =
        textStyle ??
        Theme.of(context).textTheme.ui(
          size: AppTextSize.regular,
          spacing: AppTextSpacing.none,
          weight: AppTextWeight.medium,
        );

    return Text(title, style: resolvedTextStyle);
  }
}
```

---

## 9) Khi nào dùng Text trực tiếp

Dùng `Text` trực tiếp khi:
- Đang viết reusable widget cần kiểm soát `TextStyle` chính xác.
- Đang custom widget nền tảng hoặc integration với widget Material.
- Text không thuộc design system và có lý do kỹ thuật rõ ràng.

Nếu chỉ render text trong UI thông thường, dùng `AppText`.

---

## 10) Quy ước sử dụng

- Không hardcode `fontSize`, `fontWeight`, `height` trực tiếp trong page nếu token đã có.
- Page/screen ưu tiên `AppText`.
- Reusable widget có default style nên dùng `Theme.of(context).textTheme.ui(...)`.
- Heading dùng `AppTextPreset.title1/title2/title3` hoặc `textTheme.title1/title2/title3` khi cần `TextStyle`.
- Body/label dùng đủ bộ `size + spacing + weight`.
- Không dùng `TextStyle(fontSize: ...)` rải rác nếu có thể map được về token.
- Nếu phát sinh style mới lặp lại nhiều nơi, cân nhắc thêm token/preset trong `AppTextTheme` hoặc `AppTextPreset`.

---

## 11) Ví dụ nhanh

Heading chính:

```dart
AppText(
  'Beacon',
  preset: AppTextPreset.title1,
)
```

Section title:

```dart
AppText(
  'Cá nhân',
  size: AppTextSize.regular,
  spacing: AppTextSpacing.none,
  weight: AppTextWeight.bold,
)
```

List tile title:

```dart
AppText(
  'Thông tin cá nhân',
  size: AppTextSize.regular,
  spacing: AppTextSpacing.none,
  weight: AppTextWeight.medium,
)
```

Paragraph:

```dart
AppText(
  'Nội dung mô tả dài hơn.',
  size: AppTextSize.regular,
  spacing: AppTextSpacing.normal,
  weight: AppTextWeight.regular,
)
```

Caption:

```dart
AppText(
  'Cập nhật gần đây',
  size: AppTextSize.tiny,
  spacing: AppTextSpacing.tight,
  weight: AppTextWeight.medium,
)
```

---

## 12) Checklist review UI

- Text trong page/screen đã dùng `AppText` chưa?
- Reusable widget có default typography từ token chưa?
- Line height có đúng Figma token không?
- Có hardcode `fontSize/fontWeight/height` không cần thiết không?
- Có override `style` hoặc `fontWeight` làm lệch token không?
- Font family có đi qua `AppFonts` / `AppTheme` không?
- Text dài có `maxLines` và `overflow` khi cần không?
