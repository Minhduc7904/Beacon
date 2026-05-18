---
name: performance-skill
description: "Use when: investigating and improving UI, rebuild, and network performance with measurable before-after results."
---

# Skill: Performance Optimization

## Mục tiêu

Tối ưu hiệu năng dựa trên đo lường, không tối ưu cảm tính.

## Khi dùng

- UI giật, drop frame.
- Request/network chậm hoặc gọi dư thừa.
- Build/rebuild quá nhiều do state management.

## Đầu vào tối thiểu

1. Triệu chứng cụ thể (drop frame, TTI chậm, API latency...)
2. Màn hình/flow tái hiện được
3. Chỉ số baseline trước tối ưu

## Quy trình

1. Đo và xác định điểm nghẽn trước.
2. Tối ưu đúng điểm nghẽn.
3. Đo lại để xác nhận cải thiện.

## Heuristics cho Beacon

- Kiểm tra `ref.watch` quá rộng gây rebuild không cần thiết.
- Tránh gọi API lặp không cần cache/điều kiện.
- Tối ưu widget tree ở màn có nhiều thành phần động.

## Đầu ra kỳ vọng

1. Danh sách bottleneck theo mức ảnh hưởng
2. Thay đổi tối ưu tập trung đúng điểm nghẽn chính
3. Bảng so sánh trước/sau cho chỉ số quan trọng

## Verify bắt buộc

1. Re-test cùng flow và cùng điều kiện đo với baseline
2. Xác nhận không thay đổi hành vi nghiệp vụ
3. Kiểm tra không phát sinh regression ở flow liền kề

## Done khi

- Có bằng chứng trước/sau tối ưu.
- Không thay đổi hành vi nghiệp vụ.
