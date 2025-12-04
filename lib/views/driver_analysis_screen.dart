import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/providers.dart';
import '../utils/app_constants.dart';

import 'widgets/distance_stats_card.dart';
import 'widgets/accuracy_stats_card.dart';
import 'widgets/penalty_stats_card.dart';
import 'widgets/ball_flight_chart.dart';
import 'widgets/comparison_card.dart';

class DriverAnalysisScreen extends ConsumerWidget {
  const DriverAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAnalysis = ref.watch(driverAnalysisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('드라이버 분석'),
        backgroundColor: AppColors.cardBackground,
      ),
      body: asyncAnalysis.when(
        data: (analysis) {
          if (analysis.totalShots < 5) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  '드라이버 샷 데이터가 부족합니다.\n최소 5개 이상의 드라이버 샷이 필요합니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppStyles.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 기본 정보
                _buildInfoCard(analysis),
                const SizedBox(height: AppStyles.spacingLarge),

                const Text(
                  'Comparison',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                _DriverComparisonCards(),
                const SizedBox(height: AppStyles.spacingLarge),
                const Text(
                  'Top 10% Comparison',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                _DriverTopComparisonCards(),
                const SizedBox(height: AppStyles.spacingLarge),

                // 비거리 분석
                const Text(
                  '비거리 분석',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                DistanceStatsCard(analysis: analysis),
                const SizedBox(height: AppStyles.spacingLarge),

                // 정확도 분석
                const Text(
                  '정확도 분석',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                AccuracyStatsCard(analysis: analysis),
                const SizedBox(height: AppStyles.spacingLarge),

                // 구질 분석
                const Text(
                  '구질 분석',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                BallFlightChart(analysis: analysis),
                const SizedBox(height: AppStyles.spacingLarge),

                // 페널티 분석
                const Text(
                  '페널티 분석',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                PenaltyStatsCard(analysis: analysis),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildInfoCard(analysis) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.cardPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoItem('총 샷 수', '${analysis.totalShots}개'),
            _buildInfoItem('라운드 수', '${analysis.totalRounds}회'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
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
          value,
          style: const TextStyle(
            fontSize: AppStyles.fontSizeStatValue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DriverComparisonCards extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverStatsAsync = ref.watch(driverAnalysisProvider);

    return driverStatsAsync.when(
      data: (stats) {
        return Row(
          children: [
            Expanded(
              child: ComparisonCard(
                title: '평균 비거리',
                userValue: stats.averageTotalDistance,
                metric: 'driverDistance',
                unit: 'm',
              ),
            ),
            const SizedBox(width: AppStyles.spacingMedium),
            Expanded(
              child: ComparisonCard(
                title: '페어웨이 적중률',
                userValue: stats.fairwayHitRate,
                metric: 'fairway',
                unit: '%',
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
    );
  }
}

class _DriverTopComparisonCards extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverStatsAsync = ref.watch(driverAnalysisProvider);

    return driverStatsAsync.when(
      data: (stats) {
        return Row(
          children: [
            Expanded(
              child: ComparisonCard(
                title: '평균 비거리',
                userValue: stats.averageTotalDistance,
                metric: 'driverDistance',
                unit: 'm',
                target: BenchmarkTarget.top10,
              ),
            ),
            const SizedBox(width: AppStyles.spacingMedium),
            Expanded(
              child: ComparisonCard(
                title: '페어웨이 적중률',
                userValue: stats.fairwayHitRate,
                metric: 'fairway',
                unit: '%',
                target: BenchmarkTarget.top10,
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
