/// API: GET /api/market-data
class MarketData {
  final String symbol;
  final double price;
  final double change24h;
  final double changePercent24h;
  final double volume;
  final String description;
  final double high24h;
  final double low24h;
  final double marketCap;
  final String lastUpdated;

  const MarketData({
    required this.symbol,
    required this.price,
    required this.change24h,
    required this.changePercent24h,
    required this.volume,
    required this.description,
    required this.high24h,
    required this.low24h,
    required this.marketCap,
    required this.lastUpdated,
  });

  /// Factory constructor to create MarketData from JSON
  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      symbol: json['symbol'] as String,
      price: (json['price'] as num).toDouble(),
      change24h: (json['change24h'] as num).toDouble(),
      changePercent24h: (json['changePercent24h'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      high24h: (json['high24h'] as num).toDouble(),
      low24h: (json['low24h'] as num).toDouble(),
      marketCap: (json['marketCap'] as num).toDouble(),
      lastUpdated: json['lastUpdated'] as String? ?? '',
    );
  }

  /// Helper getters
  bool get isPositiveChange => change24h >= 0;
  bool get isNegativeChange => change24h < 0;
}
