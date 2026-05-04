---
name: ui-design-skill
description: "Use when: creating or updating Flutter UI while enforcing Beacon typography, color theme, and shared widget conventions."
---

# Skill: UI Design Consistency cho Beacon

## Mục tiêu

Đảm bảo màn hình mới/được sửa tuân thủ font, color theme, component conventions và giữ trải nghiệm nhất quán trong toàn app.

## Khi dùng

- Tạo màn hình UI mới.
- Redesign màn hình cũ.
- Chỉnh sửa nhiều component liên quan đến theme, text, button, input.

## Đầu vào tối thiểu

1. User story/màn hình cần làm
2. Figma hoặc mô tả visual
3. Danh sách state UI quan trọng (loading, empty, error, success)
4. Có cần dark mode hay không

## Source of truth

1. `docs/theme.md`
2. `docs/text_theme.md`
3. `docs/shared_widgets.md`
4. `lib/core/theme/color/app_colors.dart`
5. `lib/core/theme/text/app_text_theme.dart`
6. `lib/core/theme/app/app_theme.dart`
7. `lib/core/widgets/`

## Quy trình thực thi

### 1) Map design với token hiện có

- Xác định token màu semantic (`colorScheme.primary`, `surface`, `onSurface`, ...).
- Xác định token typo (`title1/title2/title3`, `ui(...)`).
- Xác định component có sẵn có thể tái sử dụng.

### 2) Ưu tiên shared widgets

- Kiểm tra `lib/core/widgets/` trước khi viết widget mới.
- Nếu phát sinh pattern lặp lại, đưa về core widget thay vì để trong feature.

### 3) Triển khai UI trong presentation layer

- Giữ logic nghiệp vụ ở notifier/usecase; page/widget chỉ render state.
- Side effects thông báo người dùng thông qua `appMessageProvider`.
- Bọc nội dung page bằng `AppScreenLayout` để bám layout guide (trừ khi page được yêu cầu full-bleed hoặc demo như shared_widgets).

### 4) Tự review visual và consistency

- Soát hardcode style.
- Soát contrast và trạng thái disabled/error.
- Soát spacing, radius, typography theo token.

## Checklist verify UI trước merge

1. Không hardcode `Colors.*` trong page trừ khi có lý do rõ ràng.
2. Không hardcode `fontSize/fontWeight/height` nếu đã có token.
3. Màu chủ yếu dùng qua `Theme.of(context).colorScheme`.
4. Typography chủ yếu dùng qua `Theme.of(context).textTheme`.
5. Button/input/card ưu tiên dùng core widgets và theme chung.
6. Trạng thái loading/empty/error/success được render đầy đủ.
7. Kiểm tra màn hình trên mobile nhỏ và màn hình rộng.
8. Kiểm tra light/dark mode nếu có ảnh hưởng đến contrast.
9. Không hardcode route/endpoint/storage key trong UI.
10. Chạy `flutter analyze` và verify tay flow liên quan.
11. Page body được bọc bởi `AppScreenLayout` (trừ khi được chỉ định ngoại lệ).

## Done khi

- UI mới nhất quán với design system hiện tại.
- Không phát sinh style ad-hoc khó bảo trì.
- Có bằng chứng verify theo checklist trước merge.
