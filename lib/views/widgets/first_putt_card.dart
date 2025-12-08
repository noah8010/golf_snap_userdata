import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_constants.dart';

class FirstPuttCard extends StatelessWidget {
  final double rate;
  final String title;
  final IconData icon;
  final Color accentColor;

  const FirstPuttCard({
    super.key,
    required this.rate,
    this.title = '첫 퍼트 성공률',
    this.icon = Icons.sports_golf,
    this.accentColor = AppColors.puttsColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(icon, size: 48, color: accentColor),
            const SizedBox(height: 16),
            Text(
              '${rate.toStringAsFixed(1)}%',
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
