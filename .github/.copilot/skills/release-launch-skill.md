# Skill: Release và Launch

## Mục tiêu

Đảm bảo phát hành an toàn, có kế hoạch rollback và theo dõi sau release.

## Khi dùng

- Chuẩn bị đưa thay đổi lên môi trường release.
- Có thay đổi ảnh hưởng luồng chính (auth/navigation/network).

## Checklist trước release

1. Verify đầy đủ flow trọng yếu.
2. Xác nhận không còn bug blocker đã biết.
3. Chuẩn bị ghi chú release (thay đổi, rủi ro, rollback).
4. Có người chịu trách nhiệm theo dõi sau release.

## Checklist sau release

1. Theo dõi lỗi runtime/log bất thường.
2. Xác nhận các flow chính hoạt động ổn định.
3. Kích hoạt rollback nếu có lỗi nghiêm trọng.

## Done khi

- Release ổn định trong khoảng theo dõi đã định.
- Không còn cảnh báo nghiêm trọng chưa xử lý.
