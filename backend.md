GET /friends/search?search

#region
    /// <summary>Tìm kiếm bạn bè theo số điện thoại.</summary>
    /// <remarks>
    /// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>
    ///
    /// Tìm trong danh sách bạn bè của user hiện tại theo số điện thoại (partial match).
    /// Kết quả sắp xếp theo thời gian kết bạn mới nhất trước.
    ///
    /// **Query params:**
    /// - <c>search</c> (string, bắt buộc, tối thiểu 3 ký tự): Chuỗi tìm kiếm khớp một phần với số điện thoại.
    /// - <c>cursor</c> (string ISO-8601 UTC, tuỳ chọn): Load kết quả cũ hơn mốc này.
    /// - <c>limit</c> (int, tuỳ chọn, mặc định 20, tối đa 100): Số bản ghi mỗi trang.
    ///
    /// **Response khi thành công (HTTP 200):**
    /// <code>
    /// {
    ///   "success": true,
    ///   "message": "...",
    ///   "code": null,
    ///   "data": {
    ///     "data": [
    ///       {
    ///         "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    ///         "username": "alice",
    ///         "avatarUrl": null,
    ///         "type": 2,
    ///         "createdAtUtc": "2026-05-01T08:00:00Z",
    ///         "messageGroupId": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
    ///       }
    ///     ],
    ///     "meta": {
    ///       "nextCursor": "2026-05-01T08:00:00Z",
    ///       "limit": 20,
    ///       "hasMore": false
    ///     }
    ///   },
    ///   "errors": null
    /// }
    /// </code>
    ///
    /// **Giải thích các trường:**
    /// - <c>userId</c>: Id của người bạn (không phải của user hiện tại).
    /// - <c>type</c>: Loại bạn bè — <c>0</c> = Family, <c>1</c> = CloseFriend, <c>2</c> = Normal, <c>3</c> = Custom.
    /// - <c>messageGroupId</c>: Id nhóm chat riêng tư với người bạn này. Dùng để gọi GET /api/v1/message-groups/{groupId}/messages.
    ///
    /// **Các giá trị <c>code</c>:**
    /// - <c>null</c>: Thành công (HTTP 200).
    /// - <c>VALIDATION_ERROR</c>: <c>search</c> trống hoặc ngắn hơn 3 ký tự (HTTP 400).
    /// - <c>401</c>: Token không hợp lệ hoặc hết hạn.
    /// </remarks>

GET /message-groups/group{id}

#region
    /// <summary>Xem thông tin chi tiết nhóm chat kèm danh sách thành viên.</summary>
    /// <remarks>
    /// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>
    ///
    /// Trả về metadata của nhóm và toàn bộ danh sách thành viên.
    /// Chỉ thành viên của nhóm mới được xem.
    ///
    /// **Path param:**
    /// - <c>groupId</c> (guid, bắt buộc): Id của nhóm. Lấy từ <c>groupId</c> trong danh sách hội thoại
    ///   hoặc <c>messageGroupId</c> trong danh sách bạn bè.
    ///
    /// **Response khi thành công (HTTP 200):**
    /// <code>
    /// {
    ///   "success": true,
    ///   "message": "...",
    ///   "code": null,
    ///   "data": {
    ///     "groupId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    ///     "isPrivate": true,
    ///     "createdAtUtc": "2026-05-01T08:00:00Z",
    ///     "members": [
    ///       {
    ///         "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    ///         "username": "alice",
    ///         "familyName": "Nguyen",
    ///         "givenName": "Alice",
    ///         "avatarUrl": null
    ///       }
    ///     ]
    ///   },
    ///   "errors": null
    /// }
    /// </code>
    ///
    /// **Giải thích các trường:**
    /// - <c>isPrivate</c>: <c>true</c> nếu là chat 1-1 (giữa 2 bạn bè), <c>false</c> nếu là nhóm nhiều người.
    /// - <c>members</c>: Toàn bộ thành viên của nhóm, bao gồm cả user hiện tại.
    /// - <c>familyName</c> / <c>givenName</c>: Họ và tên của thành viên, có thể <c>null</c> nếu chưa cập nhật.
    /// - <c>avatarUrl</c>: URL ảnh đại diện, <c>null</c> nếu chưa có.
    ///
    /// **Các giá trị <c>code</c>:**
    /// - <c>null</c>: Thành công (HTTP 200).
    /// - <c>MESSAGE_GROUP_NOT_FOUND</c>: Nhóm không tồn tại (HTTP 404).
    /// - <c>MESSAGE_GROUP_FORBIDDEN</c>: Không phải thành viên nhóm (HTTP 403).
    /// - <c>401</c>: Token không hợp lệ hoặc hết hạn.
    /// </remarks>