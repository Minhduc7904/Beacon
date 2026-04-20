# Shared Widgets - Cách tạo và cách dùng

## Mục tiêu

Tài liệu này hướng dẫn chuẩn hoá cách xây dựng và sử dụng widget dùng chung trong dự án Beacon App.

Áp dụng cho nhóm widget trong:

- `lib/core/widgets/`

---

## 1) Nguyên tắc thiết kế shared widget

1. Dùng cho phần giao diện lặp lại ở nhiều feature.
2. Không chứa business logic theo feature.
3. Ưu tiên đọc style từ Theme (màu, typography, shape).
4. API rõ ràng qua constructor params, có giá trị mặc định hợp lý.
5. Tên class và file dễ tìm: `Button`, `Input`, `AppText`, `AppImage`, `AppLogoImage`.

---

## 2) Cấu trúc thư mục đề xuất

```text
lib/core/widgets/
├── button/
│   └── button.dart
├── card/
│   └── card.dart
├── dropdown/
│   └── dropdown.dart
├── image/
│   ├── image.dart
│   └── logo_image.dart
├── input/
│   └── input.dart
├── text/
│   └── text.dart
├── auth_guard.dart
```

Quy ước:
- Mỗi loại widget nằm trong 1 thư mục riêng.
- File chính trùng với tên loại widget để import rõ ràng.

---

## 3) Cách tạo shared widget mới

### Bước 1: Xác định widget có đủ điều kiện dùng chung

Widget nên đưa vào `core/widgets` khi:
- Dùng lại từ 2 màn hình trở lên.
- Chỉ phụ thuộc UI và theme.
- Có các biến thể dễ tái sử dụng bằng params.

### Bước 2: Tạo file trong `core/widgets/<type>/`

Ví dụ:

```dart
import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final String text;
  final Color? color;

  const AppBadge({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? c.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
```

### Bước 3: Dùng thử ở 1 màn hình thực tế

- Import widget vào page feature.
- Thay widget cũ bằng widget mới.
- Kiểm tra compile và UI.

---

## 4) Cách dùng các shared widget hiện có

## 4.1 Button

File: `lib/core/widgets/button/button.dart`

Mục đích:
- Bọc `FilledButton` với hệ type/state/size chuẩn hoá.

Hỗ trợ hiện tại:
- `ButtonMode`: `light`, `dark`
- `ButtonType`: `primary`, `secondary`, `outline`, `transparent`
- `ButtonSize`: `block`, `large`, `small`
- `ButtonState`: `defaultState`, `disabled`
- `ButtonIconPosition`: `side`, `left`, `right`

Ví dụ:

```dart
Button(
  text: 'Xác nhận',
  onPressed: onSubmit,
)

Button(
  text: 'Tiếp tục với Google',
  icon: const Icon(Icons.login),
  onPressed: onLoginGoogle,
)

Button(
  text: 'Huỷ',
  type: ButtonType.outline,
  size: ButtonSize.small,
  onPressed: onCancel,
)
```

---

## 4.2 Input

File: `lib/core/widgets/input/input.dart`

Mục đích:
- Chuẩn hoá text input theo theme.

Ví dụ:

```dart
Input(
  labelText: 'Username',
  hintText: 'Nhập username',
  controller: usernameController,
  onChanged: (v) {},
)

Input(
  labelText: 'Password',
  obscureText: true,
)
```

---

## 4.3 Card

File: `lib/core/widgets/card/card.dart`

Mục đích:
- Card trình bày block thông tin có `title`, `description`, `child`.

Ví dụ:

```dart
Card(
  title: 'Thông tin',
  description: 'Mô tả ngắn',
  child: const Text('Nội dung'),
)
```

Lưu ý:
- Đây là custom widget tên `Card`, có thể trùng tên với Flutter `Card`.
- Khi cần, dùng import alias hoặc hide để tránh nhầm.

---

## 4.4 AppDropdown

File: `lib/core/widgets/dropdown/dropdown.dart`

Mục đích:
- Dropdown custom dùng chung, đọc màu từ theme và hỗ trợ validator như form field.

Ví dụ:

```dart
AppDropdown<String>(
  labelText: 'Danh mục',
  hintText: 'Chọn danh mục',
  value: selectedCategory,
  items: const [
    AppDropdownItem(value: 'news', label: 'Tin tức'),
    AppDropdownItem(value: 'event', label: 'Sự kiện'),
  ],
  onChanged: (value) => setState(() => selectedCategory = value),
)
```

---

## 4.5 AppImage

File: `lib/core/widgets/image/image.dart`

Mục đích:
- Chuẩn hoá hiển thị ảnh từ `ImageProvider` với nhiều option.

Ví dụ:

```dart
AppImage(
  image: const AssetImage(AppImages.logo),
  width: 120,
  height: 120,
  fit: BoxFit.contain,
)

AppImage(
  image: NetworkImage(url),
  width: 48,
  height: 48,
  shape: BoxShape.circle,
)
```

---

## 4.6 AppLogoImage

File: `lib/core/widgets/image/logo_image.dart`

Mục đích:
- Widget chuyên hiển thị logo app, tự chọn light/dark theo theme.

Ví dụ:

```dart
const AppLogoImage(
  width: 92,
  height: 92,
)
```

Tuỳ chỉnh:

```dart
const AppLogoImage(
  width: 120,
  height: 120,
  useThemeVariant: false,
)
```

---

## 4.7 AppText

File: `lib/core/widgets/text/text.dart`

Mục đích:
- Text dùng chung theo hệ typography token trong `AppTextTheme`.

Hỗ trợ 2 mode:
1. Preset mode:

```dart
const AppText(
  'Đăng nhập',
  preset: AppTextPreset.title2,
)
```

2. Token mode:

```dart
const AppText(
  'Mô tả',
  size: AppTextSize.small,
  spacing: AppTextSpacing.normal,
  weight: AppTextWeight.regular,
)
```

Override nhanh:

```dart
AppText(
  'Sub text',
  preset: AppTextPreset.bodyMedium,
  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65),
)
```

---

## 5) Chuẩn sử dụng trong feature page

1. Không hardcode style lặp lại nếu đã có shared widget tương đương.
2. Ưu tiên:
- Logo -> `AppLogoImage`
- Text theo design system -> `AppText`
- Input chuẩn form -> `Input`
- Nút hành động chính -> `Button`
3. Chỉ fallback về widget gốc Flutter nếu use-case đặc biệt.

---

## 6) Checklist trước khi merge

- Widget mới có default params hợp lý chưa?
- Có đọc màu/chữ từ theme chưa?
- Có ví dụ dùng thực tế ở ít nhất 1 màn không?
- Có trùng tên dễ gây nhầm với widget Flutter không?
- Đã kiểm tra compile sau khi thay thế chưa?

---

## 7) Tóm tắt nhanh

- Shared widgets nằm ở `lib/core/widgets`.
- Mỗi loại widget 1 thư mục riêng.
- Thiết kế API đơn giản, bám theme, dễ tái sử dụng.
- Ưu tiên dùng shared widget trong feature để giữ UI nhất quán.