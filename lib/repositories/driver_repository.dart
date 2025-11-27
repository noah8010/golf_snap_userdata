import 'dart:math';
import '../models/round.dart';
import '../models/shot.dart';
import '../models/hole.dart';
import '../models/driver_analysis.dart';

class DriverRepository {
  /// 드라이버 샷 필터링
  List<Shot> _getDriverShots(List<Round> rounds) {
    final List<Shot> driverShots = [];
    
    for (var round in rounds) {
      for (var shot in round.shots) {
        // 드라이버 티샷만 필터링 (멀리건 제외, 유효한 데이터만)
        if (shot.clubType == 'CLUB_D' &&
            shot.shotType == 'SHOT_T' &&
            !shot.isMulligan &&
            shot.totalDistance != null &&
            shot.totalDistance! > 0 &&
            shot.totalDistance! < 400) { // 비정상 데이터 필터링
          driverShots.add(shot);
        }
      }
    }
    
    return driverShots;
  }

  /// 드라이버 분석 데이터 생성
  DriverAnalysis getDriverAnalysis(List<Round> rounds) {
    if (rounds.isEmpty) {
      return DriverAnalysis.empty();
    }

    final driverShots = _getDriverShots(rounds);
    
    if (driverShots.isEmpty) {
      return DriverAnalysis.empty();
    }

    return DriverAnalysis(
      // 비거리 분석
      averageTotalDistance: _calculateAverageTotalDistance(driverShots),
      averageCarryDistance: _calculateAverageCarryDistance(driverShots),
      averageRun: _calculateAverageRun(driverShots),
      maxDistance: _calculateMaxDistance(driverShots),
      distanceStdDev: _calculateDistanceStdDev(driverShots),
      
      // 정확도 분석
      fairwayHitRate: _calculateFairwayHitRate(rounds, driverShots),
      averageSideDeviation: _calculateAverageSideDeviation(driverShots),
      sideDeviationStdDev: _calculateSideDeviationStdDev(driverShots),
      
      // 페널티 분석
      obRate: _calculateOBRate(rounds, driverShots),
      hazardRate: _calculateHazardRate(rounds, driverShots),
      totalPenalties: _calculateTotalPenalties(rounds, driverShots),
      
      // 구질 분석
      ballFlightDistribution: _calculateBallFlightDistribution(driverShots),
      ballFlightAvgDistance: _calculateBallFlightAvgDistance(driverShots),
      
      // 스윙 효율성
      averageBallSpeed: _calculateAverageBallSpeed(driverShots),
      averageClubSpeed: _calculateAverageClubSpeed(driverShots),
      averageSmashFactor: _calculateAverageSmashFactor(driverShots),
      
      // 발사 조건
      averageLaunchAngle: _calculateAverageLaunchAngle(driverShots),
      averageSpinRate: _calculateAverageSpinRate(driverShots),
      averageAttackAngle: _calculateAverageAttackAngle(driverShots),
      
      // 탄착군 데이터
      dispersionPoints: _createDispersionPoints(driverShots),
      
      // 기본 정보
      totalShots: driverShots.length,
      totalRounds: rounds.length,
    );
  }

  // ===== 비거리 분석 =====
  
  double _calculateAverageTotalDistance(List<Shot> shots) {
    if (shots.isEmpty) return 0.0;
    final total = shots.fold<double>(0.0, (sum, s) => sum + (s.totalDistance ?? 0.0));
    return total / shots.length;
  }

  double _calculateAverageCarryDistance(List<Shot> shots) {
    final validShots = shots.where((s) => s.carryDistance != null).toList();
    if (validShots.isEmpty) return 0.0;
    final total = validShots.fold<double>(0.0, (sum, s) => sum + s.carryDistance!);
    return total / validShots.length;
  }

  double _calculateAverageRun(List<Shot> shots) {
    final validShots = shots.where((s) => 
      s.totalDistance != null && s.carryDistance != null
    ).toList();
    if (validShots.isEmpty) return 0.0;
    final totalRun = validShots.fold<double>(0.0, (sum, s) => 
      sum + (s.totalDistance! - s.carryDistance!)
    );
    return totalRun / validShots.length;
  }

  double _calculateMaxDistance(List<Shot> shots) {
    if (shots.isEmpty) return 0.0;
    return shots.map((s) => s.totalDistance ?? 0.0).reduce(max);
  }

  double _calculateDistanceStdDev(List<Shot> shots) {
    if (shots.length < 2) return 0.0;
    final avg = _calculateAverageTotalDistance(shots);
    final variance = shots.fold<double>(0.0, (sum, s) {
      final diff = (s.totalDistance ?? 0.0) - avg;
      return sum + (diff * diff);
    }) / shots.length;
    return sqrt(variance);
  }

  // ===== 정확도 분석 =====
  
  double _calculateFairwayHitRate(List<Round> rounds, List<Shot> driverShots) {
    if (driverShots.isEmpty) return 0.0;
    
    int fairwayHits = 0;
    int totalAttempts = 0;
    
    for (var round in rounds) {
      for (var shot in driverShots) {
        // 해당 라운드의 샷인지 확인
        if (round.shots.contains(shot)) {
          totalAttempts++;
          // 다음 샷의 라이가 페어웨이인지 확인
          final shotIndex = round.shots.indexOf(shot);
          if (shotIndex < round.shots.length - 1) {
            final nextShot = round.shots[shotIndex + 1];
            if (nextShot.lie == 'LIE_FAIR') {
              fairwayHits++;
            }
          }
        }
      }
    }
    
    return totalAttempts == 0 ? 0.0 : (fairwayHits / totalAttempts) * 100;
  }

  double _calculateAverageSideDeviation(List<Shot> shots) {
    final validShots = shots.where((s) => s.sideDeviation != null).toList();
    if (validShots.isEmpty) return 0.0;
    final total = validShots.fold<double>(0.0, (sum, s) => sum + (s.sideDeviation!).abs());
    return total / validShots.length;
  }

  double _calculateSideDeviationStdDev(List<Shot> shots) {
    final validShots = shots.where((s) => s.sideDeviation != null).toList();
    if (validShots.length < 2) return 0.0;
    
    final avg = validShots.fold<double>(0.0, (sum, s) => sum + s.sideDeviation!) / validShots.length;
    final variance = validShots.fold<double>(0.0, (sum, s) {
      final diff = s.sideDeviation! - avg;
      return sum + (diff * diff);
    }) / validShots.length;
    return sqrt(variance);
  }

  // ===== 페널티 분석 =====
  
  double _calculateOBRate(List<Round> rounds, List<Shot> driverShots) {
    if (driverShots.isEmpty) return 0.0;
    
    int obCount = 0;
    
    for (var round in rounds) {
      for (var shot in driverShots) {
        if (round.shots.contains(shot)) {
          final shotIndex = round.shots.indexOf(shot);
          if (shotIndex < round.shots.length - 1) {
            final nextShot = round.shots[shotIndex + 1];
            if (nextShot.lie == 'LIE_OB') {
              obCount++;
            }
          }
        }
      }
    }
    
    return (obCount / driverShots.length) * 100;
  }

  double _calculateHazardRate(List<Round> rounds, List<Shot> driverShots) {
    if (driverShots.isEmpty) return 0.0;
    
    int hazardCount = 0;
    
    for (var round in rounds) {
      for (var shot in driverShots) {
        if (round.shots.contains(shot)) {
          final shotIndex = round.shots.indexOf(shot);
          if (shotIndex < round.shots.length - 1) {
            final nextShot = round.shots[shotIndex + 1];
            if (nextShot.lie == 'LIE_WATER') {
              hazardCount++;
            }
          }
        }
      }
    }
    
    return (hazardCount / driverShots.length) * 100;
  }

  int _calculateTotalPenalties(List<Round> rounds, List<Shot> driverShots) {
    int penalties = 0;
    
    for (var round in rounds) {
      for (var shot in driverShots) {
        if (round.shots.contains(shot)) {
          final shotIndex = round.shots.indexOf(shot);
          if (shotIndex < round.shots.length - 1) {
            final nextShot = round.shots[shotIndex + 1];
            if (nextShot.lie == 'LIE_OB' || nextShot.lie == 'LIE_WATER') {
              penalties++;
            }
          }
        }
      }
    }
    
    return penalties;
  }

  // ===== 구질 분석 =====
  
  String _classifyBallFlight(Shot shot) {
    // 스핀 축 기반 구질 분류
    final spinAxis = shot.spinAxis;
    final sideSpin = shot.sideSpin;
    
    if (spinAxis == null && sideSpin == null) {
      return 'straight';
    }
    
    // 스핀 축이 있으면 우선 사용
    if (spinAxis != null) {
      if (spinAxis < -5) {
        return 'draw'; // 왼쪽으로 휘는 구질
      } else if (spinAxis > 5) {
        return 'fade'; // 오른쪽으로 휘는 구질
      }
    }
    
    // 사이드 스핀으로 판단
    if (sideSpin != null) {
      if (sideSpin < -200) {
        return 'draw';
      } else if (sideSpin > 200) {
        return 'fade';
      }
    }
    
    return 'straight';
  }

  Map<String, int> _calculateBallFlightDistribution(List<Shot> shots) {
    final distribution = <String, int>{
      'draw': 0,
      'fade': 0,
      'straight': 0,
    };
    
    for (var shot in shots) {
      final flight = _classifyBallFlight(shot);
      distribution[flight] = (distribution[flight] ?? 0) + 1;
    }
    
    return distribution;
  }

  Map<String, double> _calculateBallFlightAvgDistance(List<Shot> shots) {
    final distanceByFlight = <String, List<double>>{
      'draw': [],
      'fade': [],
      'straight': [],
    };
    
    for (var shot in shots) {
      final flight = _classifyBallFlight(shot);
      if (shot.totalDistance != null) {
        distanceByFlight[flight]?.add(shot.totalDistance!);
      }
    }
    
    final avgDistance = <String, double>{};
    distanceByFlight.forEach((flight, distances) {
      avgDistance[flight] = distances.isEmpty 
        ? 0.0 
        : distances.reduce((a, b) => a + b) / distances.length;
    });
    
    return avgDistance;
  }

  // ===== 스윙 효율성 =====
  
  double _calculateAverageBallSpeed(List<Shot> shots) {
    final validShots = shots.where((s) => s.ballSpeed != null).toList();
    if (validShots.isEmpty) return 0.0;
    final total = validShots.fold<double>(0.0, (sum, s) => sum + s.ballSpeed!);
    return total / validShots.length;
  }

  double _calculateAverageClubSpeed(List<Shot> shots) {
    final validShots = shots.where((s) => s.clubSpeed != null).toList();
    if (validShots.isEmpty) return 0.0;
    final total = validShots.fold<double>(0.0, (sum, s) => sum + s.clubSpeed!);
    return total / validShots.length;
  }

  double _calculateAverageSmashFactor(List<Shot> shots) {
    final validShots = shots.where((s) => s.smashFactor != null).toList();
    if (validShots.isEmpty) return 0.0;
    final total = validShots.fold<double>(0.0, (sum, s) => sum + s.smashFactor!);
    return total / validShots.length;
  }

  // ===== 발사 조건 =====
  
  double _calculateAverageLaunchAngle(List<Shot> shots) {
    final validShots = shots.where((s) => s.launchAngle != null).toList();
    if (validShots.isEmpty) return 0.0;
    final total = validShots.fold<double>(0.0, (sum, s) => sum + s.launchAngle!);
    return total / validShots.length;
  }

  double _calculateAverageSpinRate(List<Shot> shots) {
    final validShots = shots.where((s) => s.spinRate != null).toList();
    if (validShots.isEmpty) return 0.0;
    final total = validShots.fold<double>(0.0, (sum, s) => sum + s.spinRate!);
    return total / validShots.length;
  }

  double _calculateAverageAttackAngle(List<Shot> shots) {
    final validShots = shots.where((s) => s.attackAngle != null).toList();
    if (validShots.isEmpty) return 0.0;
    final total = validShots.fold<double>(0.0, (sum, s) => sum + s.attackAngle!);
    return total / validShots.length;
  }

  // ===== 탄착군 데이터 =====
  
  List<DispersionPoint> _createDispersionPoints(List<Shot> shots) {
    final points = <DispersionPoint>[];
    
    for (var shot in shots) {
      if (shot.carryDistance != null && shot.sideDeviation != null) {
        points.add(DispersionPoint(
          carry: shot.carryDistance!,
          side: shot.sideDeviation!,
          ballFlight: _classifyBallFlight(shot),
        ));
      }
    }
    
    return points;
  }
}
