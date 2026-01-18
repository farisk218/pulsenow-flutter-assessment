import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/portfolio_provider.dart';
import '../models/portfolio_model.dart';
import '../shared/widgets/shimmer_widget.dart';
import '../shared/widgets/bottom_nav_bar.dart';
import '../shared/widgets/server_warning_widget.dart';
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? PulseNowColors.darkSurface
                    : PulseNowColors.lightSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/images/pulse-logo.jpeg',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            const Text(AppStrings.portfolioTab),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
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

          return Column(
            children: [
              if (provider.isLoading)
                const LinearProgressIndicator(
                  minHeight: 2,
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: AnimationLimiter(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (provider.summary != null)
                            AnimationConfiguration.staggeredList(
                              position: 0,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildSummaryCard(
                                      context, provider.summary!),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          AnimationConfiguration.staggeredList(
                            position: 1,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Text(
                                  AppStrings.holdings,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (provider.holdings.isEmpty)
                            _buildEmptyState(context)
                          else
                            ...provider.holdings.asMap().entries.map((entry) {
                              final index = entry.key;
                              final holding = entry.value;
                              return AnimationConfiguration.staggeredList(
                                position: index + 2,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: _buildHoldingCard(context, holding),
                                  ),
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

  Widget _buildErrorState(
      BuildContext context, String error, PortfolioProvider provider) {
    return ServerWarningWidget(
      onRetry: () {
        provider.loadPortfolioSummary();
        provider.loadHoldings();
      },
    );
  }

  Widget _buildSummaryCard(BuildContext context, PortfolioSummary summary) {
    final totalValue = summary.totalValue;
    final totalPnl = summary.totalPnl;
    final totalPnlPercent = summary.totalPnlPercent;
    final isPositive = summary.isPositive;

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
                              color: isPositive
                                  ? PulseNowColors.secondary
                                  : PulseNowColors.danger,
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
                              color: isPositive
                                  ? PulseNowColors.secondary
                                  : PulseNowColors.danger,
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

  Widget _buildHoldingCard(BuildContext context, PortfolioHolding holding) {
    final isPositive = holding.isPositive;

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
                  holding.symbol,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${holding.allocation.toStringAsFixed(1)}%',
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
                      holding.quantity.toStringAsFixed(4),
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
                      holding.value.formatCurrency(),
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
                  '${AppStrings.price}: ${holding.currentPrice.formatCurrency()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Row(
                  children: [
                    Text(
                      '${holding.pnl >= 0 ? '+' : ''}${holding.pnl.formatCurrency()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isPositive
                                ? PulseNowColors.secondary
                                : PulseNowColors.danger,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${holding.pnlPercent >= 0 ? '+' : ''}${holding.pnlPercent.formatPercentage()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isPositive
                                ? PulseNowColors.secondary
                                : PulseNowColors.danger,
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
              Icon(Icons.account_balance_wallet_outlined,
                  size: 64, color: Colors.grey[400]),
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
