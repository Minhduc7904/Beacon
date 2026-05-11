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

## Quy tắc màu chữ

1. Heading/page title dùng `AppColors.ink600` hoặc `colorScheme.onSurface`.
2. Section title, item title, body chính dùng `AppColors.ink500` hoặc `colorScheme.onSurface`.
3. Subtitle, mô tả, helper text, timestamp dùng `AppColors.ink100` hoặc `colorScheme.onSurface.withValues(alpha: 0.55-0.72)`.
4. Disabled/placeholder-like text dùng `AppColors.sky600` hoặc disabled token của component.
5. Text trên nền tối/primary/accent dùng `AppColors.sky100`, `colorScheme.onPrimary`, hoặc `colorScheme.onSecondary`.
6. Link/action text dùng `AppColors.teal500` hoặc `colorScheme.primary`.
7. Accent/fun highlight dùng `AppColors.coral500` hoặc `colorScheme.secondary`, dùng tiết chế.
8. Error text dùng `AppColors.red500` hoặc `colorScheme.error`; success text dùng `AppColors.success`.
9. Tránh dùng `AppColors.ink300/ink400` cho text mới nếu không có lý do thiết kế rõ, vì dễ tạo cấp bậc lửng giữa body và muted.

## Quy trình nhanh cho task UI

1. Xác định token cần dùng (màu, text, spacing, border radius).
2. Map token vào component từ theme/shared widget.
3. Triển khai màn hình theo feature presentation layer.
4. Tự review theo checklist UI trước khi merge.

## Không được làm

- Hardcode giá trị style lặp lại ở nhiều file.
- Tạo design language riêng trong một feature.
- Bypass theme chung bằng cách dùng style ad-hoc nếu không có lý do rõ ràng.
