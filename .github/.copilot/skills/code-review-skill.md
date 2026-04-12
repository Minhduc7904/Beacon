# Skill: Code Review và Quality Gate

## Mục tiêu

Thiết lập quality gate nhất quán trước khi merge.

## Khi dùng

- Mọi PR trước merge.
- Đặc biệt khi thay đổi auth/network/router/providers.

## Trục review bắt buộc

1. Đúng yêu cầu nghiệp vụ.
2. Đúng kiến trúc và dependency direction.
3. Dễ đọc, dễ bảo trì.
4. Error handling và edge cases.
5. Rủi ro bảo mật/hiệu năng.

## Phân loại nhận xét

- Critical: bắt buộc sửa.
- Important: nên sửa trước merge.
- Suggestion: cải tiến tùy chọn.

## Quy tắc Beacon

- Không approve nếu còn hardcode route/endpoint/storage key.
- Không approve nếu bỏ qua verify tối thiểu (`flutter analyze`).

## Done khi

- Không còn Critical.
- Người review và người sửa thống nhất phạm vi còn lại.
