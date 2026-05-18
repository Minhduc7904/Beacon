# Posts API Integration Implementation Summary

Ngày tổng hợp: 2026-05-18

## Phạm vi đã thực hiện

Chuỗi task đã triển khai từ Task 0 đến Task 8 trong `posts_api_integration_tasks.md`. Task 9 vẫn là bước cleanup/verify cuối cùng sau khi format/analyze/test được chạy ổn định trên máy local.

## Tóm tắt theo task

### Task 0 - Audit

- Đọc `backend.md`, feed/home/post preview/friends, endpoint constants, providers, API handler và error mapping.
- Xác nhận feed cũ đang dùng mock data trong production flow.
- Xác nhận post preview trước đó chỉ upload media, chưa tạo post.
- Xác nhận backend có `reactionSummary` nhưng chưa có danh sách người đã react.
- Xác nhận reaction enum cần bám backend: `heart`, `haha`, `like`, `sad`, `wow`.

### Task 1 - Posts API foundation

- Thêm endpoint constants cho posts trong `ApiEndpoints`.
- Thêm error codes/messages liên quan post/media/reaction.
- Tạo feature `posts` theo Clean Architecture:
  - data datasource/model/repository implementation
  - domain entity/repository/usecase
  - mapper business error code
- Wiring providers trong `lib/core/providers/providers.dart`.
- Các API/usecase chính đã có:
  - create post
  - get feed posts
  - get my posts
  - get friend posts
  - update post
  - delete post
  - set/delete reaction

### Task 2 - Đăng ảnh

- `post_preview` upload media rồi gọi `CreatePostUseCase`.
- Thêm caption input, giới hạn 2000 ký tự.
- Chỉ `pop(true)` khi tạo post thành công.
- Nếu upload media thành công nhưng create post fail, giữ `mediaId` để retry mà không upload lại.
- Message lỗi/thành công đi qua `appMessageProvider`.

### Task 3 - Feed API

- Feed production không còn phụ thuộc mock data.
- `FeedNotifier.load()` gọi API thật qua usecase.
- Map `Post` từ backend/domain sang `FeedPost` dùng cho UI.
- Thêm state loading/error/empty.
- Thêm cursor pagination và load more khi lướt gần cuối.

### Task 4 - Dropdown filter

- Thêm filter state cho feed:
  - tất cả
  - tôi
  - một người bạn cụ thể
- Khi đổi filter, reset feed và reload từ trang đầu.
- Khi đang ở home page đầu vẫn hiển thị streak chip.
- Khi đang xem feed, app bar center chuyển sang dropdown filter.
- Friend filter dùng `GetFriendsUseCase`.

### Task 5 - Single/Grid view

- Thêm `FeedViewMode.single/grid`.
- Single view giữ vertical `PageView` từng ảnh.
- Grid view hiển thị 3 ảnh mỗi hàng.
- Nút chuyển sang grid nằm cuối màn hình single view.
- Tap ảnh trong grid chuyển về single đúng index.
- Filter và pagination dùng chung cho cả hai view mode.

### Task 6 - Reaction

- Reaction enum bám backend: `heart`, `haha`, `like`, `sad`, `wow`.
- Tap reaction mới gọi `PUT /posts/{postId}/reaction`.
- Tap lại reaction hiện tại gọi `DELETE /posts/{postId}/reaction`.
- Đồng bộ `myReaction` và `reactionSummary` từ response.
- Chủ bài không thấy action react bài của chính mình.

### Task 7 - Owner edit/delete

- Chủ bài thấy owner menu khi `ownerUserId == currentUser.id`.
- Thêm bottom sheet sửa `caption` và `visibility`.
- Xóa bài có confirm dialog.
- Delete thành công remove item khỏi feed state.
- Patch thành công update item trong feed state.
- Chưa hỗ trợ thay ảnh/media vì backend hiện chỉ cho sửa caption/visibility.

### Task 8 - Reaction details gap

- Vì backend chưa có API danh sách người react, UI đang dùng mock tạm ở presentation layer.
- Thêm owner menu action `Người đã react`.
- Thêm bottom sheet reaction details:
  - summary count theo icon
  - filter theo reaction type
  - danh sách user mock deterministic từ reaction counts
  - empty state khi chưa có reaction
- Không tạo datasource/repository/usecase giả cho API chưa có.
- Thêm backend contract đề xuất tại `task/posts_reaction_details_backend_contract.md`.

## Quyết định kiến trúc chính

- API posts thật đặt trong feature `posts`, còn feature `feed` giữ entity/UI state riêng để tránh kéo UI phụ thuộc trực tiếp vào data model backend.
- Dependency mới đi qua `providers.dart`.
- Endpoint đi qua `ApiEndpoints`, không hardcode trong UI/datasource.
- Error code được map qua constants và mapper riêng.
- UI side effects đi qua `appMessageProvider`.
- Mock data production feed đã được loại khỏi flow chính; ngoại lệ duy nhất là Task 8, mock chỉ nằm trong bottom sheet UI vì backend chưa có contract thật.

## File/khu vực thay đổi chính

- `lib/core/network/api_endpoints.dart`
- `lib/core/constants/api_error_codes.dart`
- `lib/core/constants/error_messages.dart`
- `lib/core/providers/providers.dart`
- `lib/core/widgets/input/input.dart`
- `lib/features/posts/`
- `lib/features/post_preview/`
- `lib/features/feed/`
- `lib/features/home/presentation/widgets/home/`
- `task/posts_reaction_details_backend_contract.md`

## Backend contract cần bổ sung

Endpoint đề xuất cho Task 8:

```http
GET /api/v1/posts/{postId}/reactions?cursor={cursor}&limit={limit}&icon={icon}
```

Response nên trả:

- `items`: danh sách reaction detail gồm `reactionId`, `postId`, `icon`, `reactedAtUtc`, `user`.
- `summary`: tổng số reaction và count theo icon.
- `nextCursor`: cursor phân trang.

Chi tiết contract, error codes, phân quyền, pagination và index DB đã được ghi trong `task/posts_reaction_details_backend_contract.md`.

## Verify hiện tại

- User đã chạy `dart format` cho các file task trước đó.
- User đã chạy `flutter analyze`; các lỗi phát sinh trong quá trình làm đã được xử lý và user báo không còn error trước khi chuyển tiếp các task.
- Sau Task 8 vẫn nên chạy lại:

```powershell
dart format lib/features/feed/presentation/widgets/feed_post_card.dart lib/features/feed/presentation/widgets/feed_reaction_details_sheet.dart lib/features/home/presentation/widgets/home/home_body.dart
flutter analyze
```

## Rủi ro và TODO

- Task 8 đang mock user list, cần thay bằng API thật khi backend bổ sung endpoint reaction details.
- Cần Task 9 để cleanup import/naming/state và chạy verify cuối.
- Nên test thủ công các flow:
  - chụp ảnh -> preview -> tạo post
  - xem feed all/me/friend
  - chuyển single/grid
  - react/hủy react bài bạn bè
  - owner edit/delete
  - owner mở reaction details sheet
- Nếu có test suite liên quan, chạy `flutter test`.

## Rollback nhanh nếu cần

- Rollback Task 8 UI: gỡ `FeedReactionDetailsSheet`, gỡ `onViewReactions` khỏi `FeedPostCard`, gỡ import/callback trong `HomeBody`.
- Rollback feed API về mock không khuyến nghị, nhưng có thể kiểm tra lại `lib/features/feed/data/mock/feed_mock_data.dart` nếu cần debug UI độc lập.
- Rollback API integration nên làm theo từng task commit/slice, tránh revert cả nhánh nếu chỉ lỗi một flow nhỏ.

## Commit message đề xuất

```text
feat(posts): integrate posts API feed workflow
```
