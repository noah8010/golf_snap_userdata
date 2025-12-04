import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_constants.dart';

class RadarChartWidget extends StatelessWidget {
  final Map<String, double> userStats;
  final Map<String, double> benchmarkStats;

  const RadarChartWidget({
    super.key,
    required this.userStats,
    required this.benchmarkStats,
  });

  @override
  Widget build(BuildContext context) {
    // Normalize data for radar chart (0-100 scale)
    // This is a simplified normalization. In a real app, you'd want more sophisticated scaling based on min/max values.
    final data = _normalizeData();

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: RadarChart(
            RadarChartData(
              radarTouchData: RadarTouchData(enabled: false),
              dataSets: [
                RadarDataSet(
                  fillColor: AppColors.primary.withOpacity(0.2),
                  borderColor: AppColors.primary,
                  entryRadius: 2,
                  dataEntries: data.userEntries,
                  borderWidth: 2,
                ),
                RadarDataSet(
                  fillColor: Colors.grey.withOpacity(0.2),
                  borderColor: Colors.grey,
                  entryRadius: 2,
                  dataEntries: data.benchmarkEntries,
                  borderWidth: 2,
                ),
              ],
              radarBackgroundColor: Colors.transparent,
              borderData: FlBorderData(show: false),
              radarBorderData: const BorderSide(color: Colors.transparent),
              titlePositionPercentageOffset: 0.2,
              titleTextStyle: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
              getTitle: (index, angle) {
                switch (index) {
                  case 0:
                    return RadarChartTitle(text: 'Score');
                  case 1:
                    return RadarChartTitle(text: 'Putts');
                  case 2:
                    return RadarChartTitle(text: 'Driver');
                  case 3:
                    return RadarChartTitle(text: 'GIR');
                  case 4:
                    return RadarChartTitle(text: 'Fairway');
                  default:
                    return const RadarChartTitle(text: '');
                }
              },
              tickCount: 1,
              ticksTextStyle: const TextStyle(color: Colors.transparent),
              tickBorderData: const BorderSide(color: Colors.transparent),
              gridBorderData: BorderSide(color: AppColors.textSecondary.withOpacity(0.1), width: 1),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Me', AppColors.primary),
            const SizedBox(width: 24),
            _buildLegendItem('Average', Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  ({List<RadarEntry> userEntries, List<RadarEntry> benchmarkEntries}) _normalizeData() {
    // Helper to clamp and scale values
    // Note: For Score and Putts, lower is better, so we invert the scale logic
    
    // 1. Score (Avg 72-100 range approx)
    double normScore(double val) => (120 - val).clamp(0, 100) / 100 * 100; // Lower score -> Higher value
    
    // 2. Putts (Avg 25-45 range approx)
    double normPutts(double val) => (50 - val).clamp(0, 100) / 50 * 100; // Lower putts -> Higher value
    
    // 3. Driver (150-280m range approx)
    double normDriver(double val) => (val - 150).clamp(0, 150) / 150 * 100;
    
    // 4. GIR (0-100%)
    double normPercent(double val) => val.clamp(0, 100);

    final userEntries = [
      RadarEntry(value: normScore(userStats['avgScore'] ?? 90)),
      RadarEntry(value: normPutts(userStats['avgPutts'] ?? 36)),
      RadarEntry(value: normDriver(userStats['driverDist'] ?? 200)),
      RadarEntry(value: normPercent(userStats['gir'] ?? 0)),
      RadarEntry(value: normPercent(userStats['fairway'] ?? 0)),
    ];

    final benchmarkEntries = [
      RadarEntry(value: normScore(benchmarkStats['avgScore'] ?? 90)),
      RadarEntry(value: normPutts(benchmarkStats['avgPutts'] ?? 36)),
      RadarEntry(value: normDriver(benchmarkStats['driverDistance'] ?? 200)),
      RadarEntry(value: normPercent(benchmarkStats['girPercentage'] ?? 0)),
      RadarEntry(value: normPercent(benchmarkStats['fairwayAccuracy'] ?? 0)),
    ];

    return (userEntries: userEntries, benchmarkEntries: benchmarkEntries);
  }
}
