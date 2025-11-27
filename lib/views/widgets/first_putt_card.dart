import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_constants.dart';

class FirstPuttCard extends StatelessWidget {
  final double rate; // 0~1 (예: 0.85 = 85%)
  const FirstPuttCard({required this.rate, super.key});

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
            Icon(Icons.sports_golf, size: 48, color: AppColors.puttsColor),
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
              '첫 퍼트 성공률',
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
