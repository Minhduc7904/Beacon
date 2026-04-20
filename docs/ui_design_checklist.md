# UI Design Checklist (Pre-merge)

Checklist nhanh để tự review màn hình UI trước khi merge.

## 1) Theme và token

- [ ] Màu semantic dùng qua `Theme.of(context).colorScheme`
- [ ] Typography dùng qua `Theme.of(context).textTheme`
- [ ] Không hardcode `Colors.*`, `fontSize`, `fontWeight`, `height` nếu đã có token

## 2) Shared components

- [ ] Đã ưu tiên tái sử dụng widget trong `lib/core/widgets/`
- [ ] Button/Input/Card style bám theo `AppTheme`
- [ ] Không tạo component lặp lại không cần thiết trong feature

## 3) UX states

- [ ] Có state loading rõ ràng
- [ ] Có state empty (nếu cần)
- [ ] Có state error rõ ràng
- [ ] Có state success/feedback rõ ràng

## 4) Visual quality

- [ ] Kiểm tra layout trên màn hình nhỏ
- [ ] Kiểm tra layout trên màn hình rộng
- [ ] Kiểm tra dark mode (nếu màn hình có sử dụng)
- [ ] Contrast text/background đạt yêu cầu dễ đọc

## 5) Kiểm chứng kỹ thuật

- [ ] Không hardcode route/endpoint/storage key trong UI
- [ ] Chạy `flutter analyze`
- [ ] Verify tay flow chính liên quan
