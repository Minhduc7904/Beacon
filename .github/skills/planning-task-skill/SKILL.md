---
name: planning-task-skill
description: "Use when: splitting medium or large tasks into small executable slices with verification checkpoints."
---

# Skill: Lập kế hoạch và chia task

## Mục tiêu

Chia thay đổi thành các bước nhỏ, có thứ tự phụ thuộc rõ ràng, dễ review và rollback.

## Khi dùng

- Task trung bình/lớn.
- Task có thay đổi nhiều lớp (UI + usecase + repository + datasource).

## Quy trình

1. Liệt kê đầu ra cuối cùng của task.
2. Tách thành các lát cắt dọc có thể chạy được.
3. Gắn tiêu chí hoàn thành cho từng lát cắt.
4. Ước lượng rủi ro và điểm kiểm tra sau mỗi bước.

## Kích thước thay đổi khuyến nghị

- Mỗi PR nên tập trung một mục tiêu chính.
- Tránh trộn refactor không liên quan vào PR tính năng.

## Done khi

- Kế hoạch có thứ tự thực thi rõ.
- Mỗi bước có cách verify cụ thể.
