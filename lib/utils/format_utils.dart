import 'package:intl/intl.dart';

class FormatUtils {
  // 날짜 포맷팅
  static String formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  // 날짜와 시간 포맷팅
  static String formatDateTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  // 숫자 포맷팅 (소수점 1자리)
  static String formatNumber(double value, {int decimalPlaces = 1}) {
    return value.toStringAsFixed(decimalPlaces);
  }

  // 퍼센트 포맷팅
  static String formatPercent(double value, {int decimalPlaces = 1}) {
    return '${value.toStringAsFixed(decimalPlaces)}%';
  }

  // 거리 포맷팅
  static String formatDistance(double meters) {
    return '${meters.toStringAsFixed(1)}m';
  }
}
