import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsenow_flutter/core/theme/constant/pulse_now_colors.dart';
import '../providers/market_data_provider.dart';
import '../models/market_data_model.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../utils/strings.dart';
import '../shared/widgets/shimmer_widget.dart';

class MarketDataScreen extends StatefulWidget {
  const MarketDataScreen({super.key});

  @override
  State<MarketDataScreen> createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MarketDataProvider>(context, listen: false).loadMarketData();
    });
  }

  Future<void> _handleRefresh() async {
    await Provider.of<MarketDataProvider>(context, listen: false).loadMarketData();
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerWidget(
                      width: 100,
                      height: 20,
                      radius: 4,
                    ),
                    ShimmerWidget(
                      width: 80,
                      height: 20,
                      radius: 4,
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    ShimmerWidget(
                      width: 60,
                      height: 16,
                      radius: 4,
                    ),
                    SizedBox(width: 12),
                    ShimmerWidget(
                      width: 80,
                      height: 16,
                      radius: 4,
                    ),
                    Spacer(),
                    ShimmerWidget(
                      width: 70,
                      height: 16,
                      radius: 4,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.marketDataTitle),
      ),
      body: Consumer<MarketDataProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.marketData.isEmpty) {
            return _buildShimmerLoading(context);
          }

          if (provider.error != null && provider.marketData.isEmpty) {
            return _buildErrorState(context, provider.error!, provider);
          }

          if (provider.marketData.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              itemCount: provider.marketData.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final market = provider.marketData[index];
                return _MarketDataListItem(market: market);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, MarketDataProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.errorTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.loadMarketData(),
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noMarketDataAvailable,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}

class _MarketDataListItem extends StatelessWidget {
  final MarketData market;

  const _MarketDataListItem({required this.market});

  @override
  Widget build(BuildContext context) {
    final isPositive = market.isPositiveChange;
    final changeColor = isPositive ?  PulseNowColors.positiveColor : PulseNowColors.negativeColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Row(
          children: [
            Expanded(
              child: Text(
                market.symbol,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Text(
              market.price.formatCurrency(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: changeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: changeColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      market.changePercent24h.formatPercentage(),
                      style: TextStyle(
                        color: changeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                market.change24h.formatCurrency(),
                style: TextStyle(
                  color: changeColor,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                '${AppStrings.volumeLabel}: ${market.volume.formatVolume()}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
