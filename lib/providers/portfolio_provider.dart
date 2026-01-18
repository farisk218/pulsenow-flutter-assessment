import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/portfolio_model.dart';

class PortfolioProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  PortfolioSummary? _summary;
  List<PortfolioHolding> _holdings = [];
  PortfolioPerformance? _performance;
  bool _isLoading = false;
  String? _error;

  PortfolioSummary? get summary => _summary;
  List<PortfolioHolding> get holdings => _holdings;
  PortfolioPerformance? get performance => _performance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPortfolioSummary() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.getPortfolioSummary();
      _summary = PortfolioSummary.fromJson(data);
    } catch (e) {
      _error = 'Server connection failed';
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
      _holdings = data.map((json) => PortfolioHolding.fromJson(json)).toList();
    } catch (e) {
      _error = 'Server connection failed';
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
      final data =
          await _apiService.getPortfolioPerformance(timeframe: timeframe);
      _performance = PortfolioPerformance.fromJson(data);
    } catch (e) {
      _error = 'Server connection failed';
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
      _error = 'Server connection failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
