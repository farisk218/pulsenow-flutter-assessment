import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/analytics_model.dart';

class AnalyticsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  AnalyticsOverview? _overview;
  AnalyticsTrends? _trends;
  AnalyticsSentiment? _sentiment;
  bool _isLoading = false;
  String? _error;

  AnalyticsOverview? get overview => _overview;
  AnalyticsTrends? get trends => _trends;
  AnalyticsSentiment? get sentiment => _sentiment;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadOverview() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.getAnalyticsOverview();
      _overview = AnalyticsOverview.fromJson(data);
    } catch (e) {
      _error = 'Server connection failed';
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
      final data = await _apiService.getAnalyticsTrends(timeframe: timeframe);
      _trends = AnalyticsTrends.fromJson(data);
    } catch (e) {
      _error = 'Server connection failed';
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
      final data = await _apiService.getAnalyticsSentiment();
      _sentiment = AnalyticsSentiment.fromJson(data);
    } catch (e) {
      _error = 'Server connection failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
