---
name: project-context
description: "Use when: loading Beacon project overview, active feature map, and source-of-truth context before coding."
---

# Project Context — Beacon App

## 1) Tổng quan dự án

- Đây là ứng dụng Flutter theo kiến trúc feature-first.
- Trục chính hiện tại: đăng nhập/đăng xuất, home camera + post preview, onboarding, hạ tầng network + storage + global messages.
- Feature đã có:
   - `features/auth`
   - `features/home`
   - `features/onboarding`
   - `features/post_preview`
   - `features/splash`
   - `features/widgets` (trang demo shared widgets)

## 2) Stack kỹ thuật

- Flutter + Dart (`sdk: ^3.11.1`)
- Riverpod (`flutter_riverpod`) cho state management + DI
- GoRouter (`go_router`) cho routing
- Dio (`dio`) cho HTTP
- SharedPreferences (`shared_preferences`) cho local storage
- dartz (`Either<Failure, T>`) cho error handling theo hướng functional

## 3) Điểm vào quan trọng cần biết

1. `lib/main.dart`
   - Khởi tạo `SharedPreferences`
   - Gắn `ProviderScope` + override `sharedPreferencesProvider`
   - Bọc app bằng `GlobalMessageOverlay` trong môi trường dev (`AppEnv.isDev`)
2. `lib/core/providers/providers.dart`
   - Nơi wiring dependency graph toàn app
3. `lib/core/config/app_routes.dart` + `lib/core/config/app_router.dart`
   - Nơi khai báo và đăng ký route

## 4) Các source of truth

- Routes: `lib/core/config/app_routes.dart`
- Router graph: `lib/core/config/app_router.dart`
- Providers DI graph: `lib/core/providers/providers.dart`
- API endpoints: `lib/core/network/api_endpoints.dart`
- Storage keys: `lib/core/constants/storage_keys.dart`
- Assets constants: `lib/core/constants/app_images.dart`

## 5) Luồng chính đang hoạt động

### Login
- `LoginPage` -> `AuthNotifier.login()` -> `LoginUseCase` -> `AuthRepositoryImpl.login()`
- Repository kiểm tra mạng, gọi remote datasource, lưu token local datasource
- Success: `AuthSuccess` + global success message + navigate `/home`

### Logout
- Điều hướng qua `AppRoutes.logout` (từ flow UI liên quan)
- `LogoutPage` trigger `AuthNotifier.logout()`
- Repository cố gọi logout API (nếu có mạng), sau đó luôn clear token local
- Kết thúc quay về `/login`

### Global Messages
- Gọi `appMessageProvider.notifier.addSuccess/addError/...`
- Overlay global render toast và tự dismiss

## 6) Ghi chú thực tế cần nhớ

1. Route hiện có thêm `widgets` trong `app_routes.dart` và `app_router.dart`.
2. Đường dẫn toast widgets hiện tại là `lib/core/widgets/message_toast/*`.
3. `AuthInterceptor` có TODO cho luồng refresh token khi 401.
4. `ApiEndpoints.baseUrl` đang là localhost (`http://localhost:3001/api`).

## 7) Nguyên tắc khi AI Agent bắt đầu task

1. Đọc `instructions/architecture-rules.md` trước khi sửa code.
2. Nếu task là feature/API/bugfix, dùng đúng skill tương ứng trong `skills/`.
3. Ưu tiên thay đổi nhỏ, đúng phạm vi, tránh đụng lan sang phần không liên quan.
