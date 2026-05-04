API cần dùng

1. /checkin
- Method: GET
- Mục đích: Checkin
- Input:
"{
  ""note"": ""string"",
  ""latitude"": 0,
  ""longitude"": 0, 
  ""mediaId"": ""3fa85f64-5717-4562-b3fc-2c963f66afa6""
}"

- 2 trường latitude và longtitude hiện chưa có, không truyền gì vào 2 trường này

- Output
"#region
    /// <summary>Người dùng thực hiện check-in an toàn hàng ngày.</summary>
    /// <remarks>
    /// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>
    ///
    /// Mỗi người dùng chỉ được check-in 1 lần mỗi ngày.
    /// Nếu chưa có record an toàn hôm nay, hệ thống tự tạo dựa trên cài đặt <c>SafetySetting</c>.
    /// Nếu chưa có <c>SafetySetting</c>, deadline mặc định là 23:59 UTC.
    ///
    /// Các giá trị <c>code</c>:
    /// - <c>null</c>: Thành công.
    /// - <c>VALIDATION_ERROR</c>: Dữ liệu không hợp lệ (note &gt; 1000 ký tự, lat/long sai range hoặc thiếu cặp).
    /// - <c>MEDIA_NOT_FOUND</c>: mediaId không tồn tại.
    /// - <c>ALREADY_CHECKED_IN</c>: Đã check-in hôm nay rồi.
    ///
    /// Cấu trúc <c>data</c> khi thành công:
    /// <code>
    /// {
    ///   ""id"": ""guid"",
    ///   ""dailySafetyRecordId"": ""guid"",
    ///   ""checkinDate"": ""yyyy-MM-dd"",
    ///   ""checkedInAtUtc"": ""datetime"",
    ///   ""type"": ""Manual|Recovery|Emergency"",
    ///   ""note"": ""string|null"",
    ///   ""latitude"": ""decimal|null"",
    ///   ""longitude"": ""decimal|null"",
    ///   ""mediaObjectId"": ""guid|null""
    /// }
    /// </code>
    ///
    /// Format: <c>{ success, message, code, data, errors }</c>
    /// </remarks>
    #endregion"


2. /today-status
- Method: GET
- Mục đích: Lấy tình trạng người dùng trong hôm nay
- Input/Output

"#region
    /// <summary>Lấy trạng thái check-in và thời gian đếm ngược đến deadline trong ngày hôm nay.</summary>
    /// <remarks>
    /// Yêu cầu: <c>Authorization: Bearer &lt;token&gt;</c>
    ///
    /// Deadline lấy từ <c>SafetySetting</c> của user. Nếu chưa cấu hình, mặc định là 23:59 UTC.
    ///
    /// Hành vi theo trạng thái monitoring:
    /// - <c>isMonitoringEnabled = false</c>: không có countdown, không có overdue — <c>remainingSeconds</c> luôn null, <c>status</c> không bao giờ là <c>Overdue</c>.
    /// - <c>isAutoAlertEnabled = false</c>: vẫn tính overdue, nhưng hệ thống không gửi cảnh báo tự động.
    ///
    /// Các giá trị <c>code</c>:
    /// - <c>null</c>: Thành công.
    ///
    /// Cấu trúc <c>data</c> khi thành công:
    /// <code>
    /// {
    ///   ""hasCheckedIn"": ""bool"",
    ///   ""status"": ""Pending | CheckedIn | Overdue"",
    ///   ""deadlineAtUtc"": ""datetime"",
    ///   ""remainingSeconds"": ""long | null — null khi CheckedIn hoặc monitoring tắt, âm khi Overdue"",
    ///   ""checkedInAtUtc"": ""datetime | null"",
    ///   ""isMonitoringEnabled"": ""bool — false: tắt toàn bộ countdown và overdue"",
    ///   ""isAutoAlertEnabled"": ""bool — false: vẫn overdue nhưng không gửi alert tự động""
    /// }
    /// </code>
    ///
    /// Format: <c>{ success, message, code, data, errors }</c>
    /// </remarks>
    #endregion"


3. Các kịch bản check-in

"Scenario 1 — Check-in nhanh (không ảnh)

POST /api/v1/checkins
Frontend chỉ cần 1 nút bấm. Đơn giản nhất.

Scenario 2 — Check-in có ảnh

Bước 1: User chụp ảnh
        ↓
Bước 2: POST /api/v1/media  (multipart/form-data)
        ↓ nhận về
        { ""data"": { ""id"": ""abc-123"", ... } }
        ↓
Bước 3: POST /api/v1/checkins
        { ""mediaId"": ""abc-123"" }


ví dụ: 
{
  ""note"": ""Tôi đang ổn, check-in từ văn phòng."",
  ""latitude"": 10.7769,
  ""longitude"": 106.7009,
  ""mediaId"": ""3fa85f64-5717-4562-b3fc-2c963f66afa6""
}

{
  ""success"": true,
  ""message"": null,
  ""code"": null,
  ""data"": {
    ""id"": ""xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"",
    ""dailySafetyRecordId"": ""xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"",
    ""checkinDate"": ""2026-04-28"",
    ""checkedInAtUtc"": ""2026-04-27T16:52:00Z"",
    ""type"": ""Manual"",
    ""note"": ""Tôi đang ổn, check-in từ văn phòng."",
    ""latitude"": 10.7769,
    ""longitude"": 106.7009,
    ""mediaObjectId"": ""3fa85f64-5717-4562-b3fc-2c963f66afa6""
  },
  ""errors"": null
}


