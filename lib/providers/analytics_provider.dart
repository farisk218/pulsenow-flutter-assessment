import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AnalyticsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, dynamic>? _overview;
  Map<String, dynamic>? _trends;
  Map<String, dynamic>? _sentiment;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get overview => _overview;
  Map<String, dynamic>? get trends => _trends;
  Map<String, dynamic>? get sentiment => _sentiment;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadOverview() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _overview = await _apiService.getAnalyticsOverview();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTrends({String timeframe = '24h'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _trends = await _apiService.getAnalyticsTrends(timeframe: timeframe);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSentiment() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sentiment = await _apiService.getAnalyticsSentiment();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
