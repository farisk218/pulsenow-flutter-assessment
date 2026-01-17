import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../utils/constants.dart';

enum WebSocketConnectionState {
  disconnected,
  connecting,
  connected,
  error,
}

class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  final StreamController<Map<String, dynamic>> _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<WebSocketConnectionState> _stateController =
      StreamController<WebSocketConnectionState>.broadcast();

  WebSocketConnectionState _connectionState = WebSocketConnectionState.disconnected;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  int _reconnectAttempts = 0;
  int _missedPongCount = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectInterval = Duration(seconds: 3);
  static const Duration _heartbeatInterval = Duration(seconds: 10);
  static const int _maxMissedPongs = 3;

  WebSocketConnectionState get connectionState => _connectionState;
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<WebSocketConnectionState> get stateStream => _stateController.stream;

  bool get isConnected => _connectionState == WebSocketConnectionState.connected;

  Future<void> connect() async {
    if (_connectionState == WebSocketConnectionState.connected ||
        _connectionState == WebSocketConnectionState.connecting) {
      return;
    }

    _updateConnectionState(WebSocketConnectionState.connecting);

    try {
      final uri = Uri.parse(AppConstants.wsUrl);
      _channel = WebSocketChannel.connect(uri);

      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );

      _updateConnectionState(WebSocketConnectionState.connected);
      _reconnectAttempts = 0;
      _missedPongCount = 0;
      _startHeartbeat();
    } catch (e) {
      _updateConnectionState(WebSocketConnectionState.error);
      _tryReconnect();
    }
  }

  /// Handles incoming WebSocket messages
  ///
  /// Processes pong responses for heartbeat and forwards market update messages
  void _onMessage(dynamic message) {
    try {
      // Handle pong response for heartbeat (backend should respond with "pong" to "ping")
      if (message == 'pong') {
        _missedPongCount = 0;
        return;
      }

      final data = json.decode(message) as Map<String, dynamic>;
      _messageController.add(data);
    } catch (e) {
      // Ignore invalid JSON
    }
  }

  void _onError(dynamic error) {
    _updateConnectionState(WebSocketConnectionState.error);
    _tryReconnect();
  }

  void _onDone() {
    _updateConnectionState(WebSocketConnectionState.disconnected);
    _tryReconnect();
  }

  void _updateConnectionState(WebSocketConnectionState state) {
    if (_connectionState != state) {
      _connectionState = state;
      _stateController.add(state);
    }
  }

  void _tryReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectInterval, () {
      _reconnectAttempts++;
      connect();
    });
  }

  /// Starts heartbeat mechanism to keep connection alive
  ///
  /// Sends "ping" every 10s. Backend should respond with "pong"
  /// (if not implemented, still works via send error detection)
  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      if (_connectionState != WebSocketConnectionState.connected) {
        _stopHeartbeat();
        return;
      }

      try {
        if (_missedPongCount >= _maxMissedPongs) {
          // Connection seems dead (no pong responses), force reconnect
          _stopHeartbeat();
          _updateConnectionState(WebSocketConnectionState.error);
          _tryReconnect();
          return;
        }

        _channel?.sink.add('ping');
        _missedPongCount++;
      } catch (e) {
        // Error sending heartbeat, connection might be dead
        _stopHeartbeat();
        _updateConnectionState(WebSocketConnectionState.error);
        _tryReconnect();
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _missedPongCount = 0;
  }

  void disconnect() {
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _updateConnectionState(WebSocketConnectionState.disconnected);
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _stateController.close();
  }
}
