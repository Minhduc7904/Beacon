---
name: ui-design-skill
description: "Use when: creating or updating Flutter UI while enforcing Beacon typography, color theme, icon system, layout, and shared widget conventions."
---

# Skill: UI Design Consistency cho Beacon

## Mục tiêu

Đảm bảo màn hình mới/được sửa tuân thủ typography, color theme, icon system, layout guide, component conventions và giữ trải nghiệm nhất quán trong toàn app.

## Khi dùng

- Tạo màn hình UI mới.
- Redesign màn hình cũ.
- Chỉnh sửa component liên quan đến theme, text, icon, button, input, layout.

## Đầu vào tối thiểu

1. User story/màn hình cần làm
2. Figma hoặc mô tả visual
3. Danh sách state UI quan trọng (loading, empty, error, success)
4. Icon cần dùng là icon phổ biến hay SVG custom export từ Figma
5. Có cần dark mode hay không

## Source of truth

1. `docs/theme.md`
2. `docs/text_theme.md`
3. `docs/shared_widgets.md`
4. `docs/assets.md`
5. `lib/core/theme/color/app_colors.dart`
6. `lib/core/theme/text/app_text_theme.dart`
7. `lib/core/theme/app/app_theme.dart`
8. `lib/core/theme/icons/app_icons.dart`
9. `lib/core/theme/icons/app_icon.dart`
10. `lib/core/widgets/`

## Quy trình thực thi

### 1) Map design với token hiện có

- Xác định token màu semantic (`colorScheme.primary`, `surface`, `onSurface`, ...).
- Xác định token typo từ `docs/text_theme.md`: title dùng `AppTextPreset.title1/title2/title3`; body/label dùng đủ `AppTextSize + AppTextSpacing + AppTextWeight`.
- Xác định icon có sẵn trong `AppIcons` hoặc cần thêm icon mới.
- Xác định component có sẵn có thể tái sử dụng.

### 2) Dùng text system thống nhất

- Page/screen ưu tiên render chữ bằng `AppText` từ `lib/core/widgets/text/text.dart`.
- Không hardcode `fontSize`, `fontWeight`, `height` trong page nếu style map được về token.
- Heading theo Figma dùng `AppText(preset: AppTextPreset.title1/title2/title3)`.
- Body/label theo Figma dùng `AppText(size: ..., spacing: ..., weight: ...)`.
- Reusable widget cần default `TextStyle` thì dùng `Theme.of(context).textTheme.ui(...)` và cho phép caller truyền `TextStyle?` khi cần.
- Chỉ dùng `Text(...)` trực tiếp khi viết reusable widget cần kiểm soát `TextStyle`, widget Material/platform, hoặc có lý do kỹ thuật rõ ràng.
- Khi text có thể dài, thêm `maxLines`, `overflow`, và kiểm tra không vỡ layout trên mobile nhỏ.
- Nếu cần override màu, dùng `color` của `AppText` hoặc `copyWith(color: ...)`; tránh override `fontWeight/style` nếu không có chỉ định thiết kế.

### 3) Dùng icon system thống nhất

- UI mới hoặc phần icon đang chạm tới dùng `AppIcon(AppIcons.xxx)` thay vì import trực tiếp `PhosphorIcons`, thêm mới `Icons.*`, hoặc hardcode path SVG.
- Icon phổ biến dùng Phosphor thông qua `AppIconData.phosphor(...)` trong `AppIcons`.
- Icon custom/branding export từ Figma dùng SVG thông qua `AppIconData.svg(...)` trong `AppIcons`.
- Không render SVG custom trong UI nếu asset chưa tồn tại trong `assets/icons/`; chỉ khai báo constant path trước nếu chưa dùng ngay.
- Khi cần size/color, truyền qua `AppIcon(size: ..., color: ...)`; với SVG, `AppIcon` tự áp `ColorFilter`.
- Nếu thêm icon mới, cập nhật `lib/core/theme/icons/app_icons.dart`; không thêm path SVG trực tiếp trong page/widget.

### 4) Ưu tiên shared widgets

- Kiểm tra `lib/core/widgets/` trước khi viết widget mới.
- Nếu phát sinh pattern lặp lại, đưa về core widget thay vì để trong feature.
- Với widget dùng icon, API nên nhận `AppIconData` nếu widget cần chọn icon linh hoạt; chỉ nhận `Widget` khi caller cần custom render hoàn toàn.
- Với widget dùng text, API nên nhận `String` + `TextStyle?`/`Color?` khi component có typography mặc định; chỉ nhận `Widget` khi caller cần custom render hoàn toàn.

### 5) Triển khai UI trong presentation layer

- Giữ logic nghiệp vụ ở notifier/usecase; page/widget chỉ render state.
- Side effects thông báo người dùng thông qua `appMessageProvider`.
- Bọc nội dung page bằng `AppScreenLayout` để bám layout guide, trừ khi page được yêu cầu full-bleed, camera/media preview, hoặc là demo/dev surface.
- Không hardcode route, endpoint, storage key, asset path hoặc icon library trực tiếp trong UI mới/phần đang sửa.

### 6) Tự review visual và consistency

- Soát hardcode style.
- Soát usage `Text(...)` trực tiếp trong page; đổi sang `AppText` nếu không có lý do rõ ràng.
- Soát hardcode icon/path.
- Soát contrast và trạng thái disabled/error.
- Soát spacing, radius, typography theo token.
- Soát responsive trên thiết bị Android thật nếu layout phụ thuộc width.

## Checklist verify UI trước merge

1. Không hardcode `Colors.*` trong page trừ khi có lý do rõ ràng.
2. Không hardcode `fontSize/fontWeight/height` nếu đã có token.
3. Màu chủ yếu dùng qua `Theme.of(context).colorScheme`.
4. Text trong page/screen chủ yếu dùng `AppText`; reusable widget dùng `Theme.of(context).textTheme.ui(...)` khi cần `TextStyle`.
5. Icon mới hoặc icon đang sửa dùng qua `AppIcon(AppIcons.xxx)`; không import trực tiếp `PhosphorIcons` trong screen/widget.
6. Không hardcode path SVG trong UI; path nằm trong `AppIcons` hoặc `AppImages` tùy loại asset.
7. Không render SVG chưa tồn tại trong `assets/icons/`.
8. Button/input/card/icon action ưu tiên dùng core widgets và theme chung.
9. Trạng thái loading/empty/error/success được render đầy đủ.
10. Kiểm tra màn hình trên mobile nhỏ, Android device thật nếu có thể, và màn hình rộng.
11. Kiểm tra light/dark mode nếu có ảnh hưởng đến contrast.
12. Không hardcode route/endpoint/storage key trong UI.
13. Chạy `flutter analyze` và verify tay flow liên quan khi môi trường cho phép.
14. Page body được bọc bởi `AppScreenLayout` nếu không thuộc ngoại lệ full-bleed/media/dev/demo.

## Done khi

- UI mới nhất quán với design system hiện tại.
- Không phát sinh style ad-hoc khó bảo trì.
- Không phát sinh icon import/path ad-hoc trong feature UI.
- Có bằng chứng verify theo checklist trước merge.
