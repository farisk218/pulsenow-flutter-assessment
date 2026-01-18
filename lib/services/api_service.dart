import '../core/services/http/http_service.dart';
import '../utils/constants.dart';

class ApiService {
  /// Check server health status
  /// 
  /// Returns server health information including status and timestamp
  Future<Map<String, dynamic>> checkHealth() async {
    try {
      final jsonData = await HttpService.getRoot(AppConstants.healthEndpoint);
      return jsonData;
    } catch (e) {
      throw Exception('Health check failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMarketData() async {
    final jsonData = await HttpService.get(AppConstants.marketDataEndpoint);

    if (jsonData['success'] == true && jsonData['data'] != null) {
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      final errorMsg = jsonData['error']?['message'] ?? 'Failed to load market data';
      throw Exception(errorMsg);
    }
  }

  Future<Map<String, dynamic>> getAnalyticsOverview() async {
    final jsonData = await HttpService.get('${AppConstants.analyticsEndpoint}/overview');

    if (jsonData['success'] == true && jsonData['data'] != null) {
      return jsonData['data'] as Map<String, dynamic>;
    } else {
      final errorMsg = jsonData['error']?['message'] ?? 'Failed to load analytics overview';
      throw Exception(errorMsg);
    }
  }

  Future<Map<String, dynamic>> getAnalyticsTrends({String timeframe = '24h'}) async {
    final jsonData = await HttpService.get('${AppConstants.analyticsEndpoint}/trends?timeframe=$timeframe');

    if (jsonData['success'] == true && jsonData['data'] != null) {
      return jsonData['data'] as Map<String, dynamic>;
    } else {
      final errorMsg = jsonData['error']?['message'] ?? 'Failed to load analytics trends';
      throw Exception(errorMsg);
    }
  }

  Future<Map<String, dynamic>> getAnalyticsSentiment() async {
    final jsonData = await HttpService.get('${AppConstants.analyticsEndpoint}/sentiment');

    if (jsonData['success'] == true && jsonData['data'] != null) {
      return jsonData['data'] as Map<String, dynamic>;
    } else {
      final errorMsg = jsonData['error']?['message'] ?? 'Failed to load analytics sentiment';
      throw Exception(errorMsg);
    }
  }

  Future<Map<String, dynamic>> getPortfolioSummary() async {
    final jsonData = await HttpService.get(AppConstants.portfolioEndpoint);

    if (jsonData['success'] == true && jsonData['data'] != null) {
      return jsonData['data'] as Map<String, dynamic>;
    } else {
      final errorMsg = jsonData['error']?['message'] ?? 'Failed to load portfolio summary';
      throw Exception(errorMsg);
    }
  }

  Future<List<Map<String, dynamic>>> getPortfolioHoldings() async {
    final jsonData = await HttpService.get('${AppConstants.portfolioEndpoint}/holdings');

    if (jsonData['success'] == true && jsonData['data'] != null) {
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      final errorMsg = jsonData['error']?['message'] ?? 'Failed to load portfolio holdings';
      throw Exception(errorMsg);
    }
  }

  Future<Map<String, dynamic>> getPortfolioPerformance({String timeframe = '7d'}) async {
    final jsonData = await HttpService.get('${AppConstants.portfolioEndpoint}/performance?timeframe=$timeframe');

    if (jsonData['success'] == true && jsonData['data'] != null) {
      return jsonData['data'] as Map<String, dynamic>;
    } else {
      final errorMsg = jsonData['error']?['message'] ?? 'Failed to load portfolio performance';
      throw Exception(errorMsg);
    }
  }

  Future<Map<String, dynamic>> addTransaction({
    required String type,
    required String symbol,
    required double quantity,
    required double price,
  }) async {
    final body = {
      'type': type,
      'symbol': symbol,
      'quantity': quantity,
      'price': price,
    };

    final jsonData = await HttpService.post('${AppConstants.portfolioEndpoint}/transactions', body: body);

    if (jsonData['success'] == true && jsonData['data'] != null) {
      return jsonData['data'] as Map<String, dynamic>;
    } else {
      final errorMsg = jsonData['error']?['message'] ?? 'Failed to add transaction';
      throw Exception(errorMsg);
    }
  }
}
