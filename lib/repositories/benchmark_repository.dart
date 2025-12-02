import '../models/round.dart';
import '../models/benchmark_stats.dart';

class BenchmarkRepository {
  /// Calculate benchmark statistics from all rounds
  BenchmarkStats calculateBenchmark(List<Round> allRounds) {
    if (allRounds.isEmpty) {
      return BenchmarkStats.empty();
    }
    
    // 1. Calculate overall stats
    final overall = _calculateAggregateStats(allRounds);
    
    // 2. Sort by score for top/bottom calculation
    final sortedByScore = List<Round>.from(allRounds)
      ..sort((a, b) => a.totalScore.compareTo(b.totalScore));
    
    // 3. Top 10% rounds (lowest scores)
    final top10Count = (allRounds.length * 0.1).ceil();
    final top10Rounds = sortedByScore.take(top10Count).toList();
    final top10 = _calculateAggregateStats(top10Rounds);
    
    // 4. Bottom 10% rounds (highest scores)
    final bottom10Rounds = sortedByScore.reversed.take(top10Count).toList();
    final bottom10 = _calculateAggregateStats(bottom10Rounds);
    
    // 5. Create distributions for percentile calculation
    final distributions = _createDistributions(allRounds);
    
    return BenchmarkStats(
      overall: overall,
      top10: top10,
      bottom10: bottom10,
      scoreDistribution: distributions['score']!,
      fairwayDistribution: distributions['fairway']!,
      driverDistanceDistribution: distributions['driver']!,
      puttsDistribution: distributions['putts']!,
      girDistribution: distributions['gir']!,
    );
  }
  
  /// Calculate aggregate statistics for a list of rounds
  AggregateStats _calculateAggregateStats(List<Round> rounds) {
    if (rounds.isEmpty) return AggregateStats.empty();

    final scores = rounds.map((r) => r.totalScore.toDouble()).toList();
    
    final fairways = rounds.map((r) => 
      r.fairwaysAttempted > 0 ? r.fairwaysHit / r.fairwaysAttempted * 100 : 0.0
    ).toList();
    
    final girs = rounds.map((r) => 
      r.greensInRegulation / 18.0 * 100
    ).toList();
    
    final putts = rounds.map((r) => r.totalPutts.toDouble()).toList();
    
    // Extract driver shots from Round.shots (not Hole.shots)
    final driverShots = rounds
      .expand((r) => r.shots)
      .where((s) => s.clubType == 'CLUB_D' && !s.isMulligan)
      .toList();
    
    final driverDistances = driverShots
      .where((s) => s.totalDistance != null)
      .map((s) => s.totalDistance!)
      .toList();
    
    // Calculate putting success rates
    final puttingByDistance = _calculatePuttingSuccessRates(rounds);
    
    // Calculate 3-putt rate
    final threePuttCount = rounds
      .expand((r) => r.holes)
      .where((h) => h.putts >= 3)
      .length;
    final totalHoles = rounds.length * 18;
    final threePuttRate = totalHoles > 0 ? (threePuttCount / totalHoles) * 100 : 0.0;
    
    return AggregateStats(
      averageScore: _average(scores),
      fairwayAccuracy: _average(fairways),
      girPercentage: _average(girs),
      averagePutts: _average(putts),
      driverDistance: driverDistances.isEmpty ? 0 : _average(driverDistances),
      threePuttRate: threePuttRate,
      puttingByDistance: puttingByDistance,
    );
  }
  
  /// Calculate putting success rates by distance
  Map<String, double> _calculatePuttingSuccessRates(List<Round> rounds) {
    final puttsByDistance = <String, List<bool>>{
      '0-1m': [],
      '1-3m': [],
      '3-5m': [],
      '5-10m': [],
      '10m+': [],
    };
    
    for (var round in rounds) {
      // Use Round.shots instead of Hole.shots
      for (var shot in round.shots) {
        if (shot.isPutt && shot.puttLength != null) {
          final distance = shot.puttLength!;
          final made = shot.puttMade ?? false;
          
          if (distance <= 1) {
            puttsByDistance['0-1m']!.add(made);
          } else if (distance <= 3) {
            puttsByDistance['1-3m']!.add(made);
          } else if (distance <= 5) {
            puttsByDistance['3-5m']!.add(made);
          } else if (distance <= 10) {
            puttsByDistance['5-10m']!.add(made);
          } else {
            puttsByDistance['10m+']!.add(made);
          }
        }
      }
    }
    
    return puttsByDistance.map((key, putts) {
      if (putts.isEmpty) return MapEntry(key, 0.0);
      final successCount = putts.where((made) => made).length;
      return MapEntry(key, (successCount / putts.length) * 100);
    });
  }
  
  /// Create distributions for percentile calculation
  Map<String, List<double>> _createDistributions(List<Round> rounds) {
    final List<double> scores = List<double>.from(rounds.map((r) => r.totalScore.toDouble()))..sort();
    
    final List<double> fairways = List<double>.from(rounds
      .map((r) => r.fairwaysAttempted > 0 ? r.fairwaysHit / r.fairwaysAttempted * 100 : 0.0))..sort();
      
    final List<double> girs = List<double>.from(rounds
      .map((r) => r.greensInRegulation / 18.0 * 100))..sort();
      
    final List<double> putts = List<double>.from(rounds
      .map((r) => r.totalPutts.toDouble()))..sort();
    
    final List<double> driverDistances = List<double>.from(rounds
      .expand((r) => r.shots)
      .where((s) => s.clubType == 'CLUB_D' && s.totalDistance != null)
      .map((s) => s.totalDistance!))..sort();
    
    return {
      'score': scores,
      'fairway': fairways,
      'gir': girs,
      'putts': putts,
      'driver': driverDistances,
    };
  }
  
  /// Calculate percentile for a given value in a distribution
  /// Returns 0-100, where 100 is the best (top 1%)
  int calculatePercentile(double userValue, List<double> distribution, {bool lowerIsBetter = false}) {
    if (distribution.isEmpty) return 50;
    
    int betterCount = 0;
    for (var value in distribution) {
      if (lowerIsBetter) {
        if (userValue < value) betterCount++;
      } else {
        if (userValue > value) betterCount++;
      }
    }
    
    return (betterCount * 100 / distribution.length).round();
  }
  
  /// Helper to calculate average
  double _average(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
}
