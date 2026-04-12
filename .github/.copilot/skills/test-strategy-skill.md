# Skill: Chiến lược test cho Beacon

## Mục tiêu

Đảm bảo thay đổi được kiểm chứng đủ mạnh theo mức rủi ro.

## Khi dùng

- Thêm logic mới.
- Sửa bug quan trọng.
- Chạm vào auth/routing/network/state.

## Ma trận mức test

- Logic thuần: unit test.
- Tích hợp nhiều lớp: integration test hoặc verify flow thủ công có checklist.
- Luồng quan trọng (login/logout/navigation): ưu tiên kiểm tra hồi quy bắt buộc.

## Kịch bản tối thiểu

1. Happy path.
2. Error path (mất mạng, lỗi server, unauthorized).
3. Boundary input.
4. Regression lân cận.

## Verify bắt buộc

1. `flutter analyze`
2. `flutter test` nếu có test ảnh hưởng
3. Chạy manual flow liên quan trực tiếp

## Done khi

- Có bằng chứng rõ ràng cho các tiêu chí chấp nhận.
