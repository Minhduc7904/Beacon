---
name: release-launch-skill
description: "Use when: preparing release readiness, launch checklists, monitoring plans, and rollback decisions."
---

# Skill: Release và Launch

## Mục tiêu

Đảm bảo phát hành an toàn, có kế hoạch rollback và theo dõi sau release.

## Khi dùng

- Chuẩn bị đưa thay đổi lên môi trường release.
- Có thay đổi ảnh hưởng luồng chính (auth/navigation/network).

## Đầu vào tối thiểu

1. Phạm vi thay đổi và rủi ro chính
2. Danh sách flow trọng yếu cần theo dõi sau release
3. Người chịu trách nhiệm theo dõi và quyết định rollback

## Checklist trước release

1. Verify đầy đủ flow trọng yếu.
2. Xác nhận không còn bug blocker đã biết.
3. Chuẩn bị ghi chú release (thay đổi, rủi ro, rollback).
4. Có người chịu trách nhiệm theo dõi sau release.

## Checklist sau release

1. Theo dõi lỗi runtime/log bất thường.
2. Xác nhận các flow chính hoạt động ổn định.
3. Kích hoạt rollback nếu có lỗi nghiêm trọng.

## Đầu ra kỳ vọng

1. Checklist trước/sau release đã được xác nhận đầy đủ
2. Release note ngắn gọn: thay đổi, rủi ro, rollback plan
3. Quy tắc kích hoạt rollback rõ điều kiện và người quyết định

## Stop-the-line criteria

- Login/logout lỗi trên diện rộng
- Flow navigation chính bị chặn
- Lỗi dữ liệu hoặc crash lặp lại ở flow core

## Done khi

- Release ổn định trong khoảng theo dõi đã định.
- Không còn cảnh báo nghiêm trọng chưa xử lý.
