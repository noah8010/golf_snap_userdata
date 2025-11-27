class ScoreRecord {
  final int score;
  final String courseId;
  final String? ccName;
  final String roundId;
  final DateTime date;

  ScoreRecord({
    required this.score,
    required this.courseId,
    this.ccName,
    required this.roundId,
    required this.date,
  });
}
