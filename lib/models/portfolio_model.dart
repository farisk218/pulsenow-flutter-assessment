/// Portfolio data models for API responses

/// Portfolio Summary Model
/// API: GET /api/portfolio
class PortfolioSummary {
  final String totalValue;
  final String totalPnl;
  final String totalPnlPercent;

  const PortfolioSummary({
    required this.totalValue,
    required this.totalPnl,
    required this.totalPnlPercent,
  });

  factory PortfolioSummary.fromJson(Map<String, dynamic> json) {
    return PortfolioSummary(
      totalValue: json['totalValue'] as String? ?? '0',
      totalPnl: json['totalPnl'] as String? ?? '0',
      totalPnlPercent: json['totalPnlPercent'] as String? ?? '0',
    );
  }

  /// Helper getters for numeric conversions when needed
  double get totalValueDouble => double.tryParse(totalValue.replaceAll('\$', '').replaceAll(',', '')) ?? 0;
  double get totalPnlDouble => double.tryParse(totalPnl.replaceAll('\$', '').replaceAll(',', '')) ?? 0;
  double get totalPnlPercentDouble => double.tryParse(totalPnlPercent.replaceAll('%', '')) ?? 0;

  /// Check if P&L is positive
  bool get isPositive => totalPnlDouble >= 0;
}

/// Portfolio Holding Model
/// API: GET /api/portfolio/holdings
class PortfolioHolding {
  final String symbol;
  final double quantity;
  final double currentPrice;
  final double value;
  final double pnl;
  final double pnlPercent;
  final double allocation;

  const PortfolioHolding({
    required this.symbol,
    required this.quantity,
    required this.currentPrice,
    required this.value,
    required this.pnl,
    required this.pnlPercent,
    required this.allocation,
  });

  factory PortfolioHolding.fromJson(Map<String, dynamic> json) {
    return PortfolioHolding(
      symbol: json['symbol'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0,
      pnl: (json['pnl'] as num?)?.toDouble() ?? 0,
      pnlPercent: (json['pnlPercent'] as num?)?.toDouble() ?? 0,
      allocation: (json['allocation'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Check if P&L is positive
  bool get isPositive => pnl >= 0;
}

/// Portfolio Performance Model
/// API: GET /api/portfolio/performance?timeframe={timeframe}
class PortfolioPerformance {
  final String timeframe;
  final Map<String, dynamic>? data;

  const PortfolioPerformance({
    required this.timeframe,
    this.data,
  });

  factory PortfolioPerformance.fromJson(Map<String, dynamic> json) {
    return PortfolioPerformance(
      timeframe: json['timeframe'] as String? ?? '7d',
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
