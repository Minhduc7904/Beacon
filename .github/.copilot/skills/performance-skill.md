# Skill: Performance Optimization

## Mục tiêu

Tối ưu hiệu năng dựa trên đo lường, không tối ưu cảm tính.

## Khi dùng

- UI giật, drop frame.
- Request/network chậm hoặc gọi dư thừa.
- Build/rebuild quá nhiều do state management.

## Quy trình

1. Đo và xác định điểm nghẽn trước.
2. Tối ưu đúng điểm nghẽn.
3. Đo lại để xác nhận cải thiện.

## Heuristics cho Beacon

- Kiểm tra `ref.watch` quá rộng gây rebuild không cần thiết.
- Tránh gọi API lặp không cần cache/điều kiện.
- Tối ưu widget tree ở màn có nhiều thành phần động.

## Done khi

- Có bằng chứng trước/sau tối ưu.
- Không thay đổi hành vi nghiệp vụ.
