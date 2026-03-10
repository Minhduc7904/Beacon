class TimeUtils {
  TimeUtils._();

  static const int _vnOffsetHours = 7;

  /// Chuyển [DateTime] UTC sang giờ Việt Nam (UTC+7).
  ///
  /// Nếu [dateTime] đã là local thì chuyển sang UTC trước.
  static DateTime toVietnamTime(DateTime dateTime) {
    final utc = dateTime.isUtc ? dateTime : dateTime.toUtc();
    return utc.add(const Duration(hours: _vnOffsetHours));
  }

  /// Chuyển [DateTime] giờ Việt Nam (UTC+7) về UTC.
  static DateTime toUtc(DateTime vietnamTime) {
    return vietnamTime.subtract(const Duration(hours: _vnOffsetHours));
  }

  /// Parse chuỗi ISO 8601 (có thể kèm 'Z' hoặc không) rồi trả về giờ Việt Nam.
  ///
  /// Ví dụ: `"2026-03-11T08:00:00Z"` → `2026-03-11 15:00:00`
  static DateTime parseToVietnamTime(String isoString) {
    final parsed = DateTime.parse(isoString);
    // Nếu chuỗi không có 'Z' và không có offset, coi như UTC
    final utc = parsed.isUtc
        ? parsed
        : DateTime.utc(
            parsed.year,
            parsed.month,
            parsed.day,
            parsed.hour,
            parsed.minute,
            parsed.second,
            parsed.millisecond,
            parsed.microsecond,
          );
    return toVietnamTime(utc);
  }

  /// Chuyển [DateTime] giờ Việt Nam về chuỗi ISO 8601 UTC (kèm 'Z').
  ///
  /// Ví dụ: `2026-03-11 15:00:00` → `"2026-03-11T08:00:00.000Z"`
  static String toIsoUtcString(DateTime vietnamTime) {
    return toUtc(vietnamTime).toUtc().toIso8601String();
  }

  /// Format giờ Việt Nam sang chuỗi đầy đủ ngày giờ.
  ///
  /// Ví dụ: `"11/03/2026 15:00"` hoặc `"11/03/2026 15:00:30"` nếu [withSeconds] = true
  static String formatVietnamTime(
    DateTime vietnamTime, {
    bool withSeconds = false,
  }) {
    final d = vietnamTime;
    final date = '${_pad(d.day)}/${_pad(d.month)}/${d.year}';
    final time = _formatTime(d, withSeconds: withSeconds);
    return '$date $time';
  }

  /// Chỉ format phần giờ:phút (không có ngày).
  ///
  /// Ví dụ: `"15:00"`
  static String formatTime(DateTime vietnamTime, {bool withSeconds = false}) {
    return _formatTime(vietnamTime, withSeconds: withSeconds);
  }

  /// Chỉ format phần ngày/tháng/năm (không có giờ).
  ///
  /// Ví dụ: `"11/03/2026"`
  static String formatDate(DateTime vietnamTime) {
    final d = vietnamTime;
    return '${_pad(d.day)}/${_pad(d.month)}/${d.year}';
  }

  static String _formatTime(DateTime d, {bool withSeconds = false}) {
    return withSeconds
        ? '${_pad(d.hour)}:${_pad(d.minute)}:${_pad(d.second)}'
        : '${_pad(d.hour)}:${_pad(d.minute)}';
  }

  /// Trả về DateTime hiện tại theo giờ Việt Nam.
  static DateTime nowVietnam() => toVietnamTime(DateTime.now().toUtc());

  static String _pad(int value) => value.toString().padLeft(2, '0');
}
