import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/providers.dart';
import '../../models/benchmark_stats.dart';

class ComparisonCard extends ConsumerWidget {
  final String title;
  final double userValue;
  final String metric;
  final String unit;
  final bool lowerIsBetter;
  
  const ComparisonCard({
    super.key,
    required this.title,
    required this.userValue,
    required this.metric,
    this.unit = '',
    this.lowerIsBetter = false,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final benchmarkAsync = ref.watch(benchmarkStatsProvider);
    final percentilesAsync = ref.watch(userPercentilesProvider);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: benchmarkAsync.when(
          data: (benchmark) {
            final benchmarkValue = _getBenchmarkValue(benchmark, metric);
            final difference = userValue - benchmarkValue;
            
            return percentilesAsync.when(
              data: (percentiles) {
                final percentile = percentiles[metric] ?? 50;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title, 
                      style: TextStyle(
                        fontSize: 14, 
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      )
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${userValue.toStringAsFixed(1)}$unit',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        _buildPercentileBadge(percentile),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(height: 1),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('전체 평균', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                            SizedBox(height: 2),
                            Text(
                              '${benchmarkValue.toStringAsFixed(1)}$unit',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('차이', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                            SizedBox(height: 2),
                            Text(
                              '${difference > 0 ? '+' : ''}${difference.toStringAsFixed(1)}$unit',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _getDifferenceColor(difference),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    _buildPercentileBar(percentile),
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator(strokeWidth: 2)),
              error: (_, __) => Text('데이터 오류'),
            );
          },
          loading: () => Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, __) => Text('데이터 오류'),
        ),
      ),
    );
  }
  
  Widget _buildPercentileBadge(int percentile) {
    Color color = _getPercentileColor(percentile);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        // ignore: deprecated_member_use
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        '상위 $percentile%',
        style: TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
  
  Widget _buildPercentileBar(int percentile) {
    // Percentile is 1-100 (1 is best)
    // For display, we want the bar to be full for 1% (best) and empty for 100% (worst)
    final value = (100 - percentile) / 100.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(_getPercentileColor(percentile)),
          ),
        ),
      ],
    );
  }
  
  Color _getDifferenceColor(double diff) {
    if (diff == 0) return Colors.grey;
    
    if (lowerIsBetter) {
      return diff < 0 ? Colors.green : Colors.red;
    } else {
      return diff > 0 ? Colors.green : Colors.red;
    }
  }
  
  Color _getPercentileColor(int percentile) {
    if (percentile <= 10) return Colors.green;       // Top 10%
    if (percentile <= 30) return Colors.lightGreen;  // Top 30%
    if (percentile <= 50) return Colors.orange;      // Top 50%
    return Colors.red;                               // Bottom 50%
  }
  
  double _getBenchmarkValue(BenchmarkStats benchmark, String metric) {
    switch (metric) {
      case 'score':
        return benchmark.overall.averageScore;
      case 'fairway':
        return benchmark.overall.fairwayAccuracy;
      case 'gir':
        return benchmark.overall.girPercentage;
      case 'putts':
        return benchmark.overall.averagePutts;
      case 'driverDistance':
        return benchmark.overall.driverDistance;
      default:
        return 0;
    }
  }
}
