import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/putting_providers.dart';
import '../utils/app_constants.dart';

import 'widgets/distance_success_chart.dart';
import 'widgets/three_putt_pie_chart.dart';
import 'widgets/first_putt_card.dart';


class PuttingAnalysisScreen extends ConsumerWidget {
  const PuttingAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStats = ref.watch(puttingStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('퍼팅 분석'),
        backgroundColor: AppColors.cardBackground,
      ),
      body: asyncStats.when(
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppStyles.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('거리별 퍼팅 성공률', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppStyles.spacingSmall),
              DistanceSuccessChart(data: stats.distanceSuccessRate),
              const SizedBox(height: AppStyles.spacingLarge),
              const Text('3퍼트율', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppStyles.spacingSmall),
              ThreePuttPieChart(rate: stats.threePuttRate),
              const SizedBox(height: AppStyles.spacingLarge),
              const Text('첫 퍼트 성공률', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppStyles.spacingSmall),
              FirstPuttCard(rate: stats.firstPuttSuccessRate),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
