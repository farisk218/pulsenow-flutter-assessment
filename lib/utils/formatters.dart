import 'package:intl/intl.dart';

extension DoubleFormatters on double {
  String formatCurrency() {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(this);
  }

  String formatPercentage() {
    return '${this >= 0 ? '+' : ''}${toStringAsFixed(2)}%';
  }

  String formatVolume() {
    if (this >= 1e9) {
      return '${(this / 1e9).toStringAsFixed(2)}B';
    } else if (this >= 1e6) {
      return '${(this / 1e6).toStringAsFixed(2)}M';
    } else if (this >= 1e3) {
      return '${(this / 1e3).toStringAsFixed(2)}K';
    }
    return toStringAsFixed(0);
  }
}
