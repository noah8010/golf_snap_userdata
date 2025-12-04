class PuttingStats {
  final Map<String, double> distanceSuccessRate; // "0-5m": 0.78
  final double threePuttRate; // 0.12
  final double firstPuttSuccessRate; // 0.85
  final double secondPuttSuccessRate; // 0.92

  PuttingStats({
    required this.distanceSuccessRate,
    required this.threePuttRate,
    required this.firstPuttSuccessRate,
    required this.secondPuttSuccessRate,
  });
}
