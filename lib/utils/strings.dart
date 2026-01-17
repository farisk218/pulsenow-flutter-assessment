/// App-wide string constants
///
/// All user-facing strings are centralized here for easy translation.
/// To add translations in the future:
/// 1. Add easy_localization package
/// 2. Create translation files (en.json, es.json, etc.)
/// 3. Replace static const with getter methods that use .tr()
class AppStrings {
  AppStrings._();

  // App
  static const String appTitle = 'PulseNow';
  static const String pulseMarket = 'Pulse Market';

  // Navigation
  static const String marketsTab = 'Markets';
  static const String analyticsTab = 'Analytics';
  static const String portfolioTab = 'Portfolio';
  static const String alertsTab = 'Alerts';

  // Common
  static const String errorTitle = 'Error';
  static const String retry = 'Retry';
  static const String comingSoon = 'Coming soon';
  static const String toggleTheme = 'Toggle theme';
  static const String detailsComingSoon = 'details coming soon';

  // Market Data
  static const String marketDataTitle = 'Market Data';
  static const String noMarketDataAvailable = 'No market data available';
  static const String volumeLabel = 'Vol';
  static const String markets = 'Markets';
  static const String all = 'All';
  static const String gainers = 'Gainers';
  static const String losers = 'Losers';
  static const String noMarketsFound = 'No markets found';

  // Quick Stats
  static const String topGainer24h = 'Top Gainer (24h)';
  static const String topLoser24h = 'Top Loser (24h)';
  static const String totalMarkets = 'Total Markets';
  static const String assets = 'assets';

  // Analytics
  static const String marketOverview = 'Market Overview';
  static const String totalMarketCap = 'Total Market Cap';
  static const String volume24h = '24h Volume';
  static const String topGainer = 'Top Gainer';
  static const String topLoser = 'Top Loser';
  static const String marketDominance = 'Market Dominance';
  static const String trends = 'Trends';
  static const String change = 'Change';
  static const String volatility = 'Volatility';
  static const String marketSentiment = 'Market Sentiment';
  static const String btc = 'BTC';
  static const String eth = 'ETH';
  static const String others = 'Others';

  // Portfolio
  static const String portfolioValue = 'Portfolio Value';
  static const String totalPnL = 'Total P&L';
  static const String pnlPercent = 'P&L %';
  static const String holdings = 'Holdings';
  static const String noHoldings = 'No holdings';
  static const String quantity = 'Quantity';
  static const String value = 'Value';
  static const String price = 'Price';

  // Error messages
  static const String failedToLoadMarketData = 'Failed to load market data';
  static const String networkError = 'Network error';
  static const String unknownError = 'Unknown error';
}
