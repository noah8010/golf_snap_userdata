import '../models/round.dart';
import '../models/shot.dart';
import '../models/putting_stats.dart';

class PuttingRepository {
  // 거리 구간 (미터) 정의
  static const List<double> _bins = [5, 10, 15, 20, 25, 30];

  // 라운드 리스트에서 퍼팅 통계 계산
  Future<PuttingStats> getPuttingStats(List<Round> rounds) async {
    // 모든 퍼팅 샷 수집
    final puttShots = <Shot>[];
    for (var round in rounds) {
      for (var shot in round.shots) {
        if (shot.isPutt) {
          puttShots.add(shot);
        }
      }
    }

    // 1) 거리별 성공률 (puttMade == true)
    final Map<String, _BinCounter> binCounters = {};
    for (var bin in _bins) {
      final key = '${0}-${bin.toInt()}m';
      binCounters[key] = _BinCounter();
    }
    // 마지막 구간 (>= 마지막 bin)
    final lastKey = '${_bins.last.toInt()}m+';
    binCounters[lastKey] = _BinCounter();

    for (var shot in puttShots) {
      final length = shot.puttLength ?? 0.0;
      String? key;
      for (var i = 0; i < _bins.length; i++) {
        if (length <= _bins[i]) {
          key = i == 0 ? '0-${_bins[i].toInt()}m' : '${_bins[i - 1].toInt()}-${_bins[i].toInt()}m';
          break;
        }
      }
      key ??= lastKey;
      final counter = binCounters[key]!;
      counter.attempts++;
      if (shot.puttMade == true) {
        counter.successes++;
      }
    }

    final Map<String, double> distanceSuccessRate = {};
    binCounters.forEach((k, v) {
      distanceSuccessRate[k] = v.attempts == 0 ? 0.0 : v.successes / v.attempts;
    });

    // 2) 3퍼트율 (puttNumber >= 3)
    int threePuttAttempts = 0;
    int threePuttSuccess = 0;
    for (var shot in puttShots) {
      // 가정: shot.shotNumber 은 퍼트 순번 (1,2,3...)
      if (shot.shotNumber >= 3) {
        threePuttAttempts++;
        if (shot.puttMade == true) {
          threePuttSuccess++;
        }
      }
    }
    final double threePuttRate = threePuttAttempts == 0 ? 0.0 : threePuttSuccess / threePuttAttempts;

    // 3) 첫 퍼트 성공률 (hole 별 첫 퍼트가 성공했는지 확인)
    int holes = 0;
    int firstPuttSuccess = 0;
    for (var round in rounds) {
      for (var hole in round.holes) {
        // 해당 홀의 퍼트 샷을 순서대로 찾는다.
        final holePuttShots = round.shots.where((s) => s.isPutt && s.holeScoreId == hole.holeScoreId).toList();
        if (holePuttShots.isNotEmpty) {
          holes++;
          if (holePuttShots.first.puttMade == true) {
            firstPuttSuccess++;
          }
        }
      }
    }
    final double firstPuttSuccessRate = holes == 0 ? 0.0 : firstPuttSuccess / holes;

    return PuttingStats(
      distanceSuccessRate: distanceSuccessRate,
      threePuttRate: threePuttRate,
      firstPuttSuccessRate: firstPuttSuccessRate,
    );
  }
}

class _BinCounter {
  int attempts = 0;
  int successes = 0;
}
