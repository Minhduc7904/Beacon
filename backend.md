1. api/v1/posts	
- Method: POST

/// <summary>
/// Tạo bài đăng mới kèm media.
/// </summary>
/// <remarks>
/// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>.
///
/// Media phải do chính người dùng upload và có trạng thái <c>Ready</c>.
///
/// Các giá trị <c>code</c> có thể xuất hiện trong response:
///
/// - <c>null</c>: Tạo bài đăng thành công.
/// - <c>VALIDATION_ERROR</c>: Dữ liệu đầu vào không hợp lệ.
/// - <c>MEDIA_NOT_FOUND</c>: Media không tồn tại.
/// - <c>MEDIA_ACCESS_DENIED</c>: Bạn không sở hữu media này.
/// - <c>MEDIA_NOT_READY</c>: Media chưa được xử lý xong.
/// - <c>UNSUPPORTED_MEDIA_TYPE</c>: Loại media không được hỗ trợ.
/// - <c>INVALID_VIDEO_DURATION</c>: Video phải dài từ 5–10 giây.
/// - <c>INVALID_VISIBILITY</c>: Visibility không hợp lệ (chỉ nhận ""friends"" | ""private"").
///
/// Cấu trúc <c>data</c> khi thành công:
/// <code>
/// {
///   ""id"":           ""guid"",
///   ""ownerUserId"":  ""guid"",
///   ""media"": {
///     ""id"":               ""guid"",
///     ""url"":              ""string  (presigned URL, hết hạn 15 phút)"",
///     ""type"":             ""string  (image | video)"",
///     ""thumbnailUrl"":     ""string? (null nếu là ảnh)"",
///     ""durationSeconds"":  ""int?    (null nếu là ảnh)"",
///     ""width"":            ""int?"",
///     ""height"":           ""int?""
///   },
///   ""caption"":      ""string?"",
///   ""visibility"":   ""string  (friends | private)"",
///   ""status"":       ""string  (active)"",
///   ""createdAtUtc"": ""datetime (UTC)"",
///   ""updatedAtUtc"": ""datetime? (UTC)""
/// }
/// </code>
///
/// Format response chuẩn: <c>{ success, message, code, data, errors }</c>
/// </remarks>
/// <param name=""request"">
/// Body JSON:
/// <code>
/// {
///   ""mediaId"":    ""guid     (bắt buộc)"",
///   ""caption"":    ""string?  (tuỳ chọn, tối đa 2 000 ký tự)"",
///   ""visibility"": ""string?  (tuỳ chọn — friends | private; mặc định friends)""
/// }
/// </code>


2. api/v1/posts/feed
- Method: GET

/// <summary>
/// Lấy feed trang chủ (bài đăng của bản thân + bạn bè, cursor pagination).
/// </summary>
/// <remarks>
/// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>.
///
/// Query:
/// - <c>cursor</c> (tuỳ chọn, ISO datetime UTC): trả các bài có <c>createdAtUtc</c> nhỏ hơn giá trị này.
/// - <c>limit</c> (mặc định 20, tối đa 100).
///
/// Các giá trị <c>code</c> có thể xuất hiện trong response:
///
/// - <c>null</c>: Thành công.
///
/// Cấu trúc <c>data</c> khi thành công:
/// <code>
/// {
///   ""items"": [
///     {
///       ""id"":          ""guid"",
///       ""ownerUserId"": ""guid"",
///       ""owner"": {
///         ""id"":          ""guid"",
///         ""displayName"": ""string"",
///         ""avatarUrl"":   ""string?""
///       },
///       ""media"": {
///         ""id"":               ""guid"",
///         ""url"":              ""string"",
///         ""type"":             ""string  (image | video)"",
///         ""thumbnailUrl"":     ""string?"",
///         ""durationSeconds"":  ""int?"",
///         ""width"":            ""int?"",
///         ""height"":           ""int?""
///       },
///       ""caption"":         ""string?"",
///       ""visibility"":      ""string"",
///       ""createdAtUtc"":    ""datetime (UTC)"",
///       ""reactionSummary"": { ""totalCount"": ""int"", ""icons"": { ""heart"": ""int"", ... } },
///       ""myReaction"":      { ""icon"": ""string"" }
///     }
///   ],
///   ""nextCursor"": ""string? (null khi hết trang)""
/// }
/// </code>
///
/// Format response chuẩn: <c>{ success, message, code, data, errors }</c>
/// </remarks>

3. api/v1/posts/friends/{friendId}
- Method: GET

/// Lấy bài đăng (visibility=friends) từ một bạn bè cụ thể (cursor pagination).
/// </summary>
/// <remarks>
/// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>.
///
/// Query:
/// - <c>cursor</c> (tuỳ chọn, ISO datetime UTC): trả các bài có <c>createdAtUtc</c> nhỏ hơn giá trị này.
/// - <c>limit</c> (mặc định 20, tối đa 100).
///
/// Các giá trị <c>code</c> có thể xuất hiện trong response:
///
/// - <c>null</c>: Thành công.
/// - <c>POST_ACCESS_DENIED</c>: Người dùng chỉ định không phải bạn bè.
///
/// Cấu trúc <c>data</c> khi thành công: giống <c>GET /api/v1/posts/feed</c>
/// (<c>items</c> + <c>nextCursor</c>), chỉ bao gồm bài của <c>friendId</c>.
///
/// Format response chuẩn: <c>{ success, message, code, data, errors }</c>
/// </remarks>

3. api/v1/posts/me
- Method: GET

/// <summary>
/// Lấy danh sách bài đăng của bản thân (cursor pagination).
/// </summary>
/// <remarks>
/// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>.
///
/// Query:
/// - <c>cursor</c> (tuỳ chọn, ISO datetime UTC): trả các bài có <c>createdAtUtc</c> nhỏ hơn giá trị này.
/// - <c>limit</c> (mặc định 20, tối đa 100).
///
/// Các giá trị <c>code</c> có thể xuất hiện trong response:
///
/// - <c>null</c>: Thành công.
///
/// Cấu trúc <c>data</c> khi thành công: giống <c>GET /api/v1/posts/feed</c>
/// (<c>items</c> + <c>nextCursor</c>), chỉ bao gồm bài đăng của chính người dùng.
///
/// Format response chuẩn: <c>{ success, message, code, data, errors }</c>
/// </remarks>

4. api/v1/posts/{postId}
- Method: GET

/// <summary>
/// Lấy chi tiết một bài đăng theo ID.
/// </summary>
/// <remarks>
/// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>.
///
/// Chỉ chủ sở hữu hoặc bạn bè (khi visibility=friends) mới được xem.
///
/// Các giá trị <c>code</c> có thể xuất hiện trong response:
///
/// - <c>null</c>: Thành công.
/// - <c>POST_NOT_FOUND</c>: Bài đăng không tồn tại hoặc đã bị xóa.
/// - <c>POST_ACCESS_DENIED</c>: Bạn không có quyền xem bài đăng này.
///
/// Cấu trúc <c>data</c> khi thành công:
/// <code>
/// {
///   ""id"":          ""guid"",
///   ""ownerUserId"": ""guid"",
///   ""owner"": {
///     ""id"":          ""guid"",
///     ""displayName"": ""string"",
///     ""avatarUrl"":   ""string?""
///   },
///   ""media"": {
///     ""id"":               ""guid"",
///     ""url"":              ""string  (presigned URL, hết hạn 15 phút)"",
///     ""type"":             ""string  (image | video)"",
///     ""thumbnailUrl"":     ""string?"",
///     ""durationSeconds"":  ""int?"",
///     ""width"":            ""int?"",
///     ""height"":           ""int?""
///   },
///   ""caption"":         ""string?"",
///   ""visibility"":      ""string  (friends | private)"",
///   ""status"":          ""string  (active)"",
///   ""createdAtUtc"":    ""datetime (UTC)"",
///   ""updatedAtUtc"":    ""datetime? (UTC)"",
///   ""reactionSummary"": { ""totalCount"": ""int"", ""icons"": { ""heart"": ""int"", ... } },
///   ""myReaction"":      { ""icon"": ""string"" }
/// }
/// </code>
///
/// Format response chuẩn: <c>{ success, message, code, data, errors }</c>
/// </remarks>"

5. api/v1/posts/{postId}
- Method: PATCH

/// <summary>
/// Cập nhật caption hoặc visibility của bài đăng.
/// </summary>
/// <remarks>
/// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>.
///
/// Chỉ chủ sở hữu bài đăng mới được chỉnh sửa.
/// Bỏ qua field hoặc truyền <c>null</c> = giữ nguyên giá trị hiện tại.
///
/// Các giá trị <c>code</c> có thể xuất hiện trong response:
///
/// - <c>null</c>: Cập nhật thành công.
/// - <c>VALIDATION_ERROR</c>: Dữ liệu đầu vào không hợp lệ.
/// - <c>POST_NOT_FOUND</c>: Bài đăng không tồn tại.
/// - <c>POST_UPDATE_DENIED</c>: Bạn không có quyền chỉnh sửa bài đăng này.
/// - <c>INVALID_VISIBILITY</c>: Visibility không hợp lệ (chỉ nhận ""friends"" | ""private"").
///
/// Cấu trúc <c>data</c> khi thành công:
/// <code>
/// {
///   ""id"":           ""guid"",
///   ""ownerUserId"":  ""guid"",
///   ""media"": {
///     ""id"":               ""guid"",
///     ""url"":              ""string"",
///     ""type"":             ""string  (image | video)"",
///     ""thumbnailUrl"":     ""string?"",
///     ""durationSeconds"":  ""int?"",
///     ""width"":            ""int?"",
///     ""height"":           ""int?""
///   },
///   ""caption"":      ""string?"",
///   ""visibility"":   ""string  (friends | private)"",
///   ""status"":       ""string  (active)"",
///   ""createdAtUtc"": ""datetime (UTC)"",
///   ""updatedAtUtc"": ""datetime? (UTC)""
/// }
/// </code>
///
/// Format response chuẩn: <c>{ success, message, code, data, errors }</c>
/// </remarks>
/// <param name=""request"">
/// Body JSON (tất cả tuỳ chọn):
/// <code>
/// {
///   ""caption"":    ""string?  (null = giữ nguyên)"",
///   ""visibility"": ""string?  (friends | private; null = giữ nguyên)""
/// }
/// </code>
/// </param>"

6. api/v1/posts/{postId}
- Method: DELETE

/// <summary>
/// Soft-delete bài đăng của người dùng hiện tại.
/// </summary>
/// <remarks>
/// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>.
///
/// Chỉ chủ sở hữu bài đăng mới được xóa.
/// Media đính kèm không bị xóa theo.
///
/// Các giá trị <c>code</c> có thể xuất hiện trong response:
///
/// - <c>null</c>: Xóa thành công.
/// - <c>POST_NOT_FOUND</c>: Bài đăng không tồn tại.
/// - <c>POST_DELETE_DENIED</c>: Bạn không có quyền xóa bài đăng này.
///
/// Cấu trúc <c>data</c> khi thành công: <c>null</c>
///
/// Format response chuẩn: <c>{ success, message, code, data, errors }</c>
/// </remarks>

7. api/v1/posts/{postId}/reaction
- Method: PUT

/// <summary>
/// Tạo hoặc cập nhật reaction trên một bài đăng.
/// </summary>
/// <remarks>
/// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>.
///
/// Nếu người dùng đã có reaction trên bài đăng này, icon sẽ được cập nhật (upsert).
///
/// Các giá trị <c>code</c> có thể xuất hiện trong response:
///
/// - <c>null</c>: Thành công.
/// - <c>VALIDATION_ERROR</c>: Icon rỗng hoặc không hợp lệ.
/// - <c>INVALID_REACTION_ICON</c>: Icon không nằm trong danh sách hỗ trợ (heart, haha, like, sad, wow).
/// - <c>POST_NOT_FOUND</c>: Bài đăng không tồn tại hoặc đã bị xóa.
/// - <c>POST_ACCESS_DENIED</c>: Bạn không có quyền xem bài đăng này.
///
/// Cấu trúc <c>data</c> khi thành công:
/// <code>
/// {
///   ""postId"":          ""guid"",
///   ""myReaction"":      { ""icon"": ""string"" },
///   ""reactionSummary"": { ""totalCount"": ""int"", ""icons"": { ""heart"": ""int"", ... } }
/// }
/// </code>
///
/// Format response chuẩn: <c>{ success, message, code, data, errors }</c>
/// </remarks>
/// <param name=""request"">
/// Body JSON:
/// <code>
/// {
///   ""icon"": ""string  (bắt buộc — heart | haha | like | sad | wow)""
/// }
/// </code>
/// </param>

8. api/v1/posts/{postId}/reaction
- Method: DELETE

/// <summary>
/// Xóa reaction của người dùng trên một bài đăng (idempotent).
/// </summary>
/// <remarks>
/// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>.
///
/// Trả thành công kể cả khi reaction chưa tồn tại.
///
/// Các giá trị <c>code</c> có thể xuất hiện trong response:
///
/// - <c>null</c>: Thành công.
/// - <c>POST_NOT_FOUND</c>: Bài đăng không tồn tại hoặc đã bị xóa.
/// - <c>POST_ACCESS_DENIED</c>: Bạn không có quyền xem bài đăng này.
///
/// Cấu trúc <c>data</c> khi thành công:
/// <code>
/// {
///   ""postId"":          ""guid"",
///   ""myReaction"":      null,
///   ""reactionSummary"": { ""totalCount"": ""int"", ""icons"": { ""heart"": ""int"", ... } }
/// }
/// </code>
///
/// Format response chuẩn: <c>{ success, message, code, data, errors }</c>
/// </remarks>