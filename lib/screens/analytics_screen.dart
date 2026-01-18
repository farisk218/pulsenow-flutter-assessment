import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/analytics_provider.dart';
import '../models/analytics_model.dart';
import '../shared/widgets/shimmer_widget.dart';
import '../shared/widgets/bottom_nav_bar.dart';
import '../shared/widgets/server_warning_widget.dart';
import '../utils/strings.dart';
import '../core/theme/constant/pulse_now_colors.dart';
import '../core/theme/theme_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AnalyticsProvider>(context, listen: false);
      provider.loadOverview();
      provider.loadTrends();
      provider.loadSentiment();
    });
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
            const Text(AppStrings.analyticsTab),
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
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.overview == null) {
            return _buildShimmerLoading(context);
          }

          if (provider.error != null && provider.overview == null) {
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
                  onRefresh: () async {
                    await provider.loadOverview();
                    await provider.loadTrends();
                    await provider.loadSentiment();
                  },
                  child: AnimationLimiter(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (provider.overview != null)
                            AnimationConfiguration.staggeredList(
                              position: 0,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildOverviewCard(
                                      context, provider.overview!),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          if (provider.trends != null)
                            AnimationConfiguration.staggeredList(
                              position: 1,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildTrendsCard(
                                      context, provider.trends!),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          if (provider.sentiment != null)
                            AnimationConfiguration.staggeredList(
                              position: 2,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildSentimentCard(
                                      context, provider.sentiment!),
                                ),
                              ),
                            ),
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
        ShimmerWidget(height: 200, radius: 16),
        SizedBox(height: 16),
        ShimmerWidget(height: 150, radius: 16),
        SizedBox(height: 16),
        ShimmerWidget(height: 180, radius: 16),
      ],
    );
  }

  Widget _buildErrorState(
      BuildContext context, String error, AnalyticsProvider provider) {
    return ServerWarningWidget(
      onRetry: () {
        provider.loadOverview();
        provider.loadTrends();
        provider.loadSentiment();
      },
    );
  }

  Widget _buildOverviewCard(BuildContext context, AnalyticsOverview overview) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.marketOverview,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    AppStrings.totalMarketCap,
                    '\$${overview.totalMarketCap.toStringAsFixed(0)}',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    AppStrings.volume24h,
                    '\$${overview.totalVolume24h.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (overview.topGainer != null)
              _buildLeaderItem(
                context,
                AppStrings.topGainer,
                overview.topGainer!.symbol,
                overview.topGainer!.change,
                true,
              ),
            if (overview.topLoser != null) ...[
              const SizedBox(height: 8),
              _buildLeaderItem(
                context,
                AppStrings.topLoser,
                overview.topLoser!.symbol,
                overview.topLoser!.change,
                false,
              ),
            ],
            if (overview.marketDominance != null) ...[
              const SizedBox(height: 16),
              Text(
                AppStrings.marketDominance,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildDominanceBar(context, overview.marketDominance!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildLeaderItem(
    BuildContext context,
    String label,
    String symbol,
    double change,
    bool isPositive,
  ) {
    final color = isPositive ? PulseNowColors.secondary : PulseNowColors.danger;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Row(
          children: [
            Text(
              symbol,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 8),
            Text(
              '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDominanceBar(BuildContext context, MarketDominance dominance) {
    final btc = dominance.btc;
    final eth = dominance.eth;
    final others = dominance.others;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: btc.toInt(),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: PulseNowColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Expanded(
              flex: eth.toInt(),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: PulseNowColors.secondary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Expanded(
              flex: others.toInt(),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${AppStrings.btc}: ${btc.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall),
            Text('${AppStrings.eth}: ${eth.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall),
            Text('${AppStrings.others}: ${others.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildTrendsCard(BuildContext context, AnalyticsTrends trends) {
    final change = trends.summary?.change ?? 0;
    final volatility = trends.summary?.volatility ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppStrings.trends} (${trends.timeframe})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    AppStrings.change,
                    '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    AppStrings.volatility,
                    volatility.toStringAsFixed(2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentCard(
      BuildContext context, AnalyticsSentiment sentiment) {
    final score = sentiment.overall?.score ?? 0;
    final label = sentiment.overall?.label ?? 'Neutral';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.marketSentiment,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        score.toString(),
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getSentimentColor(score),
                                ),
                      ),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 8,
                      color: _getSentimentColor(score),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSentimentColor(int score) {
    if (score >= 70) return PulseNowColors.secondary;
    if (score >= 40) return PulseNowColors.primary;
    return PulseNowColors.danger;
  }
}
