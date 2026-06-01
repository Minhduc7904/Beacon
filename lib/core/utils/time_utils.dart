class TimeUtils {
  TimeUtils._();

  static const int _vnOffsetHours = 7;

  /// Chuyển DateTime bất kỳ sang giờ Việt Nam (UTC+7)
  static DateTime toVietnamTime(DateTime dateTime) {
    final utc = dateTime.isUtc ? dateTime : dateTime.toUtc();
    return utc.add(const Duration(hours: _vnOffsetHours));
  }

  /// Chuyển giờ Việt Nam (UTC+7) về UTC
  static DateTime toUtc(DateTime vietnamTime) {
    return vietnamTime.subtract(const Duration(hours: _vnOffsetHours));
  }

  /// Parse ISO8601 string rồi trả về giờ Việt Nam
  ///
  /// Ví dụ:
  /// "2026-03-11T08:00:00Z" → 2026-03-11 15:00:00
  static DateTime parseToVietnamTime(String isoString) {
    final parsed = DateTime.parse(isoString);
    return toVietnamTime(parsed.toUtc());
  }

  static DateTime? tryParseUtc(Object? value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return null;
    }

    final tail = raw.length > 10 ? raw.substring(10) : '';
    final hasTimezoneSuffix =
        raw.endsWith('Z') ||
        raw.endsWith('z') ||
        raw.contains('+') ||
        tail.contains('-');

    if (hasTimezoneSuffix) {
      return parsed.toUtc();
    }

    return DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
      parsed.millisecond,
      parsed.microsecond,
    );
  }

  /// Chuyển giờ Việt Nam → ISO8601 UTC string
  ///
  /// Ví dụ:
  /// 2026-03-11 15:00:00 → "2026-03-11T08:00:00.000Z"
  static String toIsoUtcString(DateTime vietnamTime) {
    return toUtc(vietnamTime).toIso8601String();
  }

  /// Format đầy đủ ngày + giờ
  ///
  /// Ví dụ:
  /// 11/03/2026 15:00
  /// 11/03/2026 15:00:30
  static String formatVietnamTime(
    DateTime vietnamTime, {
    bool withSeconds = false,
  }) {
    final date = formatDate(vietnamTime);
    final time = formatTime(vietnamTime, withSeconds: withSeconds);
    return '$date $time';
  }

  static String formatRelativeVietnamTime(DateTime vietnamTime) {
    final diff = nowVietnam().difference(vietnamTime);
    if (diff.isNegative || diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  /// Format giờ
  ///
  /// Ví dụ:
  /// 15:00
  /// 15:00:30
  static String formatTime(DateTime vietnamTime, {bool withSeconds = false}) {
    return withSeconds
        ? '${_pad(vietnamTime.hour)}:${_pad(vietnamTime.minute)}:${_pad(vietnamTime.second)}'
        : '${_pad(vietnamTime.hour)}:${_pad(vietnamTime.minute)}';
  }

  /// Format ngày
  ///
  /// Ví dụ:
  /// 11/03/2026
  static String formatDate(DateTime vietnamTime) {
    return '${_pad(vietnamTime.day)}/${_pad(vietnamTime.month)}/${vietnamTime.year}';
  }

  /// Trả về thời gian hiện tại theo giờ Việt Nam
  static DateTime nowVietnam() {
    return DateTime.now().toUtc().add(const Duration(hours: _vnOffsetHours));
  }

  /// Kiểm tra hai DateTime có cùng ngày không
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Tính thời gian còn lại tới [endTime]
  ///
  /// Nếu đã hết giờ → Duration.zero
  static Duration remainingTime(DateTime endTime) {
    final now = nowVietnam();
    final diff = endTime.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  /// Chuyển chuỗi HH:MM từ giờ Việt Nam sang UTC
  ///
  /// Ví dụ:
  /// "22:00" (Vietnam) → "15:00" (UTC, vì 22 - 7 = 15)
  /// "02:00" (Vietnam) → "19:00" (UTC hôm trước, vì 2 - 7 = -5 → 24 - 5 = 19)
  ///
  /// Returns: HH:MM string trong UTC hoặc null nếu format không hợp lệ
  static String? timeStringToUtc(String vietnamTimeString) {
    final parts = vietnamTimeString.trim().split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    // Tạo DateTime tạm để convert
    final today = DateTime.now();
    final vietnamDateTime = DateTime(
      today.year,
      today.month,
      today.day,
      hour,
      minute,
    );
    final utcDateTime = toUtc(vietnamDateTime);

    return '${_pad(utcDateTime.hour)}:${_pad(utcDateTime.minute)}';
  }

  /// Chuyển chuỗi HH:MM từ UTC sang giờ Việt Nam
  ///
  /// Ví dụ:
  /// "15:00" (UTC) → "22:00" (Vietnam, vì 15 + 7 = 22)
  /// "19:00" (UTC) → "02:00" (Vietnam hôm sau, vì 19 + 7 = 26 → 2 ngày sau)
  ///
  /// Returns: HH:MM string trong giờ Việt Nam hoặc null nếu format không hợp lệ
  static String? timeStringToVietnam(String utcTimeString) {
    final parts = utcTimeString.trim().split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    // Tạo DateTime tạm để convert (tạo UTC datetime)
    final today = DateTime.now();
    final utcDateTime = DateTime.utc(
      today.year,
      today.month,
      today.day,
      hour,
      minute,
    );
    final vietnamDateTime = toVietnamTime(utcDateTime);

    return '${_pad(vietnamDateTime.hour)}:${_pad(vietnamDateTime.minute)}';
  }

  static String _pad(int value) => value.toString().padLeft(2, '0');
}
