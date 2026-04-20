---
name: documentation-adr-skill
description: "Use when: documenting architecture decisions, tradeoffs, impacts, and rollback guidance after important changes."
---

# Skill: Documentation và ADR

## Mục tiêu

Ghi lại quyết định kiến trúc và thay đổi quan trọng để người mới có thể theo kịp nhanh.

## Khi dùng

- Có thay đổi kiến trúc, contract API, flow quan trọng.
- Có quyết định kỹ thuật ảnh hưởng nhiều feature.

## Nội dung cần ghi

1. Vấn đề ban đầu.
2. Các lựa chọn đã cân nhắc.
3. Quyết định cuối cùng và lý do.
4. Ảnh hưởng lên code hiện tại.
5. Cách rollback nếu cần.

## Vị trí ưu tiên cập nhật

- `docs/` cho hướng dẫn vận hành.
- `.github/instructions/*` nếu thay đổi quy tắc cho agent.

## Done khi

- Tài liệu đủ để dev mới hiểu và tiếp tục triển khai.
