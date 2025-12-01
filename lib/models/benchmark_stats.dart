
class BenchmarkStats {
  final AggregateStats overall;
  final AggregateStats top10;
  final AggregateStats bottom10;
  
  // Distributions for percentile calculation
  final List<double> scoreDistribution;
  final List<double> fairwayDistribution;
  final List<double> driverDistanceDistribution;
  final List<double> puttsDistribution;
  final List<double> girDistribution;

  BenchmarkStats({
    required this.overall,
    required this.top10,
    required this.bottom10,
    required this.scoreDistribution,
    required this.fairwayDistribution,
    required this.driverDistanceDistribution,
    required this.puttsDistribution,
    required this.girDistribution,
  });

  factory BenchmarkStats.empty() {
    return BenchmarkStats(
      overall: AggregateStats.empty(),
      top10: AggregateStats.empty(),
      bottom10: AggregateStats.empty(),
      scoreDistribution: [],
      fairwayDistribution: [],
      driverDistanceDistribution: [],
      puttsDistribution: [],
      girDistribution: [],
    );
  }
}

class AggregateStats {
  final double averageScore;
  final double fairwayAccuracy;
  final double girPercentage;
  final double averagePutts;
  final double driverDistance;
  final double threePuttRate;
  final Map<String, double> puttingByDistance;

  AggregateStats({
    required this.averageScore,
    required this.fairwayAccuracy,
    required this.girPercentage,
    required this.averagePutts,
    required this.driverDistance,
    required this.threePuttRate,
    required this.puttingByDistance,
  });

  factory AggregateStats.empty() {
    return AggregateStats(
      averageScore: 0,
      fairwayAccuracy: 0,
      girPercentage: 0,
      averagePutts: 0,
      driverDistance: 0,
      threePuttRate: 0,
      puttingByDistance: {},
    );
  }
}
