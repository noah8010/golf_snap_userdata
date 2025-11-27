import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_constants.dart';
import '../../utils/format_utils.dart';

class ScoreRecordCard extends StatelessWidget {
  final String title;
  final dynamic scoreRecord; // ScoreRecord?
  final Color color;
  final IconData icon;

  const ScoreRecordCard({
    super.key,
    required this.title,
    required this.scoreRecord,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            scoreRecord?.score.toString() ?? 'N/A',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            scoreRecord != null ? 'Course: ${scoreRecord.ccName ?? scoreRecord.courseId}' : '',
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            scoreRecord != null ? FormatUtils.formatDate(scoreRecord.date.toIso8601String()) : '',
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
