---
name: bugfix-skill
description: "Use when: reproducing and fixing runtime, logic, routing, or state bugs with a root-cause-first workflow."
---

# Skill: Bugfix và Khôi phục lỗi cho Beacon

## Mục tiêu

Sửa lỗi đúng nguyên nhân gốc, giảm nguy cơ phát sinh regressions ở auth, router, network và state management.

## Khi dùng

- Bug runtime/crash
- Logic sai kết quả
- Điều hướng sai hoặc guard sai
- UI state bị kẹt loading/error

## Đầu vào tối thiểu

1. Cách tái hiện bug
2. Kết quả hiện tại và mong đợi
3. Phạm vi ảnh hưởng (màn/feature)

## Quy trình 5 bước

### 1) Reproduce
- Tái hiện bug ổn định ít nhất 1 lần.

### 2) Localize
- Khoanh vùng lớp gây lỗi: presentation/domain/data/core.
- Xác định source-of-truth tương ứng.

### 3) Reduce
- Tối giản input/context để tìm điều kiện kích hoạt chính.

### 4) Fix
- Sửa root cause với thay đổi tối thiểu.
- Không mở rộng refactor nếu không cần.

### 5) Guard
- Thêm kiểm chứng để bug không quay lại (test hoặc checklist verify).

## Heuristics theo vùng lỗi

- Routing: `app_routes.dart`, `app_router.dart`, `AuthGuard`.
- Message: `app_message_notifier.dart`, `GlobalMessageOverlay`, `MessageToast`.
- API: `api_endpoints.dart`, datasource impl, `ApiHandler`, repository mapping failure.
- Auth state: `AuthNotifier`, `AuthState`, token lifecycle local datasource.

## Stop-the-line criteria

Phải dừng merge nếu bug liên quan:
- Mất dữ liệu người dùng
- Lộ token/thông tin nhạy cảm
- Không đăng nhập/đăng xuất được
- Crash ngay luồng chính

## Verify bắt buộc

1. Re-test đúng steps gây lỗi ban đầu
2. Chạy `flutter analyze`
3. Chạy thêm 1-2 flow liền kề để check regression

## Done khi

- Bug không còn tái hiện theo steps cũ
- Không phát sinh lỗi mới ở luồng lân cận
- Có mô tả ngắn root cause và hướng fix
