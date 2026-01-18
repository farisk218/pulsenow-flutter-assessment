/// Analytics data models for API responses

/// Market leader information (top gainer/loser)
class MarketLeader {
  final String symbol;
  final double change;

  const MarketLeader({
    required this.symbol,
    required this.change,
  });

  factory MarketLeader.fromJson(Map<String, dynamic> json) {
    return MarketLeader(
      symbol: json['symbol'] as String? ?? '',
      change: (json['change'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Market dominance data
class MarketDominance {
  final double btc;
  final double eth;
  final double others;

  const MarketDominance({
    required this.btc,
    required this.eth,
    required this.others,
  });

  factory MarketDominance.fromJson(Map<String, dynamic> json) {
    return MarketDominance(
      btc: (json['btc'] as num?)?.toDouble() ?? 0,
      eth: (json['eth'] as num?)?.toDouble() ?? 0,
      others: (json['others'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Analytics Overview Model
/// API: GET /api/analytics/overview
class AnalyticsOverview {
  final double totalMarketCap;
  final double totalVolume24h;
  final MarketLeader? topGainer;
  final MarketLeader? topLoser;
  final MarketDominance? marketDominance;

  const AnalyticsOverview({
    required this.totalMarketCap,
    required this.totalVolume24h,
    this.topGainer,
    this.topLoser,
    this.marketDominance,
  });

  factory AnalyticsOverview.fromJson(Map<String, dynamic> json) {
    return AnalyticsOverview(
      totalMarketCap: (json['totalMarketCap'] as num?)?.toDouble() ?? 0,
      totalVolume24h: (json['totalVolume24h'] as num?)?.toDouble() ?? 0,
      topGainer: json['topGainer'] != null
          ? MarketLeader.fromJson(json['topGainer'] as Map<String, dynamic>)
          : null,
      topLoser: json['topLoser'] != null
          ? MarketLeader.fromJson(json['topLoser'] as Map<String, dynamic>)
          : null,
      marketDominance: json['marketDominance'] != null
          ? MarketDominance.fromJson(json['marketDominance'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Trends summary data
class TrendsSummary {
  final double change;
  final double volatility;

  const TrendsSummary({
    required this.change,
    required this.volatility,
  });

  factory TrendsSummary.fromJson(Map<String, dynamic> json) {
    return TrendsSummary(
      change: (json['change'] as num?)?.toDouble() ?? 0,
      volatility: (json['volatility'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Analytics Trends Model
/// API: GET /api/analytics/trends?timeframe={timeframe}
class AnalyticsTrends {
  final String timeframe;
  final TrendsSummary? summary;

  const AnalyticsTrends({
    required this.timeframe,
    this.summary,
  });

  factory AnalyticsTrends.fromJson(Map<String, dynamic> json) {
    return AnalyticsTrends(
      timeframe: json['timeframe'] as String? ?? '24h',
      summary: json['summary'] != null
          ? TrendsSummary.fromJson(json['summary'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Sentiment overall data
class SentimentOverall {
  final int score; // 0-100
  final String label;

  const SentimentOverall({
    required this.score,
    required this.label,
  });

  factory SentimentOverall.fromJson(Map<String, dynamic> json) {
    return SentimentOverall(
      score: (json['score'] as num?)?.toInt() ?? 0,
      label: json['label'] as String? ?? 'Neutral',
    );
  }
}

/// Analytics Sentiment Model
/// API: GET /api/analytics/sentiment
class AnalyticsSentiment {
  final SentimentOverall? overall;

  const AnalyticsSentiment({
    this.overall,
  });

  factory AnalyticsSentiment.fromJson(Map<String, dynamic> json) {
    return AnalyticsSentiment(
      overall: json['overall'] != null
          ? SentimentOverall.fromJson(json['overall'] as Map<String, dynamic>)
          : null,
    );
  }
}
