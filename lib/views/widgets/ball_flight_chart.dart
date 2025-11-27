import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/driver_analysis.dart';
import '../../utils/app_constants.dart';

class BallFlightChart extends StatelessWidget {
  final DriverAnalysis analysis;

  const BallFlightChart({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final distribution = analysis.ballFlightDistribution;
    final avgDistance = analysis.ballFlightAvgDistance;

    final totalShots = distribution.values.fold<int>(0, (sum, count) => sum + count);

    if (totalShots == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppStyles.cardPadding),
          child: Center(
            child: Text('구질 데이터가 없습니다'),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.cardPadding),
        child: Column(
          children: [
            // 파이 차트
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _createSections(distribution, totalShots),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 범례 및 평균 비거리
            _buildLegend(distribution, avgDistance, totalShots),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createSections(Map<String, int> distribution, int total) {
    final sections = <PieChartSectionData>[];

    distribution.forEach((flight, count) {
      if (count > 0) {
        final percentage = (count / total) * 100;
        final color = _getFlightColor(flight);

        sections.add(
          PieChartSectionData(
            value: count.toDouble(),
            title: '${percentage.toStringAsFixed(0)}%',
            color: color,
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    });

    return sections;
  }

  Color _getFlightColor(String flight) {
    switch (flight) {
      case 'draw':
        return Colors.blue;
      case 'fade':
        return Colors.orange;
      case 'straight':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getFlightLabel(String flight) {
    switch (flight) {
      case 'draw':
        return '드로우';
      case 'fade':
        return '페이드';
      case 'straight':
        return '스트레이트';
      default:
        return flight;
    }
  }

  Widget _buildLegend(Map<String, int> distribution, Map<String, double> avgDistance, int total) {
    return Column(
      children: distribution.entries.where((e) => e.value > 0).map((entry) {
        final flight = entry.key;
        final count = entry.value;
        final percentage = (count / total) * 100;
        final distance = avgDistance[flight] ?? 0.0;
        final color = _getFlightColor(flight);
        final label = _getFlightLabel(flight);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                '$count회 (${percentage.toStringAsFixed(0)}%)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '평균 ${distance.toStringAsFixed(1)}m',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
