import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/round.dart';
import '../../utils/app_constants.dart';
import '../../viewmodels/providers.dart';

class CompanionScoreDialog extends ConsumerWidget {
  final Round userRound;

  const CompanionScoreDialog({super.key, required this.userRound});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRoundsAsync = ref.watch(allRoundsProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '동반자 스코어',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${userRound.ccName ?? userRound.courseId} · ${_formatDate(userRound.playedAt)}',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Expanded(
              child: allRoundsAsync.when(
                data: (allRounds) {
                  // 같은 날짜, 같은 코스의 다른 사용자 라운드 찾기
                  final userDate = DateTime.parse(userRound.playedAt).toIso8601String().substring(0, 10);
                  final companions = allRounds.where((r) {
                    final roundDate = DateTime.parse(r.playedAt).toIso8601String().substring(0, 10);
                    return roundDate == userDate &&
                        r.courseId == userRound.courseId &&
                        r.userId != userRound.userId;
                  }).toList();

                  if (companions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            '동반자 데이터가 없습니다',
                            style: GoogleFonts.outfit(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  // 스코어 순으로 정렬
                  companions.sort((a, b) => a.totalScore.compareTo(b.totalScore));

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: companions.length,
                    itemBuilder: (context, index) {
                      final companion = companions[index];
                      final overUnder = companion.totalScore - companion.totalPar;
                      final overUnderText = overUnder > 0 ? '+$overUnder' : '$overUnder';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            // 순위
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: _getRankColor(index),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 사용자 ID
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _formatUserId(companion.userId),
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'GIR ${companion.greensInRegulation}개 · 퍼팅 ${companion.totalPutts}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 스코어
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${companion.totalScore}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  overUnderText,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: overUnder <= 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('오류: $e')),
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            // 본인 스코어 표시
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '나의 스코어',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Text(
                    '${userRound.totalScore}',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // 금
      case 1:
        return const Color(0xFFC0C0C0); // 은
      case 2:
        return const Color(0xFFCD7F32); // 동
      default:
        return Colors.grey;
    }
  }

  String _formatUserId(String userId) {
    // beginner.user001 -> 초보자 1
    // inter.user002 -> 중급자 2
    // advanced.user003 -> 상급자 3
    final parts = userId.split('.');
    if (parts.length == 2) {
      final level = parts[0];
      final num = parts[1].replaceAll(RegExp(r'[^0-9]'), '');
      final levelName = {
        'beginner': '초보자',
        'inter': '중급자',
        'advanced': '상급자',
      }[level] ?? level;
      return '$levelName ${int.tryParse(num) ?? num}';
    }
    return userId;
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
