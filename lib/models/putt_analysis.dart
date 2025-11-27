/// 퍼팅 분석 데이터 모델
class PuttAnalysis {
  final Map<String, PuttDistanceStats> byDistance; // 거리 구간별 통계
  final double threePuttRate; // 3퍼트 비율
  final double averagePuttsPerHole; // 홀당 평균 퍼트 수
  final double firstPuttSuccessRate; // 첫 퍼트 성공률
  final int totalPutts; // 총 퍼트 수
  final int totalHoles; // 총 홀 수

  PuttAnalysis({
    required this.byDistance,
    required this.threePuttRate,
    required this.averagePuttsPerHole,
    required this.firstPuttSuccessRate,
    required this.totalPutts,
    required this.totalHoles,
  });
}

/// 거리 구간별 퍼팅 통계
class PuttDistanceStats {
  final String distanceRange; // 예: "0-3m"
  final int attempts; // 시도 횟수
  final int made; // 성공 횟수
  final double successRate; // 성공률

  PuttDistanceStats({
    required this.distanceRange,
    required this.attempts,
    required this.made,
    required this.successRate,
  });

  factory PuttDistanceStats.empty(String range) {
    return PuttDistanceStats(
      distanceRange: range,
      attempts: 0,
      made: 0,
      successRate: 0.0,
    );
  }
}
