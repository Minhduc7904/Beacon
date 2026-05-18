# Message Seen Timestamp Contract

## Mục tiêu

Khi người nhận đã xem tin nhắn, app phải hiển thị được `Đã xem lúc HH:mm` cả khi đang ở trong màn chat realtime và khi thoát ra rồi vào lại.

## Vấn đề hiện tại

Realtime có thể tạo timestamp tạm ở frontend nên đang thấy `Đã xem lúc ...` ngay lúc bạn bè seen. Nhưng khi mở lại đoạn chat, frontend load lại từ API group detail; nếu API chỉ trả `lastSeenMessageId` mà không trả thời điểm seen thì UI chỉ còn fallback `Đã xem`.

## Backend Cần Bổ Sung

1. Lưu thời điểm seen theo từng member trong từng message group.
   - Field đề xuất: `lastSeenAtUtc`.
   - Giá trị là UTC, ISO 8601, ví dụ `2026-05-19T08:30:00Z`.

2. Khi xử lý:
   - `PATCH /message-groups/{groupId}/seen`
   - Body hiện tại: `{ "lastSeenMessageId": "..." }`
   - Backend cần cập nhật đồng thời:
     - `lastSeenMessageId`
     - `lastSeenAtUtc = now UTC`

3. Khi trả group detail:
   - `GET /message-groups/{groupId}`
   - Mỗi item trong `members` cần có:

```json
{
  "userId": "user-id",
  "familyName": "...",
  "givenName": "...",
  "avatarUrl": "...",
  "role": 0,
  "lastSeenMessageId": "message-id",
  "lastSeenAtUtc": "2026-05-19T08:30:00Z"
}
```

4. Realtime seen event nên gửi kèm timestamp để đồng bộ chính xác:
   - Event: `ReceiveMessageSeen`
   - Args đề xuất:

```text
groupId, seenByUserId, lastSeenMessageId, lastSeenAtUtc
```

Fallback cũ `groupId, lastSeenMessageId` vẫn có thể giữ trong giai đoạn transition.

## Frontend Hiện Đã Sẵn Sàng

Frontend đã parse các field sau cho timestamp seen:

- `lastSeenAtUtc`
- `lastSeenAt`
- `seenAtUtc`
- `seenAt`
- `readAtUtc`
- `readAt`

Ưu tiên backend dùng đúng `lastSeenAtUtc`.

## Acceptance Criteria

1. User A gửi tin nhắn cho User B.
2. User B mở chat và seen tin nhắn.
3. User A đang ở trong chat thấy `Đã xem lúc HH:mm`.
4. User A thoát chat, mở lại chat vẫn thấy `Đã xem lúc HH:mm`.
5. API group detail trả `members[].lastSeenAtUtc` đúng UTC ISO 8601.
6. Không thay đổi contract hiện có của `lastSeenMessageId`.

## Verify

1. Gọi `PATCH /message-groups/{groupId}/seen`.
2. Gọi lại `GET /message-groups/{groupId}`.
3. Kiểm tra member vừa seen có cả `lastSeenMessageId` và `lastSeenAtUtc`.
4. Mở app, vào chat lại và xác nhận UI không còn fallback về `Đã xem`.
