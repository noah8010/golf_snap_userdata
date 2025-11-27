import '../models/round.dart';
import '../models/score_trend.dart';
import '../models/score_breakdown.dart';
import '../models/score_record.dart';
import '../models/putt_analysis.dart';

class StatsRepository {
  // ===== 기존 메서드 =====
  
  // 특정 유저의 라운드만 필터링
  List<Round> filterRoundsByUser(List<Round> allRounds, String userId) {
    return allRounds.where((r) => r.userId == userId).toList();
  }

  // 평균 스코어 계산
  double calculateAverageScore(List<Round> rounds) {
    if (rounds.isEmpty) return 0.0;
    final totalScore = rounds.fold(0, (sum, r) => sum + r.totalScore);
    return totalScore / rounds.length;
  }

  // 평균 퍼팅 수 계산
  double calculateAveragePutts(List<Round> rounds) {
    if (rounds.isEmpty) return 0.0;
    final totalPutts = rounds.fold(0, (sum, r) => sum + r.totalPutts);
    return totalPutts / rounds.length;
  }

  // 드라이버 평균 비거리 (Total)
  double calculateDriverDistance(List<Round> rounds) {
    double totalDist = 0;
    int count = 0;

    for (var round in rounds) {
      for (var shot in round.shots) {
        if (shot.clubType == 'CLUB_D' && shot.shotType == 'SHOT_T' && shot.totalDistance != null) {
          totalDist += shot.totalDistance!;
          count++;
        }
      }
    }
    return count == 0 ? 0.0 : totalDist / count;
  }

  // GIR (Green in Regulation) 성공률
  double calculateGirPercentage(List<Round> rounds) {
    int totalHoles = 0;
    int girSuccess = 0;

    for (var round in rounds) {
      totalHoles += round.holes.length;
      girSuccess += round.greensInRegulation;
    }

    return totalHoles == 0 ? 0.0 : (girSuccess / totalHoles) * 100;
  }
  
  // 페어웨이 안착률
  double calculateFairwayPercentage(List<Round> rounds) {
    int totalAttempted = 0;
    int hit = 0;
    
    for (var round in rounds) {
      totalAttempted += round.fairwaysAttempted;
      hit += round.fairwaysHit;
    }
    
    return totalAttempted == 0 ? 0.0 : (hit / totalAttempted) * 100;
  }

  // ===== 신규 메서드 (Phase 1) =====

  // 1. 베스트 스코어 (골프장 정보 포함)
  ScoreRecord? getBestScoreRecord(List<Round> rounds) {
    if (rounds.isEmpty) return null;
    
    Round bestRound = rounds.first;
    for (var round in rounds) {
      if (round.totalScore < bestRound.totalScore) {
        bestRound = round;
      }
    }
    
    return ScoreRecord(
      score: bestRound.totalScore,
      courseId: bestRound.courseId,
      ccName: bestRound.ccName,
      roundId: bestRound.roundId,
      date: DateTime.parse(bestRound.playedAt),
    );
  }

  // 2. 워스트 스코어 (골프장 정보 포함)
  ScoreRecord? getWorstScoreRecord(List<Round> rounds) {
    if (rounds.isEmpty) return null;
    
    Round worstRound = rounds.first;
    for (var round in rounds) {
      if (round.totalScore > worstRound.totalScore) {
        worstRound = round;
      }
    }
    
    return ScoreRecord(
      score: worstRound.totalScore,
      courseId: worstRound.courseId,
      ccName: worstRound.ccName,
      roundId: worstRound.roundId,
      date: DateTime.parse(worstRound.playedAt),
    );
  }

  // 3. 핸디캡 계산 (간이 공식: 최근 N 라운드의 평균 - 코스 파)
  double calculateHandicap(List<Round> rounds, {int recentCount = 10}) {
    if (rounds.isEmpty) return 0.0;
    
    // 날짜순 정렬 (최신순)
    final sortedRounds = List<Round>.from(rounds)
      ..sort((a, b) => DateTime.parse(b.playedAt).compareTo(DateTime.parse(a.playedAt)));
    
    final recentRounds = sortedRounds.take(recentCount).toList();
    if (recentRounds.isEmpty) return 0.0;
    
    final avgScore = calculateAverageScore(recentRounds);
    final avgPar = recentRounds.map((r) => r.totalPar).reduce((a, b) => a + b) / recentRounds.length;
    
    return avgScore - avgPar;
  }

  // 4. 언더/오버파 평균
  double calculateAverageOverUnderPar(List<Round> rounds) {
    if (rounds.isEmpty) return 0.0;
    
    final total = rounds.fold<int>(0, (sum, r) => sum + (r.totalScore - r.totalPar));
    return total / rounds.length;
  }

  // 5. 스코어 분포
  Map<int, int> getScoreDistribution(List<Round> rounds) {
    final distribution = <int, int>{};
    
    for (var round in rounds) {
      distribution[round.totalScore] = (distribution[round.totalScore] ?? 0) + 1;
    }
    
    return Map.fromEntries(
      distribution.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );
  }

  // 6. 스코어 추세
  List<ScoreTrend> getScoreTrend(List<Round> rounds) {
    final trends = rounds.map((r) => ScoreTrend(
      date: DateTime.parse(r.playedAt),
      score: r.totalScore,
      par: r.totalPar,
      roundId: r.roundId,
      courseId: r.courseId,
    )).toList();
    
    // 날짜순 정렬
    trends.sort((a, b) => a.date.compareTo(b.date));
    
    return trends;
  }

  // 7. Par별 평균 스코어
  Map<int, double> getAverageScoreByPar(List<Round> rounds) {
    final scoresByPar = <int, List<int>>{
      3: [],
      4: [],
      5: [],
    };
    
    for (var round in rounds) {
      for (var hole in round.holes) {
        if (scoresByPar.containsKey(hole.par)) {
          scoresByPar[hole.par]!.add(hole.strokes);
        }
      }
    }
    
    final averages = <int, double>{};
    scoresByPar.forEach((par, scores) {
      averages[par] = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
    });
    
    return averages;
  }

  // 8. 홀별 평균 스코어 (1~18번)
  Map<int, double> getAverageScoreByHoleNumber(List<Round> rounds) {
    final scoresByHole = <int, List<int>>{};
    
    for (var round in rounds) {
      for (var hole in round.holes) {
        if (!scoresByHole.containsKey(hole.holeNumber)) {
          scoresByHole[hole.holeNumber] = [];
        }
        scoresByHole[hole.holeNumber]!.add(hole.strokes);
      }
    }
    
    final averages = <int, double>{};
    scoresByHole.forEach((holeNum, scores) {
      averages[holeNum] = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
    });
    
    return Map.fromEntries(
      averages.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );
  }

  // 9. 파/버디/보기 비율
  ScoreBreakdown getScoreBreakdown(List<Round> rounds) {
    int eagles = 0;
    int birdies = 0;
    int pars = 0;
    int bogeys = 0;
    int doubleBogeys = 0;
    int others = 0;
    int totalHoles = 0;
    
    for (var round in rounds) {
      for (var hole in round.holes) {
        totalHoles++;
        final diff = hole.strokes - hole.par;
        
        if (diff <= -2) {
          eagles++;
        } else if (diff == -1) {
          birdies++;
        } else if (diff == 0) {
          pars++;
        } else if (diff == 1) {
          bogeys++;
        } else if (diff == 2) {
          doubleBogeys++;
        } else {
          others++;
        }
      }
    }
    
    return ScoreBreakdown(
      eagles: eagles,
      birdies: birdies,
      pars: pars,
      bogeys: bogeys,
      doubleBogeys: doubleBogeys,
      others: others,
      totalHoles: totalHoles,
    );
  }

  // 10. 더블보기 이상 발생률
  double getDoubleBogeyOrWorseRate(List<Round> rounds) {
    int totalHoles = 0;
    int doubleBogeyOrWorse = 0;
    
    for (var round in rounds) {
      totalHoles += round.holes.length;
      doubleBogeyOrWorse += round.doubleBogeyOrWorse;
    }
    
    return totalHoles == 0 ? 0.0 : (doubleBogeyOrWorse / totalHoles) * 100;
  }

  // 11. 언더파 달성률 (홀별)
  double getUnderParRate(List<Round> rounds) {
    int totalHoles = 0;
    int underPar = 0;
    
    for (var round in rounds) {
      for (var hole in round.holes) {
        totalHoles++;
        if (hole.strokes < hole.par) {
          underPar++;
        }
      }
    }
    
    return totalHoles == 0 ? 0.0 : (underPar / totalHoles) * 100;
  }

  // ===== 퍼팅 분석 =====
  
  /// 퍼팅 분석 데이터 생성
  PuttAnalysis getPuttAnalysis(List<Round> rounds) {
    if (rounds.isEmpty) {
      return PuttAnalysis(
        byDistance: {},
        threePuttRate: 0.0,
        averagePuttsPerHole: 0.0,
        firstPuttSuccessRate: 0.0,
        totalPutts: 0,
        totalHoles: 0,
      );
    }

    // 거리 구간 정의 (미터 단위)
    final distanceRanges = [
      '0-1m',
      '1-3m',
      '3-5m',
      '5-10m',
      '10m+',
    ];

    // 거리 구간별 통계 초기화
    final Map<String, List<bool>> distanceAttempts = {
      for (var range in distanceRanges) range: [],
    };

    int totalPutts = 0;
    int totalHoles = 0;
    int threePuttHoles = 0;
    int firstPuttAttempts = 0;
    int firstPuttMade = 0;

    for (var round in rounds) {
      for (var hole in round.holes) {
        totalHoles++;
        
        // 해당 홀의 퍼팅 샷 추출
        final holePutts = round.shots
            .where((s) => s.holeScoreId == hole.holeScoreId && s.shotType == 'SHOT_P')
            .toList();

        if (holePutts.isEmpty) continue;

        totalPutts += holePutts.length;

        // 3퍼트 체크 (퍼팅이 3개 이상인 경우)
        if (holePutts.length >= 3) {
          threePuttHoles++;
        }

        // 첫 퍼트 분석
        if (holePutts.isNotEmpty) {
          firstPuttAttempts++;
          final firstPutt = holePutts.first;
          
          // 첫 퍼트가 성공했는지 확인 (다음 퍼트가 없거나, 거리가 매우 짧으면 성공으로 간주)
          if (holePutts.length == 1 || (holePutts.length > 1 && (holePutts[1].puttLength ?? 0) < 0.5)) {
            firstPuttMade++;
          }
        }

        // 거리별 퍼팅 통계
        for (var putt in holePutts) {
          final distance = putt.puttLength ?? 0.0;
          final made = putt.puttMade ?? false;

          String range;
          if (distance <= 1) {
            range = '0-1m';
          } else if (distance <= 3) {
            range = '1-3m';
          } else if (distance <= 5) {
            range = '3-5m';
          } else if (distance <= 10) {
            range = '5-10m';
          } else {
            range = '10m+';
          }

          distanceAttempts[range]?.add(made);
        }
      }
    }

    // 거리별 통계 생성
    final byDistance = <String, PuttDistanceStats>{};
    for (var range in distanceRanges) {
      final attempts = distanceAttempts[range] ?? [];
      final made = attempts.where((m) => m).length;
      final successRate = attempts.isEmpty ? 0.0 : (made / attempts.length) * 100;

      byDistance[range] = PuttDistanceStats(
        distanceRange: range,
        attempts: attempts.length,
        made: made,
        successRate: successRate,
      );
    }

    return PuttAnalysis(
      byDistance: byDistance,
      threePuttRate: totalHoles == 0 ? 0.0 : (threePuttHoles / totalHoles) * 100,
      averagePuttsPerHole: totalHoles == 0 ? 0.0 : totalPutts / totalHoles,
      firstPuttSuccessRate: firstPuttAttempts == 0 ? 0.0 : (firstPuttMade / firstPuttAttempts) * 100,
      totalPutts: totalPutts,
      totalHoles: totalHoles,
    );
  }
}
