---
name: ci-cd-skill
description: "Use when: designing or updating CI/CD pipelines, quality gates, and automated checks for Beacon."
---

# Skill: CI/CD và Automation

## Mục tiêu

Thiết lập hoặc cải tiến pipeline để phát hiện lỗi sớm và giảm rủi ro khi merge/release.

## Khi dùng

- Thiết kế CI mới.
- Bổ sung quality gate cho repo.
- Chuẩn hóa kiểm tra tự động.

## Đầu vào tối thiểu

1. Nền tảng CI đang dùng (GitHub Actions/GitLab CI/...)
2. Nhánh áp dụng gate (PR vào main/release)
3. Mục tiêu thời gian phản hồi tối đa cho một pipeline run
4. Target build chính cần xác thực

## Quality gate tối thiểu đề xuất cho Beacon

1. `flutter pub get`
2. `flutter analyze`
3. `flutter test`
4. Build kiểm tra theo target chính của team

## Nguyên tắc

- Shift-left: bắt lỗi sớm ở PR.
- Fail-fast: pipeline dừng ngay khi gate fail.
- Feedback rõ: log lỗi đủ để sửa nhanh.

## Đầu ra kỳ vọng

1. Pipeline định nghĩa rõ các stage/check bắt buộc
2. Có rule chặn merge khi quality gate fail
3. Log lỗi đủ ngữ cảnh để dev sửa nhanh trong cùng vòng PR

## Verify bắt buộc

1. Chạy thử 1 PR pass và 1 PR fail để xác nhận gate hoạt động
2. Xác nhận thứ tự fail-fast đúng (analyze/test fail thì dừng)
3. Đo thời gian phản hồi thực tế và so với mục tiêu

## Done khi

- Mọi PR đều qua gate tự động trước merge.
- Thời gian feedback đủ nhanh để dev sửa trong cùng vòng PR.
