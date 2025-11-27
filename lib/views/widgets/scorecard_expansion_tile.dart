import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/round.dart';
import '../../utils/app_constants.dart';
import '../../utils/format_utils.dart';
import 'scorecard_table.dart';

class ScorecardExpansionTile extends StatelessWidget {
  final Round round;

  const ScorecardExpansionTile({super.key, required this.round});

  @override
  Widget build(BuildContext context) {
    final overUnderPar = round.totalScore - round.totalPar;
    final overUnderText = overUnderPar > 0 ? '+$overUnderPar' : '$overUnderPar';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getCourseColor(round.courseId),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.flag, color: Colors.white),
          ),
          title: Text(
            round.ccName ?? round.courseId,
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FormatUtils.formatDate(round.playedAt),
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                'Par ${round.totalPar} · 핸디캡 ${_calculateHandicap(round).toStringAsFixed(1)} · ${_getScoreType(overUnderPar)}',
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${round.totalScore}',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                overUnderText,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: _getScoreColor(overUnderPar),
                ),
              ),
            ],
          ),
          children: [
            ScorecardTable(round: round),
          ],
        ),
      ),
    );
  }

  Color _getCourseColor(String courseId) {
    final hash = courseId.hashCode;
    final colors = [Colors.green, Colors.blue, Colors.purple, Colors.orange];
    return colors[hash.abs() % colors.length].shade400;
  }

  double _calculateHandicap(Round round) {
    return (round.totalScore - round.totalPar).toDouble();
  }

  String _getScoreType(int overUnder) {
    if (overUnder < 0) return '베스트 스코어';
    if (overUnder == 0) return '이븐파';
    return '';
  }

  Color _getScoreColor(int overUnder) {
    if (overUnder < 0) return Colors.green;
    if (overUnder == 0) return AppColors.scoreColor;
    return Colors.red;
  }
}
