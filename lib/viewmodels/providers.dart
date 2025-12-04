import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/round.dart';
import '../models/code_master.dart';
import '../models/score_trend.dart';
import '../models/score_breakdown.dart';
import '../models/score_record.dart';
import '../models/putt_analysis.dart';
import '../models/driver_analysis.dart';
import '../repositories/asset_repository.dart';
import '../repositories/stats_repository.dart';
import '../repositories/driver_repository.dart';
import '../repositories/benchmark_repository.dart';
import '../models/benchmark_stats.dart';

// Repositories
final assetRepositoryProvider = Provider((ref) => AssetRepository());
final statsRepositoryProvider = Provider((ref) => StatsRepository());
final driverRepositoryProvider = Provider((ref) => DriverRepository());
final benchmarkRepositoryProvider = Provider((ref) => BenchmarkRepository());

// Data Providers
final allRoundsProvider = FutureProvider<List<Round>>((ref) async {
  final repository = ref.watch(assetRepositoryProvider);
  return repository.loadRounds();
});

final codeMastersProvider = FutureProvider<List<CodeMaster>>((ref) async {
  final repository = ref.watch(assetRepositoryProvider);
  return repository.loadCodeMasters();
});

// User ID (현재는 하드코딩된 'noah.nam' 사용)
final currentUserIdProvider = StateProvider<String>((ref) => 'beginner.user001');

// Stats Limit (null means all rounds)
final statsLimitProvider = StateProvider<int?>((ref) => 10);

// Filtered Rounds (User + Limit)
final filteredRoundsProvider = Provider<AsyncValue<List<Round>>>((ref) {
  final allRoundsAsync = ref.watch(allRoundsProvider);
  final userId = ref.watch(currentUserIdProvider);
  final limit = ref.watch(statsLimitProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return allRoundsAsync.whenData((rounds) {
    final userRounds = statsRepo.filterRoundsByUser(rounds, userId);
    
    // Sort by date descending to get "recent" rounds
    userRounds.sort((a, b) => b.playedAt.compareTo(a.playedAt));

    if (limit != null && userRounds.length > limit) {
      return userRounds.take(limit).toList();
    }
    return userRounds;
  });
});

// User Rounds (All rounds for user, without limit - used for list view if needed)
final userRoundsProvider = Provider<AsyncValue<List<Round>>>((ref) {
  final allRoundsAsync = ref.watch(allRoundsProvider);
  final userId = ref.watch(currentUserIdProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return allRoundsAsync.whenData((rounds) {
    return statsRepo.filterRoundsByUser(rounds, userId);
  });
});

// ===== 기존 통계 Providers (Updated to use filteredRoundsProvider) =====

final userStatsProvider = Provider<AsyncValue<Map<String, double>>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return {
      'avgScore': statsRepo.calculateAverageScore(rounds),
      'avgPutts': statsRepo.calculateAveragePutts(rounds),
      'driverDist': statsRepo.calculateDriverDistance(rounds),
      'gir': statsRepo.calculateGirPercentage(rounds),
      'fairway': statsRepo.calculateFairwayPercentage(rounds),
      'threePuttRate': statsRepo.getPuttAnalysis(rounds).threePuttRate,
    };
  });
});

// ===== 신규 통계 Providers (Phase 1) =====

// 스코어 범위 (베스트/워스트) - ScoreRecord 반환
final scoreRecordsProvider = Provider<AsyncValue<Map<String, ScoreRecord?>>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return {
      'best': statsRepo.getBestScoreRecord(rounds),
      'worst': statsRepo.getWorstScoreRecord(rounds),
    };
  });
});

// 핸디캡
final handicapProvider = Provider<AsyncValue<double>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return statsRepo.calculateHandicap(rounds);
  });
});

// 언더/오버파 평균
final overUnderParProvider = Provider<AsyncValue<double>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return statsRepo.calculateAverageOverUnderPar(rounds);
  });
});

// 스코어 분포
final scoreDistributionProvider = Provider<AsyncValue<Map<int, int>>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return statsRepo.getScoreDistribution(rounds);
  });
});

// 스코어 추세
final scoreTrendProvider = Provider<AsyncValue<List<ScoreTrend>>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return statsRepo.getScoreTrend(rounds);
  });
});

// Par별 평균 스코어
final scoreByParProvider = Provider<AsyncValue<Map<int, double>>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return statsRepo.getAverageScoreByPar(rounds);
  });
});

// 홀별 평균 스코어
final scoreByHoleProvider = Provider<AsyncValue<Map<int, double>>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return statsRepo.getAverageScoreByHoleNumber(rounds);
  });
});

// 스코어 분류 (파/버디/보기 등)
final scoreBreakdownProvider = Provider<AsyncValue<ScoreBreakdown>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return statsRepo.getScoreBreakdown(rounds);
  });
});

// 더블보기 이상 발생률
final doubleBogeyRateProvider = Provider<AsyncValue<double>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return statsRepo.getDoubleBogeyOrWorseRate(rounds);
  });
});

// 언더파 달성률
final underParRateProvider = Provider<AsyncValue<double>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return statsRepo.getUnderParRate(rounds);
  });
});

// 퍼팅 분석
final puttAnalysisProvider = Provider<AsyncValue<PuttAnalysis>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return statsRepo.getPuttAnalysis(rounds);
  });
});

// 드라이버 분석
final driverAnalysisProvider = Provider<AsyncValue<DriverAnalysis>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final driverRepo = ref.watch(driverRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    return driverRepo.getDriverAnalysis(rounds);
  });
});

// ===== 비교 통계 Providers =====

// 벤치마크 통계
final benchmarkStatsProvider = Provider<AsyncValue<BenchmarkStats>>((ref) {
  final allRoundsAsync = ref.watch(allRoundsProvider);
  final repo = ref.watch(benchmarkRepositoryProvider);

  return allRoundsAsync.whenData((rounds) {
    return repo.calculateBenchmark(rounds);
  });
});

// 사용자 퍼센타일
final userPercentilesProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  final benchmarkAsync = ref.watch(benchmarkStatsProvider);
  final userStatsAsync = ref.watch(userStatsProvider);
  final driverStatsAsync = ref.watch(driverAnalysisProvider);
  final repo = ref.watch(benchmarkRepositoryProvider);

  return benchmarkAsync.whenData((benchmark) {
    return userStatsAsync.whenData((userStats) {
      return driverStatsAsync.whenData((driverStats) {
        return {
          'score': repo.calculatePercentile(
            userStats['avgScore'] ?? 0,
            benchmark.scoreDistribution,
            lowerIsBetter: true,
          ),
          'fairway': repo.calculatePercentile(
            userStats['fairway'] ?? 0,
            benchmark.fairwayDistribution,
          ),
          'driverDistance': repo.calculatePercentile(
            driverStats.averageTotalDistance ?? 0,
            benchmark.driverDistanceDistribution,
          ),
          'putts': repo.calculatePercentile(
            userStats['avgPutts'] ?? 0,
            benchmark.puttsDistribution,
            lowerIsBetter: true,
          ),
          'gir': repo.calculatePercentile(
            userStats['gir'] ?? 0,
            benchmark.girDistribution,
          ),
        };
      }).value ?? {};
    }).value ?? {};
  });
});
