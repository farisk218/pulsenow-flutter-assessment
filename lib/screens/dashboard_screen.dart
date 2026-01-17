import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_data_provider.dart';
import '../models/market_data_model.dart';
import '../utils/formatters.dart';
import '../utils/strings.dart';
import '../shared/widgets/shimmer_widget.dart';
import '../shared/widgets/bottom_nav_bar.dart';
import '../core/theme/constant/pulse_now_colors.dart';
import '../core/theme/theme_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _filter = AppStrings.all;

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

  List<MarketData> _getFilteredMarkets(List<MarketData> markets) {
    switch (_filter) {
      case AppStrings.gainers:
        return markets.where((m) => m.isPositiveChange).toList()
          ..sort((a, b) => b.changePercent24h.compareTo(a.changePercent24h));
      case AppStrings.losers:
        return markets.where((m) => m.isNegativeChange).toList()
          ..sort((a, b) => a.changePercent24h.compareTo(b.changePercent24h));
      default:
        return markets;
    }
  }

  MarketData? _getTopGainer(List<MarketData> markets) {
    if (markets.isEmpty) return null;
    return markets.reduce((a, b) => a.changePercent24h > b.changePercent24h ? a : b);
  }

  MarketData? _getTopLoser(List<MarketData> markets) {
    if (markets.isEmpty) return null;
    return markets.reduce((a, b) => a.changePercent24h < b.changePercent24h ? a : b);
  }

  double _getAverageChange(List<MarketData> markets) {
    if (markets.isEmpty) return 0;
    final sum = markets.fold<double>(0, (sum, m) => sum + m.changePercent24h);
    return sum / markets.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(AppStrings.pulseMarket),
            const SizedBox(width: 12),
            Consumer<MarketDataProvider>(
              builder: (context, provider, child) {
                final isConnected = provider.error == null && !provider.isLoading;
                return Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isConnected ? PulseNowColors.secondary : PulseNowColors.danger,
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            tooltip: AppStrings.toggleTheme,
          ),
        ],
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

          final filteredMarkets = _getFilteredMarkets(provider.marketData);
          final topGainer = _getTopGainer(provider.marketData);
          final topLoser = _getTopLoser(provider.marketData);
          final avgChange = _getAverageChange(provider.marketData);

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: CustomScrollView(
              slivers: [
                _buildQuickStats(context, topGainer, topLoser, avgChange, provider.marketData.length),
                _buildMarketListHeader(context),
                _buildMarketList(context, filteredMarkets),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    MarketData? topGainer,
    MarketData? topLoser,
    double avgChange,
    int totalMarkets,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (topGainer != null)
                _buildStatCard(
                  context,
                  AppStrings.topGainer24h,
                  topGainer.symbol,
                  topGainer.changePercent24h,
                  true,
                ),
              if (topLoser != null) ...[
                const SizedBox(width: 12),
                _buildStatCard(
                  context,
                  AppStrings.topLoser24h,
                  topLoser.symbol,
                  topLoser.changePercent24h,
                  false,
                ),
              ],
              const SizedBox(width: 12),
              _buildStatCard(
                context,
                AppStrings.totalMarkets,
                '$totalMarkets ${AppStrings.assets}',
                avgChange,
                avgChange >= 0,
                showPercent: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    double change,
    bool isPositive, {
    bool showPercent = false,
  }) {
    final color = isPositive ? PulseNowColors.secondary : PulseNowColors.danger;

    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              showPercent
                  ? '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%'
                  : '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketListHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.markets,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFilterChip(context, AppStrings.all),
                  _buildFilterChip(context, AppStrings.gainers),
                  _buildFilterChip(context, AppStrings.losers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    final isSelected = _filter == label;
    return GestureDetector(
      onTap: () => setState(() => _filter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  Widget _buildMarketList(BuildContext context, List<MarketData> markets) {
    if (markets.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            AppStrings.noMarketsFound,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final market = markets[index];
          return _MarketListItem(market: market);
        },
        childCount: markets.length,
      ),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ShimmerWidget(height: 40, radius: 4),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: ShimmerWidget(height: 120, radius: 12)),
            SizedBox(width: 12),
            Expanded(child: ShimmerWidget(height: 120, radius: 12)),
          ],
        ),
        SizedBox(height: 16),
        ShimmerWidget(height: 80, radius: 8),
        SizedBox(height: 8),
        ShimmerWidget(height: 80, radius: 8),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String error, MarketDataProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: PulseNowColors.danger),
            const SizedBox(height: 16),
            Text(
              AppStrings.errorTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                provider.loadMarketData();
              },
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppStrings.noMarketDataAvailable,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketListItem extends StatelessWidget {
  final MarketData market;

  const _MarketListItem({required this.market});

  @override
  Widget build(BuildContext context) {
    final isPositive = market.isPositiveChange;
    final changeColor = isPositive ? PulseNowColors.secondary : PulseNowColors.danger;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${market.symbol} ${AppStrings.detailsComingSoon}')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      market.symbol,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '24h Vol: ${market.volume.formatVolume()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    market.price.formatCurrency(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: changeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${market.change24h >= 0 ? '+' : ''}${market.change24h.formatCurrency()}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: changeColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          market.changePercent24h.formatPercentage(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: changeColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
