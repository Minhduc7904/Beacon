# Skill: Spec trước khi code

## Mục tiêu

Làm rõ phạm vi và tiêu chí hoàn thành trước khi bắt tay vào code để tránh sửa đi sửa lại.

## Khi dùng

- Task mới chưa rõ yêu cầu.
- Feature thay đổi nhiều lớp hoặc nhiều file.

## Khung spec tối thiểu

1. Bối cảnh và mục tiêu người dùng.
2. In-scope / Out-of-scope.
3. Ảnh hưởng kiến trúc (data/domain/presentation).
4. Ảnh hưởng router/providers/network/storage.
5. Tiêu chí chấp nhận (acceptance criteria).
6. Kế hoạch verify (analyze, test, manual flow).

## Ràng buộc Beacon

- Route mới phải qua `app_routes.dart` và `app_router.dart`.
- Dependency mới phải wiring qua `providers.dart`.
- Không hardcode endpoint/storage key.

## Done khi

- Mỗi tiêu chí chấp nhận đều kiểm chứng được.
- Không còn điểm mơ hồ ảnh hưởng thiết kế code.
