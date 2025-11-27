import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/app_constants.dart';

class ThreePuttPieChart extends StatelessWidget {
  final double rate; // 0~1 (예: 0.12 = 12%)
  const ThreePuttPieChart({required this.rate, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: rate,
              title: '${rate.toStringAsFixed(1)}%',
              color: Colors.redAccent,
              radius: 60,
            ),
            PieChartSectionData(
              value: 100 - rate,
              title: '${(100 - rate).toStringAsFixed(1)}%',
              color: AppColors.puttsColor.withValues(alpha: 0.3),
              radius: 50,
            ),
          ],
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }
}
