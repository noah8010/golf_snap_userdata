import 'package:flutter/material.dart';
import '../../models/driver_analysis.dart';
import '../../utils/app_constants.dart';

class PenaltyStatsCard extends StatelessWidget {
  final DriverAnalysis analysis;

  const PenaltyStatsCard({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.cardPadding),
        child: Column(
          children: [
            // 총 페널티 수
            _buildTotalPenalties(),
            const Divider(height: 24),
            
            // OB와 해저드 비율
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPenaltyItem(
                  'OB 발생률',
                  analysis.obRate,
                  Icons.warning_amber,
                  Colors.red,
                ),
                _buildPenaltyItem(
                  '해저드 발생률',
                  analysis.hazardRate,
                  Icons.water,
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPenalties() {
    return Column(
      children: [
        const Icon(Icons.error_outline, color: Colors.orange, size: 48),
        const SizedBox(height: 8),
        const Text(
          '총 페널티',
          style: TextStyle(
            fontSize: AppStyles.fontSizeStatLabel,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${analysis.totalPenalties}회',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildPenaltyItem(String label, double rate, IconData icon, Color color) {
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
          '${rate.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: AppStyles.fontSizeStatValue,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
