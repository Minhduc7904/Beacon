---
description: "Use when: implementing or updating Flutter UI screens to enforce Beacon font, color, component, and theming conventions."
applyTo: "lib/**/presentation/**/*.dart"
---

# Quy tắc Thiết kế UI - Beacon

## Mục tiêu

Giữ giao diện nhất quán theo design system hiện tại của Beacon, tránh hardcode style và giảm sai lệch giữa các màn hình.

## Source of truth

1. `docs/theme.md`
2. `docs/text_theme.md`
3. `docs/shared_widgets.md`
4. `lib/core/theme/color/app_colors.dart`
5. `lib/core/theme/text/app_text_theme.dart`
6. `lib/core/theme/app/app_theme.dart`
7. `lib/core/widgets/`

## Quy tắc bắt buộc

1. Không hardcode `Colors.*`, `fontSize`, `fontWeight`, `height` trong page nếu đã có token từ theme.
2. Ưu tiên dùng `Theme.of(context).colorScheme` cho màu semantic.
3. Ưu tiên dùng `Theme.of(context).textTheme` (`title1/title2/title3`, `ui(...)`) cho typography.
4. Ưu tiên tái sử dụng shared widgets trong `lib/core/widgets/` trước khi tạo widget mới theo feature.
5. Không tạo style button/input riêng nếu đã có style toàn cục trong `AppTheme` hoặc core widget.
6. Đường dẫn asset phải dùng constants, không hardcode path.
7. UI mới phải kiểm tra light/dark mode nếu màn hình có nguy cơ contrast thấp.

## Quy trình nhanh cho task UI

1. Xác định token cần dùng (màu, text, spacing, border radius).
2. Map token vào component từ theme/shared widget.
3. Triển khai màn hình theo feature presentation layer.
4. Tự review theo checklist UI trước khi merge.

## Không được làm

- Hardcode giá trị style lặp lại ở nhiều file.
- Tạo design language riêng trong một feature.
- Bypass theme chung bằng cách dùng style ad-hoc nếu không có lý do rõ ràng.
