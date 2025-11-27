import 'package:flutter/material.dart';
import '../../models/driver_analysis.dart';
import '../../utils/app_constants.dart';

class DistanceStatsCard extends StatelessWidget {
  final DriverAnalysis analysis;

  const DistanceStatsCard({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.cardPadding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  '평균 비거리',
                  '${analysis.averageTotalDistance.toStringAsFixed(1)}m',
                  Icons.straighten,
                  AppColors.driverColor,
                ),
                _buildStatItem(
                  '최장 비거리',
                  '${analysis.maxDistance.toStringAsFixed(1)}m',
                  Icons.trending_up,
                  AppColors.scoreColor,
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  '평균 캐리',
                  '${analysis.averageCarryDistance.toStringAsFixed(1)}m',
                  Icons.flight_takeoff,
                  AppColors.girColor,
                ),
                _buildStatItem(
                  '평균 런',
                  '${analysis.averageRun.toStringAsFixed(1)}m',
                  Icons.directions_run,
                  AppColors.fairwayColor,
                ),
              ],
            ),
            const Divider(height: 32),
            _buildConsistencyBar(analysis.distanceStdDev),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppStyles.fontSizeStatLabel,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: AppStyles.fontSizeStatValue,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildConsistencyBar(double stdDev) {
    // 표준편차가 낮을수록 일관성이 높음
    // 0-10m: 매우 좋음, 10-20m: 좋음, 20-30m: 보통, 30m+: 개선 필요
    String consistency;
    Color color;
    double progress;

    if (stdDev < 10) {
      consistency = '매우 일관적';
      color = Colors.green;
      progress = 1.0;
    } else if (stdDev < 20) {
      consistency = '일관적';
      color = Colors.lightGreen;
      progress = 0.75;
    } else if (stdDev < 30) {
      consistency = '보통';
      color = Colors.orange;
      progress = 0.5;
    } else {
      consistency = '개선 필요';
      color = Colors.red;
      progress = 0.25;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '비거리 일관성',
              style: TextStyle(
                fontSize: AppStyles.fontSizeStatLabel,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              consistency,
              style: TextStyle(
                fontSize: AppStyles.fontSizeStatLabel,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
        const SizedBox(height: 4),
        Text(
          '표준편차: ${stdDev.toStringAsFixed(1)}m',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
