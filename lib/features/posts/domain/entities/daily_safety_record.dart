class DailySafetyRecord {
  final String id;
  final String userId;
  final String date;
  final String status;
  final DateTime? deadlineAtUtc;
  final DateTime? checkedInAtUtc;
  final DateTime? markedMissedAtUtc;
  final DateTime? reminderSentAtUtc;
  final DateTime? resolvedAtUtc;
  final DateTime? lastEvaluatedAtUtc;

  const DailySafetyRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    required this.deadlineAtUtc,
    required this.checkedInAtUtc,
    required this.markedMissedAtUtc,
    required this.reminderSentAtUtc,
    required this.resolvedAtUtc,
    required this.lastEvaluatedAtUtc,
  });
}
