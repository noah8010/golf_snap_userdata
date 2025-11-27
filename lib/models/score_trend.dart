class ScoreTrend {
  final DateTime date;
  final int score;
  final int par;
  final String roundId;
  final String courseId;

  ScoreTrend({
    required this.date,
    required this.score,
    required this.par,
    required this.roundId,
    required this.courseId,
  });

  int get overUnderPar => score - par;
}
