---
name: context-engineering-skill
description: "Use when: starting a task and loading Beacon source-of-truth context before writing code."
---

# Skill: Nạp đúng ngữ cảnh cho Agent

## Mục tiêu

Giúp agent luôn đọc đúng file nguồn sự thật trước khi sinh code.

## Khi dùng

- Bắt đầu phiên làm việc mới.
- Chuyển sang task khác.
- Kết quả agent bắt đầu lệch chuẩn dự án.

## Context bắt buộc cho Beacon

1. `.agents/copilot-instructions.md`
2. `.agents/instructions/project-context.md`
3. `.agents/instructions/architecture-rules.md`
4. `lib/core/providers/providers.dart`
5. `lib/core/config/app_routes.dart` + `lib/core/config/app_router.dart`
6. Các docs trong `docs/` liên quan task

## Quy tắc thực thi

- Nếu docs và code lệch nhau: ưu tiên code thực tế.
- Sau khi code xong: báo cáo rõ giả định và điểm lệch đã xử lý.

## Done khi

- Agent đưa ra thay đổi đúng chuẩn dự án ngay từ vòng đầu.
