import 'package:flutter/material.dart';
import '../../models/driver_analysis.dart';
import '../../utils/app_constants.dart';

class AccuracyStatsCard extends StatelessWidget {
  final DriverAnalysis analysis;

  const AccuracyStatsCard({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.cardPadding),
        child: Column(
          children: [
            // 페어웨이 적중률
            _buildAccuracyItem(
              '페어웨이 적중률',
              analysis.fairwayHitRate,
              Icons.golf_course,
              AppColors.fairwayColor,
            ),
            const Divider(height: 24),
            
            // 좌우 편차
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDeviationItem(
                  '평균 좌우 편차',
                  analysis.averageSideDeviation,
                ),
                _buildDeviationItem(
                  '편차 표준편차',
                  analysis.sideDeviationStdDev,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccuracyItem(String label, double rate, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 48),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppStyles.fontSizeStatLabel,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${rate.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: rate / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildDeviationItem(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppStyles.fontSizeStatLabel,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}m',
          style: const TextStyle(
            fontSize: AppStyles.fontSizeStatValue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
