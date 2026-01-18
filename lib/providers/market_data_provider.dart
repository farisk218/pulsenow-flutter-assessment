import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/market_data_model.dart';
import '../core/services/websocket/websocket_service.dart';

class MarketDataProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final WebSocketService _webSocketService = WebSocketService();

  List<MarketData> _marketData = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<Map<String, dynamic>>? _wsSubscription;

  List<MarketData> get marketData => _marketData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// WebSocket connection state stream for real-time connection status
  Stream<WebSocketConnectionState> get webSocketStateStream =>
      _webSocketService.stateStream;

  /// Current WebSocket connection state
  WebSocketConnectionState get webSocketConnectionState =>
      _webSocketService.connectionState;

  /// Whether WebSocket is currently connected
  bool get isWebSocketConnected => _webSocketService.isConnected;

  MarketDataProvider() {
    _initWebSocket();
  }

  void _initWebSocket() {
    _wsSubscription = _webSocketService.messageStream.listen((message) {
      if (message['type'] == 'market_update') {
        _handleMarketUpdate(message['data'] as Map<String, dynamic>);
      }
    });
  }

  /// Handles real-time market updates from WebSocket
  ///
  /// Updates matching symbol in the list and recalculates change percentage
  void _handleMarketUpdate(Map<String, dynamic> updateData) {
    final symbol = updateData['symbol'] as String?;
    if (symbol == null) return;

    final index = _marketData.indexWhere((m) => m.symbol == symbol);
    if (index != -1) {
      final existing = _marketData[index];

      // Safe number parsing (handles both string and num types from WebSocket)
      double? parseDouble(dynamic value) {
        if (value == null) return null;
        if (value is num) return value.toDouble();
        if (value is String) {
          return double.tryParse(value);
        }
        return null;
      }

      // Recalculate changePercent24h if price changed
      final newPrice = parseDouble(updateData['price']) ?? existing.price;
      final priceChange = newPrice - existing.price;
      final newChangePercent24h = existing.price != 0
          ? (priceChange / existing.price) * 100
          : existing.changePercent24h;

      final updated = MarketData(
        symbol: existing.symbol,
        price: newPrice,
        change24h: parseDouble(updateData['change24h']) ?? existing.change24h,
        changePercent24h: newChangePercent24h,
        volume: parseDouble(updateData['volume']) ?? existing.volume,
        description: existing.description,
        high24h: existing.high24h,
        low24h: existing.low24h,
        marketCap: existing.marketCap,
        lastUpdated: updateData['timestamp'] as String? ?? existing.lastUpdated,
      );

      _marketData[index] = updated;
      notifyListeners();
    }
  }

  Future<void> loadMarketData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.getMarketData();
      _marketData = data.map((json) => MarketData.fromJson(json)).toList();

      // Connect WebSocket after initial data load
      if (!_webSocketService.isConnected) {
        await _webSocketService.connect();
      }
    } catch (e) {
      _error = 'Server connection failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _webSocketService.dispose();
    super.dispose();
  }
}
