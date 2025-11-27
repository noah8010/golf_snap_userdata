import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/app_constants.dart';

class DistanceSuccessChart extends StatelessWidget {
  final Map<String, double> data; // key: distance range, value: success rate (0~1)
  const DistanceSuccessChart({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final order = ['0-1m', '1-3m', '3-5m', '5-10m', '10m+'];
    final sortedKeys = data.keys.toList()
      ..sort((a, b) {
        final indexA = order.indexOf(a);
        final indexB = order.indexOf(b);
        return indexA.compareTo(indexB);
      });

    final spots = <BarChartGroupData>[];
    for (int i = 0; i < sortedKeys.length; i++) {
      final key = sortedKeys[i];
      final rate = data[key] ?? 0.0;
      spots.add(
        BarChartGroupData(x: i, barRods: [
          BarChartRodData(
            toY: rate, // 이미 퍼센트 값이므로 * 100 제거
            width: 16,
            color: AppColors.puttsColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text('${value.toInt()}%'),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= sortedKeys.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(sortedKeys[idx], style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          barGroups: spots,
        ),
      ),
    );
  }
}
