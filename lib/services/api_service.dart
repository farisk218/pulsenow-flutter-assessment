import '../core/services/http/http_service.dart';
import '../utils/constants.dart';

class ApiService {
  Future<List<Map<String, dynamic>>> getMarketData() async {
    final jsonData = await HttpService.get(AppConstants.marketDataEndpoint);

    if (jsonData['success'] == true && jsonData['data'] != null) {
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      final errorMsg =
          jsonData['error']?['message'] ?? 'Failed to load market data';
      throw Exception(errorMsg);
    }
  }
}
