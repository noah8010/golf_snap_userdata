/// 드라이버 분석 데이터 모델
class DriverAnalysis {
  // 비거리 분석
  final double averageTotalDistance; // 평균 총 비거리
  final double averageCarryDistance; // 평균 캐리 거리
  final double averageRun; // 평균 런
  final double maxDistance; // 최장 비거리
  final double distanceStdDev; // 비거리 표준편차 (일관성)
  
  // 정확도 분석
  final double fairwayHitRate; // 페어웨이 적중률
  final double averageSideDeviation; // 평균 좌우 편차 (절대값)
  final double sideDeviationStdDev; // 좌우 편차 표준편차
  
  // 페널티 분석
  final double obRate; // OB 발생률
  final double hazardRate; // 해저드 발생률
  final int totalPenalties; // 총 페널티 수
  
  // 구질 분석
  final Map<String, int> ballFlightDistribution; // 구질별 분포 {"draw": 10, "fade": 15, "straight": 5}
  final Map<String, double> ballFlightAvgDistance; // 구질별 평균 비거리
  
  // 스윙 효율성
  final double averageBallSpeed; // 평균 볼 스피드
  final double averageClubSpeed; // 평균 클럽 스피드
  final double averageSmashFactor; // 평균 스매시 팩터
  
  // 발사 조건
  final double averageLaunchAngle; // 평균 발사각
  final double averageSpinRate; // 평균 스핀량
  final double averageAttackAngle; // 평균 어택 앵글
  
  // 탄착군 데이터 (산점도용)
  final List<DispersionPoint> dispersionPoints; // 탄착 좌표 리스트
  
  // 기본 정보
  final int totalShots; // 총 드라이버 샷 수
  final int totalRounds; // 총 라운드 수

  DriverAnalysis({
    required this.averageTotalDistance,
    required this.averageCarryDistance,
    required this.averageRun,
    required this.maxDistance,
    required this.distanceStdDev,
    required this.fairwayHitRate,
    required this.averageSideDeviation,
    required this.sideDeviationStdDev,
    required this.obRate,
    required this.hazardRate,
    required this.totalPenalties,
    required this.ballFlightDistribution,
    required this.ballFlightAvgDistance,
    required this.averageBallSpeed,
    required this.averageClubSpeed,
    required this.averageSmashFactor,
    required this.averageLaunchAngle,
    required this.averageSpinRate,
    required this.averageAttackAngle,
    required this.dispersionPoints,
    required this.totalShots,
    required this.totalRounds,
  });

  factory DriverAnalysis.empty() {
    return DriverAnalysis(
      averageTotalDistance: 0.0,
      averageCarryDistance: 0.0,
      averageRun: 0.0,
      maxDistance: 0.0,
      distanceStdDev: 0.0,
      fairwayHitRate: 0.0,
      averageSideDeviation: 0.0,
      sideDeviationStdDev: 0.0,
      obRate: 0.0,
      hazardRate: 0.0,
      totalPenalties: 0,
      ballFlightDistribution: {},
      ballFlightAvgDistance: {},
      averageBallSpeed: 0.0,
      averageClubSpeed: 0.0,
      averageSmashFactor: 0.0,
      averageLaunchAngle: 0.0,
      averageSpinRate: 0.0,
      averageAttackAngle: 0.0,
      dispersionPoints: [],
      totalShots: 0,
      totalRounds: 0,
    );
  }
}

/// 탄착군 좌표 데이터
class DispersionPoint {
  final double carry; // 캐리 거리 (Y축)
  final double side; // 좌우 편차 (X축)
  final String ballFlight; // 구질 ("draw", "fade", "straight")

  DispersionPoint({
    required this.carry,
    required this.side,
    required this.ballFlight,
  });
}
