import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/round.dart';
import '../../models/hole.dart';
import '../../utils/app_constants.dart';

class ScorecardTable extends StatelessWidget {
  final Round round;

  const ScorecardTable({super.key, required this.round});

  @override
  Widget build(BuildContext context) {
    // 홀을 전반(1-9), 후반(10-18)으로 분리
    final frontNine = round.holes.where((h) => h.holeNumber <= 9).toList()
      ..sort((a, b) => a.holeNumber.compareTo(b.holeNumber));
    final backNine = round.holes.where((h) => h.holeNumber > 9).toList()
      ..sort((a, b) => a.holeNumber.compareTo(b.holeNumber));

    return Column(
      children: [
        // 전반 9홀
        if (frontNine.isNotEmpty) ...[
          _buildHalfTable('전반', frontNine),
          const SizedBox(height: 12),
        ],
        // 후반 9홀
        if (backNine.isNotEmpty) ...[
          _buildHalfTable('후반', backNine),
        ],
      ],
    );
  }

  Widget _buildHalfTable(String label, List<Hole> holes) {
    final totalPar = holes.fold(0, (sum, h) => sum + h.par);
    final totalScore = holes.fold(0, (sum, h) => sum + h.strokes);
    final totalPutts = holes.fold(0, (sum, h) => sum + h.putts);
    final totalOverUnder = totalScore - totalPar;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.scoreColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                _buildHeaderCell('HOLE', flex: 1),
                ...holes.map((h) => _buildHeaderCell('${h.holeNumber}', flex: 1)),
                _buildHeaderCell('T', flex: 1),
              ],
            ),
          ),
          // PAR
          Row(
            children: [
              _buildRowLabelCell('PAR'),
              ...holes.map((h) => _buildCell('${h.par}', flex: 1)),
              _buildCell('$totalPar', flex: 1, isBold: true),
            ],
          ),
          // SCORE
          Row(
            children: [
              _buildRowLabelCell('SCORE'),
              ...holes.map((h) => _buildScoreCell(h)),
              _buildCell('$totalOverUnder', flex: 1, isBold: true, color: _getScoreColor(totalOverUnder)),
            ],
          ),
          // PUTT
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                _buildRowLabelCell('PUTT'),
                ...holes.map((h) => _buildCell('${h.putts}', flex: 1)),
                _buildCell('$totalPutts', flex: 1, isBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.scoreColor,
          ),
        ),
      ),
    );
  }

  Widget _buildRowLabelCell(String text) {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildCell(String text, {int flex = 1, bool isBold = false, Color? color}) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCell(Hole hole) {
    final diff = hole.strokes - hole.par;
    Color? bgColor;
    Color textColor = AppColors.textPrimary;
    bool hasBox = false;

    if (diff <= -2) {
      // Eagle
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
      hasBox = true;
    } else if (diff == -1) {
      // Birdie
      bgColor = Colors.lightGreen.shade100;
      textColor = Colors.green.shade700;
      hasBox = true;
    } else if (diff == 0) {
      // Par - 박스만
      hasBox = true;
    } else if (diff == 1) {
      // Bogey
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade700;
      hasBox = true;
    } else if (diff >= 2) {
      // Double Bogey+
      bgColor = Colors.red.shade200;
      textColor = Colors.red.shade900;
      hasBox = true;
    }

    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: 24,
          height: 24,
          decoration: hasBox
              ? BoxDecoration(
                  color: bgColor,
                  border: Border.all(color: textColor, width: 1.5),
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          alignment: Alignment.center,
          child: Text(
            diff == 0 ? '${hole.strokes}' : (diff > 0 ? '$diff' : '$diff'),
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int overUnder) {
    if (overUnder < 0) return Colors.green;
    if (overUnder == 0) return AppColors.scoreColor;
    return Colors.red;
  }
}
