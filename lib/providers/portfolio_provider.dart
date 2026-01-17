import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class PortfolioProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, dynamic>? _summary;
  List<Map<String, dynamic>> _holdings = [];
  Map<String, dynamic>? _performance;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get summary => _summary;
  List<Map<String, dynamic>> get holdings => _holdings;
  Map<String, dynamic>? get performance => _performance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPortfolioSummary() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _summary = await _apiService.getPortfolioSummary();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHoldings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.getPortfolioHoldings();
      _holdings = data;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPerformance({String timeframe = '7d'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _performance = await _apiService.getPortfolioPerformance(timeframe: timeframe);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction({
    required String type,
    required String symbol,
    required double quantity,
    required double price,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.addTransaction(
        type: type,
        symbol: symbol,
        quantity: quantity,
        price: price,
      );
      // Reload holdings after adding transaction
      await loadHoldings();
      await loadPortfolioSummary();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
