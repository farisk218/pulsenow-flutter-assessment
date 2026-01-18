import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/market_data_provider.dart';
import '../../core/services/websocket/websocket_service.dart';
import '../../core/theme/constant/pulse_now_colors.dart';

/// Reusable WebSocket connection status indicator
/// 
/// Displays a colored dot indicator that updates in real-time based on
/// WebSocket connection state (connected, disconnected, error, connecting).
/// 
/// Colors:
/// - Green: Connected
/// - Red: Disconnected or Error
/// - Orange: Connecting
class WebSocketConnectionIndicator extends StatelessWidget {
  const WebSocketConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketDataProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<WebSocketConnectionState>(
          stream: provider.webSocketStateStream,
          initialData: provider.webSocketConnectionState,
          builder: (context, snapshot) {
            final state = snapshot.data ?? WebSocketConnectionState.disconnected;
            final isConnected = state == WebSocketConnectionState.connected;
            final isConnecting = state == WebSocketConnectionState.connecting;
            
            Color indicatorColor;
            if (isConnected) {
              indicatorColor = PulseNowColors.secondary;
            } else if (isConnecting) {
              indicatorColor = Colors.orange;
            } else {
              indicatorColor = PulseNowColors.danger;
            }

            return Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
              ),
            );
          },
        );
      },
    );
  }
}
