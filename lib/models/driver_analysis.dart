/// 드라이버 샷 분석 데이터 모델
///
/// 드라이버 샷의 종합적인 통계 정보를 담고 있는 데이터 클래스입니다.
/// 비거리, 정확도, 페널티, 구질, 스윙 효율성, 발사 조건 등 8가지 카테고리의
/// 통계를 제공합니다.
///
/// 사용 예시:
/// ```dart
/// final analysis = ref.watch(driverAnalysisProvider);
/// print('평균 비거리: ${analysis.averageTotalDistance}m');
/// ```
class DriverAnalysis {
  // ===== 비거리 분석 =====
  /// 평균 총 비거리 (캐리 + 런)
  final double averageTotalDistance;
  
  /// 평균 캐리 거리 (공이 날아간 거리)
  final double averageCarryDistance;
  
  /// 평균 런 (착지 후 굴러간 거리)
  final double averageRun;
  
  /// 최장 비거리 (기록된 최대 거리)
  final double maxDistance;
  
  /// 비거리 표준편차 (일관성 지표, 낮을수록 일관적)
  final double distanceStdDev;
  
  // ===== 정확도 분석 =====
  /// 페어웨이 적중률 (%)
  final double fairwayHitRate;
  
  /// 평균 좌우 편차 (절대값, 미터)
  final double averageSideDeviation;
  
  /// 좌우 편차 표준편차 (방향 일관성 지표)
  final double sideDeviationStdDev;
  
  // ===== 페널티 분석 =====
  /// OB 발생률 (%)
  final double obRate;
  
  /// 해저드 발생률 (%)
  final double hazardRate;
  
  /// 총 페널티 수
  final int totalPenalties;
  
  // ===== 구질 분석 =====
  /// 구질별 분포 {"draw": 10, "fade": 15, "straight": 5}
  final Map<String, int> ballFlightDistribution;
  
  /// 구질별 평균 비거리 {"draw": 250.0, "fade": 245.0, "straight": 255.0}
  final Map<String, double> ballFlightAvgDistance;
  
  // ===== 스윙 효율성 =====
  /// 평균 볼 스피드 (m/s)
  final double averageBallSpeed;
  
  /// 평균 클럽 스피드 (m/s)
  final double averageClubSpeed;
  
  /// 평균 스매시 팩터 (이상적: 1.48-1.50)
  final double averageSmashFactor;
  
  // ===== 발사 조건 =====
  /// 평균 발사각 (도, 이상적: 10-14도)
  final double averageLaunchAngle;
  
  /// 평균 스핀량 (RPM, 이상적: 2000-2800)
  final double averageSpinRate;
  
  /// 평균 어택 앵글 (도, 이상적: +2~+5도)
  final double averageAttackAngle;
  
  // ===== 탄착군 데이터 =====
  /// 탄착 좌표 리스트 (산점도 차트용)
  final List<DispersionPoint> dispersionPoints;
  
  // ===== 기본 정보 =====
  /// 총 드라이버 샷 수
  final int totalShots;
  
  /// 총 라운드 수
  final int totalRounds;

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

  /// 빈 분석 데이터 생성 (데이터가 없을 때 사용)
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
