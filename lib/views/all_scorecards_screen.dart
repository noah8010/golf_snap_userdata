import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/providers.dart';
import '../utils/app_constants.dart';
import '../models/round.dart';
import 'widgets/scorecard_expansion_tile.dart';

class AllScorecardsScreen extends ConsumerWidget {
  const AllScorecardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRoundsAsync = ref.watch(userRoundsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '전체 스코어카드',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: userRoundsAsync.when(
        data: (rounds) {
          if (rounds.isEmpty) {
            return const Center(child: Text('라운드 데이터가 없습니다'));
          }

          // 최신순으로 정렬
          final sortedRounds = List<Round>.from(rounds)
            ..sort(
              (a, b) => DateTime.parse(b.playedAt).compareTo(DateTime.parse(a.playedAt)),
            );

          return ListView.builder(
            padding: const EdgeInsets.all(AppStyles.spacingMedium),
            itemCount: sortedRounds.length,
            itemBuilder: (context, index) {
              return ScorecardExpansionTile(round: sortedRounds[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
      ),
    );
  }
}
