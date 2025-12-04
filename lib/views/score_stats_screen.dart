import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodels/providers.dart';
import '../utils/app_constants.dart';
import '../utils/format_utils.dart';
import '../models/round.dart';
import 'widgets/scorecard_expansion_tile.dart';
import 'widgets/score_record_card.dart';
import 'widgets/stat_card.dart';
import 'widgets/comparison_card.dart';

class ScoreStatsScreen extends ConsumerWidget {
  const ScoreStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Score Statistics',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Overview'),
            const SizedBox(height: AppStyles.spacingMedium),
            _ScoreOverviewCards(),
            const SizedBox(height: AppStyles.spacingLarge),
            _buildSectionHeader('Comparison'),
            const SizedBox(height: AppStyles.spacingMedium),
            _ScoreComparisonCards(),
            const SizedBox(height: AppStyles.spacingLarge),
            _buildSectionHeader('Comparison'),
            const SizedBox(height: AppStyles.spacingMedium),
            _ScoreComparisonCards(),
            const SizedBox(height: AppStyles.spacingLarge),
            _buildSectionHeader('Score Trend'),
            const SizedBox(height: AppStyles.spacingMedium),
            _ScoreTrendChart(),
            const SizedBox(height: AppStyles.spacingLarge),
            _buildSectionHeader('Score Distribution'),
            Text(
              'Number of rounds for each total score',
              style: GoogleFonts.outfit(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppStyles.spacingSmall),
            _ScoreDistributionChart(),
            const SizedBox(height: AppStyles.spacingLarge),
            _buildSectionHeader('Average by Par'),
            const SizedBox(height: AppStyles.spacingMedium),
            _ParAverageChart(),
            const SizedBox(height: AppStyles.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('최근 스코어카드'),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full scorecard list
                  },
                  child: Text(
                    '전체보기',
                    style: GoogleFonts.outfit(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppStyles.spacingMedium),
            _RecentScorecardsList(),
            const SizedBox(height: AppStyles.spacingLarge),
            _buildSectionHeader('Score Breakdown'),
            const SizedBox(height: AppStyles.spacingMedium),
            _ScoreBreakdownPie(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// 최근 스코어카드 리스트 (확장 가능)
class _RecentScorecardsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRoundsAsync = ref.watch(userRoundsProvider);

    return userRoundsAsync.when(
      data: (rounds) {
        if (rounds.isEmpty) {
          return const Center(child: Text('No rounds available'));
        }

        // 최신순으로 정렬하고 최대 5개만 표시
        final recentRounds = List<Round>.from(rounds)
          ..sort((a, b) =>
              DateTime.parse(b.playedAt).compareTo(DateTime.parse(a.playedAt)));
        final displayRounds = recentRounds.take(5).toList();

        return Column(
          children: displayRounds
              .map((round) => ScorecardExpansionTile(round: round))
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
    );
  }
}

// Overview Cards - 골프장 정보 포함
class _ScoreOverviewCards extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreRecordsAsync = ref.watch(scoreRecordsProvider);
    final handicapAsync = ref.watch(handicapProvider);
    final userStatsAsync = ref.watch(userStatsProvider);

    return scoreRecordsAsync.when(
      data: (records) => handicapAsync.when(
        data: (handicap) => userStatsAsync.when(
          data: (stats) {
            final best = records['best'];
            final worst = records['worst'];

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ScoreRecordCard(
                        title: 'Best Score',
                        scoreRecord: best,
                        color: Colors.green,
                        icon: Icons.emoji_events,
                      ),
                    ),
                    const SizedBox(width: AppStyles.spacingMedium),
                    Expanded(
                      child: ScoreRecordCard(
                        title: 'Worst Score',
                        scoreRecord: worst,
                        color: Colors.red,
                        icon: Icons.warning_amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppStyles.spacingMedium),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Avg Score',
                        value: FormatUtils.formatNumber(stats['avgScore']!),
                        color: AppColors.scoreColor,
                        icon: Icons.analytics,
                      ),
                    ),
                    const SizedBox(width: AppStyles.spacingMedium),
                    Expanded(
                      child: StatCard(
                        title: 'Handicap',
                        value: handicap > 0
                            ? '+${FormatUtils.formatNumber(handicap)}'
                            : FormatUtils.formatNumber(handicap),
                        color: Colors.purple,
                        icon: Icons.golf_course,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error: $e'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
    );
  }
}

// Comparison Cards
class _ScoreComparisonCards extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStatsAsync = ref.watch(userStatsProvider);

    return userStatsAsync.when(
      data: (stats) {
        return Row(
          children: [
            Expanded(
              child: ComparisonCard(
                title: '평균 스코어',
                userValue: stats['avgScore'] ?? 0,
                metric: 'score',
                lowerIsBetter: true,
              ),
            ),
            const SizedBox(width: AppStyles.spacingMedium),
            Expanded(
              child: ComparisonCard(
                title: 'GIR',
                userValue: stats['gir'] ?? 0,
                metric: 'gir',
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

// Score Trend Chart
class _ScoreTrendChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(scoreTrendProvider);
    final benchmarkAsync = ref.watch(benchmarkStatsProvider);

    return trendAsync.when(
      data: (trends) {
        if (trends.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return benchmarkAsync.when(
          data: (benchmark) {
            final overallAvg = benchmark.overall.averageScore;
            final lastIndex = trends.length > 1 ? trends.length - 1 : 1;
            final averageLineSpots = [
              FlSpot(0, overallAvg),
              FlSpot(lastIndex.toDouble(), overallAvg),
            ];

            return Container(
              height: 280,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < trends.length) {
                                  return Text(
                                    '${trends[value.toInt()].date.month}/${trends[value.toInt()].date.day}',
                                    style: const TextStyle(fontSize: 9),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: trends
                                .asMap()
                                .entries
                                .map((e) => FlSpot(
                                    e.key.toDouble(), e.value.score.toDouble()))
                                .toList(),
                            isCurved: true,
                            color: AppColors.scoreColor,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                          ),
                          LineChartBarData(
                            spots: averageLineSpots,
                            isCurved: false,
                            color: Colors.grey,
                            barWidth: 2,
                            dashArray: [6, 4],
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LegendDot(color: AppColors.scoreColor, label: '나의 스코어'),
                      const SizedBox(width: 12),
                      _LegendDot(color: Colors.grey, label: '전체 평균'),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('Error: $e'),
        );
      },
      loading: () => const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Error: $e'),
    );
  }
}

// Score Distribution Chart
class _ScoreDistributionChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distributionAsync = ref.watch(scoreDistributionProvider);
    final benchmarkAsync = ref.watch(benchmarkStatsProvider);

    return distributionAsync.when(
      data: (distribution) {
        if (distribution.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return benchmarkAsync.when(
          data: (benchmark) {
            final overallDistribution =
                _buildFrequencyMap(benchmark.scoreDistribution);
            final keys = {
              ...distribution.keys,
              ...overallDistribution.keys,
            }.toList()
              ..sort();

            return Container(
              height: 280,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            axisNameWidget: Text(
                              'Rounds',
                              style: GoogleFonts.outfit(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            axisNameWidget: Text(
                              'Total Score',
                              style: GoogleFonts.outfit(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        barGroups: keys.map((key) {
                          final overallValue = overallDistribution[key] ?? 0;
                          final userValue = distribution[key] ?? 0;
                          return BarChartGroupData(
                            x: key,
                            barRods: [
                              BarChartRodData(
                                toY: overallValue.toDouble(),
                                color: Colors.grey[300],
                                width: 14,
                              ),
                              BarChartRodData(
                                toY: userValue.toDouble(),
                                color: AppColors.scoreColor,
                                width: 8,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LegendDot(color: Colors.grey, label: '전체 분포'),
                      const SizedBox(width: 12),
                      _LegendDot(color: AppColors.scoreColor, label: '나의 분포'),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('Error: $e'),
        );
      },
      loading: () => const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Error: $e'),
    );
  }
}

Map<int, int> _buildFrequencyMap(List<double> values) {
  final result = <int, int>{};
  for (final value in values) {
    final key = value.round();
    result[key] = (result[key] ?? 0) + 1;
  }
  return result;
}

// Par Average Chart
class _ParAverageChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parAvgAsync = ref.watch(scoreByParProvider);

    return parAvgAsync.when(
      data: (parAvg) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
          ),
          child: Column(
            children: [3, 4, 5].map((par) {
              final avg = parAvg[par] ?? 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        'Par $par',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (avg / (par + 3)).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[200],
                        color: _getColorForPar(par),
                        minHeight: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      FormatUtils.formatNumber(avg),
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
    );
  }

  Color _getColorForPar(int par) {
    switch (par) {
      case 3:
        return Colors.green;
      case 4:
        return Colors.blue;
      case 5:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

// Score Breakdown Pie Chart
class _ScoreBreakdownPie extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdownAsync = ref.watch(scoreBreakdownProvider);

    return breakdownAsync.when(
      data: (breakdown) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: PieChart(
                  PieChartData(
                    sections: [
                      if (breakdown.eagles > 0)
                        PieChartSectionData(
                          value: breakdown.eagles.toDouble(),
                          title: '${breakdown.eagleRate.toStringAsFixed(0)}%',
                          color: const Color(0xFF00C853),
                          radius: 60,
                        ),
                      if (breakdown.birdies > 0)
                        PieChartSectionData(
                          value: breakdown.birdies.toDouble(),
                          title: '${breakdown.birdieRate.toStringAsFixed(0)}%',
                          color: const Color(0xFF64DD17),
                          radius: 60,
                        ),
                      PieChartSectionData(
                        value: breakdown.pars.toDouble(),
                        title: '${breakdown.parRate.toStringAsFixed(0)}%',
                        color: AppColors.scoreColor,
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: breakdown.bogeys.toDouble(),
                        title: '${breakdown.bogeyRate.toStringAsFixed(0)}%',
                        color: Colors.orange,
                        radius: 60,
                      ),
                      if (breakdown.doubleBogeys + breakdown.others > 0)
                        PieChartSectionData(
                          value: (breakdown.doubleBogeys + breakdown.others)
                              .toDouble(),
                          title:
                              '${(breakdown.doubleBogeyRate + breakdown.otherRate).toStringAsFixed(0)}%',
                          color: Colors.red,
                          radius: 60,
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (breakdown.eagles > 0)
                      _buildLegendItem(
                          'Eagle', const Color(0xFF00C853), breakdown.eagles),
                    if (breakdown.birdies > 0)
                      _buildLegendItem(
                          'Birdie', const Color(0xFF64DD17), breakdown.birdies),
                    _buildLegendItem(
                        'Par', AppColors.scoreColor, breakdown.pars),
                    _buildLegendItem('Bogey', Colors.orange, breakdown.bogeys),
                    if (breakdown.doubleBogeys + breakdown.others > 0)
                      _buildLegendItem('Double+', Colors.red,
                          breakdown.doubleBogeys + breakdown.others),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Error: $e'),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
          Text(
            '$label ($count)',
            style: GoogleFonts.outfit(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.outfit(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
