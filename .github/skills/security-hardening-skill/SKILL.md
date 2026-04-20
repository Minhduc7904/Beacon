---
name: security-hardening-skill
description: "Use when: reviewing auth, token, storage, network, and logging changes for security risks and hardening."
---

# Skill: Security và Hardening

## Mục tiêu

Giảm rủi ro bảo mật ở các khu vực auth, storage, network và logging.

## Khi dùng

- Chạm vào login/logout/token/interceptor.
- Chạm vào dữ liệu nhạy cảm hoặc lưu trữ local.

## Checklist nhanh

1. Không log token, refresh token, thông tin nhạy cảm.
2. Validation input ở biên xử lý (usecase/API boundary).
3. Unauthorized flow rõ ràng, không nuốt lỗi nguy hiểm.
4. Không hardcode secret trong repo.
5. Review dependency mới trước khi thêm.

## Khu vực Beacon cần ưu tiên

- `features/auth/*`
- `core/network/interceptor.dart`
- `core/storage/*`
- `core/errors/*`

## Done khi

- Không có lỗ hổng nghiêm trọng dễ khai thác trong phạm vi thay đổi.
- Có khuyến nghị hardening nếu còn điểm nợ kỹ thuật.
