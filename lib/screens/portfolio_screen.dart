import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../shared/widgets/shimmer_widget.dart';
import '../shared/widgets/bottom_nav_bar.dart';
import '../utils/strings.dart';
import '../utils/formatters.dart';
import '../core/theme/constant/pulse_now_colors.dart';
import '../core/theme/theme_provider.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PortfolioProvider>(context, listen: false);
      provider.loadPortfolioSummary();
      provider.loadHoldings();
    });
  }

  Future<void> _handleRefresh() async {
    final provider = Provider.of<PortfolioProvider>(context, listen: false);
    await provider.loadPortfolioSummary();
    await provider.loadHoldings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.portfolioTab),
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
      body: Consumer<PortfolioProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.summary == null) {
            return _buildShimmerLoading(context);
          }

          if (provider.error != null && provider.summary == null) {
            return _buildErrorState(context, provider.error!, provider);
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (provider.summary != null) _buildSummaryCard(context, provider.summary!),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.holdings,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (provider.holdings.isEmpty)
                    _buildEmptyState(context)
                  else
                    ...provider.holdings.map((holding) => _buildHoldingCard(context, holding)),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ShimmerWidget(height: 150, radius: 16),
        SizedBox(height: 16),
        ShimmerWidget(height: 80, radius: 8),
        SizedBox(height: 8),
        ShimmerWidget(height: 80, radius: 8),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String error, PortfolioProvider provider) {
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
                provider.loadPortfolioSummary();
                provider.loadHoldings();
              },
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, Map<String, dynamic> summary) {
    final totalValue = summary['totalValue'] as String? ?? '0';
    final totalPnl = summary['totalPnl'] as String? ?? '0';
    final totalPnlPercent = summary['totalPnlPercent'] as String? ?? '0';
    final isPositive = (double.tryParse(totalPnl) ?? 0) >= 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.portfolioValue,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '\$$totalValue',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.totalPnL,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$$totalPnl',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isPositive ? PulseNowColors.secondary : PulseNowColors.danger,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.pnlPercent,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${isPositive ? '+' : ''}$totalPnlPercent%',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isPositive ? PulseNowColors.secondary : PulseNowColors.danger,
                              fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildHoldingCard(BuildContext context, Map<String, dynamic> holding) {
    final symbol = holding['symbol'] as String? ?? '';
    final quantity = (holding['quantity'] as num?)?.toDouble() ?? 0;
    final currentPrice = (holding['currentPrice'] as num?)?.toDouble() ?? 0;
    final value = (holding['value'] as num?)?.toDouble() ?? 0;
    final pnl = (holding['pnl'] as num?)?.toDouble() ?? 0;
    final pnlPercent = (holding['pnlPercent'] as num?)?.toDouble() ?? 0;
    final allocation = (holding['allocation'] as num?)?.toDouble() ?? 0;
    final isPositive = pnl >= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  symbol,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${allocation.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.quantity,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      quantity.toStringAsFixed(4),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.value,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      value.formatCurrency(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppStrings.price}: ${currentPrice.formatCurrency()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Row(
                  children: [
                    Text(
                      '${pnl >= 0 ? '+' : ''}${pnl.formatCurrency()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isPositive ? PulseNowColors.secondary : PulseNowColors.danger,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${pnlPercent >= 0 ? '+' : ''}${pnlPercent.formatPercentage()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isPositive ? PulseNowColors.secondary : PulseNowColors.danger,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.account_balance_wallet_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                AppStrings.noHoldings,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
