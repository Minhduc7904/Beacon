# Posts Reaction Details Backend Contract

## Mục tiêu

Task 8 đang dựng UI tạm bằng mock data vì backend hiện chỉ trả `reactionSummary`, chưa có danh sách người đã react. Khi backend sẵn sàng, frontend nên thay mock bằng một use case đọc endpoint riêng để tránh làm response feed quá nặng.

## Endpoint đề xuất

```http
GET /api/v1/posts/{postId}/reactions?cursor={cursor}&limit={limit}&icon={icon}
```

- `postId`: id bài viết.
- `cursor`: opaque cursor cho keyset pagination, optional.
- `limit`: số item mỗi trang, default `30`, max `100`.
- `icon`: optional filter, một trong `heart`, `haha`, `like`, `sad`, `wow`.

## Phân quyền

- Yêu cầu authenticated user.
- Phase đầu nên chỉ cho chủ bài xem danh sách đầy đủ người đã react.
- Friend hoặc viewer khác có thể chỉ xem `reactionSummary` như hiện tại, trừ khi product quyết định public danh sách.
- Không trả email, phone, username nội bộ hoặc thông tin nhạy cảm khác trong response này.

## Success Response

```json
{
  "success": true,
  "message": "Post reactions retrieved successfully",
  "code": "POST_REACTIONS_RETRIEVED",
  "data": {
    "items": [
      {
        "reactionId": "4a0c4a89-70de-4d13-b4e6-37cda4b8f3b0",
        "postId": "9d1fbf6a-79b5-4f5a-8e6b-3658d2dc3640",
        "icon": "heart",
        "reactedAtUtc": "2026-05-18T09:20:11.000Z",
        "user": {
          "id": "6e38a5b1-6f11-4649-b445-c2fcb3e4df70",
          "displayName": "Minh Anh",
          "avatarUrl": "https://cdn.example.com/avatars/u1.jpg"
        }
      }
    ],
    "summary": {
      "totalCount": 12,
      "icons": {
        "heart": 6,
        "haha": 2,
        "like": 3,
        "sad": 0,
        "wow": 1
      }
    },
    "nextCursor": "opaque_cursor_or_null"
  }
}
```

## Error Codes

- `POST_NOT_FOUND`: bài viết không tồn tại hoặc đã bị xóa.
- `POST_ACCESS_DENIED`: user không có quyền xem bài viết.
- `REACTION_DETAILS_DENIED`: user có quyền xem bài nhưng không có quyền xem danh sách người react.
- `INVALID_REACTION_ICON`: query `icon` không hợp lệ.
- `VALIDATION_ERROR`: cursor/limit/query không hợp lệ.

## Pagination và sorting

- Sort mặc định: `reactedAtUtc DESC`, tie-break bằng `reactionId DESC`.
- Cursor nên encode cặp `{ reactedAtUtc, reactionId }`, không dùng offset pagination để tránh trùng/mất item khi reaction thay đổi.
- Nếu có filter `icon`, cursor vẫn dùng cùng sort order trên tập đã filter.

## Database/index gợi ý

- Unique constraint: `(post_id, user_id)` để mỗi user chỉ có một reaction hiện hành trên một post.
- Index danh sách toàn bộ: `(post_id, reacted_at_utc DESC, id DESC)`.
- Index filter theo icon: `(post_id, icon, reacted_at_utc DESC, id DESC)`.
- Nếu summary tính nhiều, cân nhắc materialized counter hoặc reaction summary table cập nhật trong transaction khi upsert/delete reaction.

## Frontend integration sau khi có API

- Thêm `ApiEndpoints.postReactions(postId)`.
- Thêm entity/model kiểu `PostReactionDetail`, `PostReactionDetailsPage`.
- Flow chuẩn: `FeedReactionDetailsSheet -> Notifier -> GetPostReactionDetailsUseCase -> PostsRepository -> PostsRemoteDatasource`.
- Thay `_MockReactionDetails` trong `feed_reaction_details_sheet.dart` bằng state thật có loading/error/load more.
- Giữ `reactionSummary` trong feed response để render count nhanh; chỉ gọi endpoint details khi owner mở bottom sheet.
