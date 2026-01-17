import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/analytics_screen.dart';
import '../../screens/portfolio_screen.dart';

/// App router configuration using go_router
/// 
/// Routes:
/// - `/` - Dashboard (Markets)
/// - `/analytics` - Analytics screen
/// - `/portfolio` - Portfolio screen
class AppRouter {
  static const String dashboard = '/';
  static const String analytics = '/analytics';
  static const String portfolio = '/portfolio';

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: dashboard,
    routes: [
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: analytics,
        name: 'analytics',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AnalyticsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: portfolio,
        name: 'portfolio',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PortfolioScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    ],
  );
}

