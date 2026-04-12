# Skill: CI/CD và Automation

## Mục tiêu

Thiết lập hoặc cải tiến pipeline để phát hiện lỗi sớm và giảm rủi ro khi merge/release.

## Khi dùng

- Thiết kế CI mới.
- Bổ sung quality gate cho repo.
- Chuẩn hóa kiểm tra tự động.

## Quality gate tối thiểu đề xuất cho Beacon

1. `flutter pub get`
2. `flutter analyze`
3. `flutter test`
4. Build kiểm tra theo target chính của team

## Nguyên tắc

- Shift-left: bắt lỗi sớm ở PR.
- Fail-fast: pipeline dừng ngay khi gate fail.
- Feedback rõ: log lỗi đủ để sửa nhanh.

## Done khi

- Mọi PR đều qua gate tự động trước merge.
- Thời gian feedback đủ nhanh để dev sửa trong cùng vòng PR.
