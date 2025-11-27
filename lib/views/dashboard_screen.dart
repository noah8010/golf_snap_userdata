import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/providers.dart';
import '../utils/app_constants.dart';
import '../utils/format_utils.dart';
import 'score_stats_screen.dart';
import 'putting_analysis_screen.dart';
import 'driver_analysis_screen.dart';
import 'widgets/score_record_card.dart';
import 'widgets/stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStatsAsync = ref.watch(userStatsProvider);
    final scoreRecordsAsync = ref.watch(scoreRecordsProvider);
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(userId),
      body: userStatsAsync.when(
        data: (stats) => scoreRecordsAsync.when(
          data: (records) => _buildContent(context, stats, records),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => _buildError(err.toString()),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _buildError(err.toString()),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String userId) {
    return AppBar(
      title: Text(
        'Golf Stats - $userId',
        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
      ),
      backgroundColor: AppColors.cardBackground,
      elevation: 0,
      foregroundColor: AppColors.textPrimary,
    );
  }

  Widget _buildContent(BuildContext context, Map<String, double> stats, Map<String, dynamic> records) {
    final best = records['best'];
    final worst = records['worst'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppStyles.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview header with stats limit selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader('Overview'),
              const SizedBox(height: AppStyles.spacingSmall),
              SizedBox(
                width: 140,
                child: Consumer(
                  builder: (context, ref, _) {
                    final limit = ref.watch(statsLimitProvider);
                    return DropdownButton<int?>(
                      value: limit,
                      hint: const Text('All'),
                      isDense: true,
                      items: const [
                        DropdownMenuItem(value: 10, child: Text('10 라운드')),
                        DropdownMenuItem(value: 20, child: Text('20 라운드')),
                        DropdownMenuItem(value: 30, child: Text('30 라운드')),
                        DropdownMenuItem(value: null, child: Text('전체')),
                      ],
                      onChanged: (value) {
                        ref.read(statsLimitProvider.notifier).state = value;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.spacingMedium),
          // Best/Worst Score Cards
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
          _buildStatsGrid(stats),
          const SizedBox(height: AppStyles.spacingLarge),
          _buildHeader('Recent Rounds'),
          const SizedBox(height: AppStyles.spacingMedium),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScoreStatsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.analytics),
                label: const Text('View Detailed Score Stats'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.scoreColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: AppStyles.spacingMedium),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PuttingAnalysisScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.sports_golf),
                label: const Text('퍼팅 분석 보기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.puttsColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: AppStyles.spacingMedium),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DriverAnalysisScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.sports),
                label: const Text('드라이버 분석 보기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.driverColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.spacingMedium),
          const Center(child: Text('Round List Component Here')),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, double> stats) {
    return Column(
      children: [
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
                title: 'Avg Putts',
                value: FormatUtils.formatNumber(stats['avgPutts']!),
                color: AppColors.puttsColor,
                icon: Icons.sports_golf,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppStyles.spacingMedium),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Driver Dist',
                value: FormatUtils.formatDistance(stats['driverDist']!),
                color: AppColors.driverColor,
                icon: Icons.landscape,
              ),
            ),
            const SizedBox(width: AppStyles.spacingMedium),
            Expanded(
              child: StatCard(
                title: 'GIR',
                value: FormatUtils.formatPercent(stats['gir']!),
                color: AppColors.girColor,
                icon: Icons.check_circle_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppStyles.spacingMedium),
        StatCard(
          title: 'Fairway Hit',
          value: FormatUtils.formatPercent(stats['fairway']!),
          color: AppColors.fairwayColor,
          icon: Icons.grass,
        ),
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: AppStyles.fontSizeHeader,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $message'),
        ],
      ),
    );
  }
}
