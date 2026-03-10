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

  static String _pad(int value) => value.toString().padLeft(2, '0');
}
