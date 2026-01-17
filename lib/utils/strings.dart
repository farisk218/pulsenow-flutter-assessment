/// App-wide string constants
///
/// All user-facing strings are centralized here for easy translation.
/// To add translations in the future:
/// 1. Add easy_localization package
/// 2. Create translation files (en.json, es.json, etc.)
/// 3. Replace static const with getter methods that use .tr()
///
/// Example future implementation:
/// ```dart
/// static String get appTitle => 'appTitle'.tr();
/// ```
class AppStrings {
  AppStrings._();

  // App
  static const String appTitle = 'PulseNow';

  // Market Data Screen
  static const String marketDataTitle = 'Market Data';
  static const String errorTitle = 'Error';
  static const String retry = 'Retry';
  static const String noMarketDataAvailable = 'No market data available';
  static const String volumeLabel = 'Vol';

  // Error messages
  static const String failedToLoadMarketData = 'Failed to load market data';
  static const String networkError = 'Network error';
  static const String unknownError = 'Unknown error';
}

