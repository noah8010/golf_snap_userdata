import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/putting_stats.dart';
import 'providers.dart';

// Putting stats provider
final puttingStatsProvider = Provider<AsyncValue<PuttingStats>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final statsRepo = ref.watch(statsRepositoryProvider);

  return roundsAsync.whenData((rounds) {
    // Use existing logic in StatsRepository
    final analysis = statsRepo.getPuttAnalysis(rounds);

    // Convert PuttAnalysis to PuttingStats
    final distanceSuccessRate = <String, double>{};
    analysis.byDistance.forEach((key, value) {
      distanceSuccessRate[key] = value.successRate;
    });

    return PuttingStats(
      distanceSuccessRate: distanceSuccessRate,
      threePuttRate: analysis.threePuttRate,
      firstPuttSuccessRate: analysis.firstPuttSuccessRate,
    );
  });
});
